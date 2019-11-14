#lang racket
;; Requirements
;;;;;;; Basic requirements
(require libuuid)
;; Data Structures
;;;;;;; Service structure
(struct service (id load-proc start-proc tick-proc stop-proc))
;;;;;;; Thing structure
(struct thing (id names qualities))
;;; Stateful variables
;;;;;;; Extant things
(define extant-things (make-hash))
;;;;;;; Scheduled events
(define scheduled-events (list))
;;;;;;; Tickable services
(define tickable-services (make-hash))
;; Procedures
;;; Logging procedures
;;;;;;;; (setenv "PLTSTDERR" "warning debug@MUD")
(define (mudlog-debug message)
  (log-message (current-logger) 'debug 'MUD message))
(define (mudlog-info message)
  (log-message (current-logger) 'info 'MUD message))
(define (mudlog-warning message)
  (log-message (current-logger) 'warning 'MUD message))
(define (mudlog-error message)
  (log-message (current-logger) 'error 'MUD message))
(define (mudlog-fatal message)
  (log-message (current-logger) 'fatal 'MUD message))
;;; Thing procedures
;;;;;;; Create Thing
(define (create-thing)
  (let ([new-thing (thing (generate-thing-id) (list "thing") (make-hash))])
    (hash-set! extant-things (thing-id new-thing) new-thing)
  new-thing))
;;;;;;; Destroy Thing
(define (destroy-thing id)
  (hash-remove! extant-things id))
;;;;;;; Set Thing quality
(define (set-thing-quality thing quality value)
  (hash-set! (thing-qualities thing) quality value))
;;;;;;; Set Thing qualities
(define (set-thing-qualities thing qualities)
  (map (lambda (quality)
         (set-thing-quality thing (car quality) (car (cdr quality))))
       qualities))
;;;;;;; Get Thing quality
(define (get-thing-quality thing quality)
  (hash-ref (thing-qualities thing) quality))
;;;;;;; Generate Thing ID
(define (generate-thing-id)
  (let ([potential-id (substring (uuid-generate/random) 0 35)])
    ; if the ID is in the Table of Extant Things, try again.
    (cond
     [(hash-has-key? extant-things potential-id)
      (generate-thing-id)]
     [else
      potential-id])))
;;; Loading procedures
;;;;;;; Load
(define (load-mud)
  (mudlog-info "Engine's load procedure has been called.")
  (load-services known-services)
  (mudlog-info "Engine's load procedure has completed."))
;;;;;;; Load services
(define (load-services services)
  (map (lambda (service)
         (let ([load-proc (service-load-proc service)]
               [tick-proc (service-tick-proc service)]
               [id (service-id service)])
           (when (procedure? load-proc)
             (mudlog-debug
              (format "Engine attempting to load ~a service" id))
             (load-proc))
           (when (procedure? tick-proc)
             (mudlog-debug
              (format "Engine adding ~a to list of tickable services." id))
             (hash-set! tickable-services
                        (service-id service)
                        tick-proc))))
       services))
;;; Starting procedures
;;;;;;; Start
(define (start-mud)
  (mudlog-info "Engine's start procedure has been called.")
  (start-services known-services)
  (mudlog-info "Engine's start procedure has completed."))
;;;;;;; Start services
(define (start-services services)
  (map (lambda (service)
    (let ([start-proc (service-start-proc service)])
      (if (procedure? start-proc)
        (start-proc)
	#f)))
    services))
;;; Run procedures
;;;;;;; Run
(define (run-mud)
  (mudlog-info "Engine's run procedure has been called.")
  (with-handlers
    ([exn:break?
      (lambda (exc)
        (mudlog-info "Engine's run procedure has been broken.")
        (stop-mud))])
    (tick)))
;;; Tick procedures
;;;;;;; Tick
(define (tick)
  (tock)
  (tick))
;;;;;;; Tock
(define (tock)
  (map (lambda (tick-proc) (tick-proc)) (hash-values tickable-services))
  (map (lambda (event)
         (call-event event))
       scheduled-events)
  (set! scheduled-events (list)))
;;;;;;; Tick services
(define (tick-services services)
  (map (lambda (service)
    (let ([tick-proc (service-tick-proc service)])
      (if (procedure? tick-proc)
        (tick-proc)
        #f)))
    services))
;;; Stop procedures
;;;;;; Stop
(define (stop-mud)
  (mudlog-info "Engine's stop procedure has been called.")
  (map (lambda (service)
         (let ([stop-proc (service-stop-proc service)])
           (when (procedure? stop-proc)
             (stop-proc))))
       known-services)
  (mudlog-info "Engine's stop procedure has completed."))
;;; Scheduling procedures
;;;;;;; Schedule
(define (schedule event payload)
  (mudlog-debug
   (format "Scheduling ~a event with payload ~a" event payload))
  (cond
    [(hash-has-key? known-events event)
     (set! scheduled-events (append scheduled-events (list (list event payload))))]
   [else #f]))
;;;;;;; Call Event
(define (call-event event-load)
  (let ([event (car event-load)]
        [payload (cdr event-load)])
    (when (hash-has-key? known-events event)
      (mudlog-debug (format "Calling ~a event" event))
      ((hash-ref known-events event) (car payload)))))
;;; Service Procedures
;;;; MUDSocket service procedures
;;;;;;; Load MUDSocket
(define (load-mudsocket)
  (mudlog-info "MUDSocket service's load procedure has been called.")
  (log-debug "Loading the MUDSocket")
  (mudlog-info "MUDSocket service's load procedure has completed."))
;;;;;;; Start MUDSocket
(define (start-mudsocket)
  (mudlog-info "MUDSocket service's start procedure has been called.")
  (set! socket-listener (tcp-listen 4242 5 #t))
  (mudlog-info "MUDSocket service's start procedure has completed.")
  )
(define (tick-mudsocket)
  ; when there's a new connection:
  (when (tcp-accept-ready? socket-listener)
    (mudlog-debug "MUDSocket service has new connection to accept.")
    (define-values (in out) (tcp-accept socket-listener))
    (define-values (lip lport rip rport) (tcp-addresses in #t))
    (mudlog-debug
     (format "MUDSocket service has accepted a connection from ~a:~a"
             rip rport))
    (let ([new-thing (create-mudsocket-client in out rip rport)])
      (hash-set! socket-connections (thing-id new-thing) new-thing)
      (schedule "send"
                (hash 'recipient new-thing
                      'message (format
                                 "You've connected to Racket-MUD and been associated with thing ~a" (thing-id new-thing))))))
  ; for existing connections:
  (hash-map socket-connections
            (lambda (id thing)
              (let ([thing-in (get-thing-quality thing 'socket-in)]
                    [thing-out (get-thing-quality thing 'socket-out)])
                (cond
                  ; If the client disconnected
                  [(port-closed? thing-in)
                   (mudlog-debug
                    (format
                     "MUDSocket service disconnecting thing ~a"
                     id))
                   ; TODO: remove thing from extant-things
                   (hash-remove! socket-connections id)]
                  ; If the client submitted a line
                  [(byte-ready? thing-in)
                  (let ([line-in (read-line thing-in)])
                    (mudlog-debug
                     (format "MUDSocket received a message from thing ~a~n\t~a"
                             (thing-id thing) line-in))
                    (schedule "parse"
                              (hash 'client thing
                                    'line line-in)))])
                (let ([messages-buffer (get-thing-quality thing 'messages-buffer)])
                  (when (> (string-length messages-buffer) 0)
                    (send-to-client-through-mudsocket thing messages-buffer)
                    (set-thing-quality thing 'messages-buffer "")))))))

(define (stop-mudsocket)
  (mudlog-info "MUDSocket service stop procedure has been called.")
  ;; This doesn't seem to actually disconnect clients. Ahh well. They'll figure it out eventually.
  (tcp-close socket-listener)
  (mudlog-info "MUDSocket service stop procedure has completed."))

;;;;;;; Send to Thing, through MUDSocket
(define (send-to-client-through-mudsocket client message)
      (when (hash-has-key? (thing-qualities client) 'socket-out)
        (let ([out (hash-ref (thing-qualities client) 'socket-out)])
          (display (format "~a~n" message) out)
          (flush-output out))))
;;;;;;; Create client Thing
(define (create-mudsocket-client in out ip port)
  (mudlog-debug "MUDSocket service is creating a new client thing.")
  (let ([new-thing (create-thing)])
    (set-thing-qualities
     new-thing
     (list
      (list 'socket-in in)
      (list 'socket-out out)
      (list 'remote-ip ip)
      (list 'remote-port port)
      (list 'messages-buffer "")
      (list 'send-procedure send-to-client-through-mudsocket)))
    new-thing))
;;; Event procedures
;;;;;;; Send event
(define (send-event payload)
  (mudlog-debug (format "Send event called with payload ~a" payload))
  (when (hash-has-key? payload 'recipient)
    (mudlog-debug "aahhhhh!")
    (let ([recipient (hash-ref payload 'recipient)])
      (mudlog-debug (format "Send event has recipient ~a" recipient))
      (when (hash-has-key? (thing-qualities recipient) 'send-procedure)
        ((hash-ref (thing-qualities recipient) 'send-procedure)
         recipient
         (hash-ref payload 'message))))))
;;;;;;; Test event
(define (test-event payload)
  (mudlog-debug (format "Test event triggered with payload: ~a" payload))
  (printf (format "Triggered test event, ~a~n" payload)))
;; Variables
;;; Pre-configured variables
;;;; Service definitions
;;;;; MUDSocket service
(define mudsocket-service
  (service "mudsocket"
           load-mudsocket
           start-mudsocket
           tick-mudsocket
           stop-mudsocket))
;;;;; Test service
(define test-service
  (service "test"
           #f #f #f #f))
;;;;;;; Known services
(define known-services (list
                          test-service
                          mudsocket-service))
;;;;;;; Known events
(define known-events (hash
                      "test" test-event
                      "send" send-event))
;;; Service variables
;;;; MUDSocket service variables
(define socket-listener (void))
(define socket-port 4242)
(define socket-connections (make-hash))
