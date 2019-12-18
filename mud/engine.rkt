#lang racket
(require "./logger.rkt")
(require "./data-structures/event.rkt")
(require "./data-structures/mud-library.rkt")
(require "./data-structures/mud-server.rkt")
(require "./data-structures/service.rkt")
(require "./utilities/string.rkt")

(provide schedule
         load-mud
         start-mud
         run-mud
         stop-mud
         tock
         loaded-server)

(define loaded-server (void))
(define known-events (make-hash))
(define scheduled-events (list))
(define known-services (list))
(define tickable-services (list))

(define (load-mud mud-server)
  (set! loaded-server mud-server)
  (log-debug "Loading ~a version ~a" (mud-server-id loaded-server)
             (mud-server-version loaded-server))
  (for-each (lambda (mudlib)
              (load-mud-library mudlib))
            (mud-server-libraries loaded-server))
  (log-info "Loading complete with ~a known events and ~a known services, ~a of which are tickable. The following libraries are loaded: ~a" 
            (length (hash-keys known-events)) (length known-services) (length tickable-services)
            (oxfordize-list (map (lambda (library) (mud-library-id library)) (mud-server-libraries loaded-server)))))

(define (load-mud-library library)
  (let ([events (mud-library-events library)]
        [services (mud-library-services library)]
        [id (mud-library-id library)])
    (log-debug "Loading the ~a mud library." id)
    (for-each (lambda (event)
                (hash-set! known-events (event-id event) event))
              events)
    (for-each (lambda (service)
                (load-service service))
              services)
    (log-info "Loaded ~a events and ~a services from the ~a library"
              (length events) (length services) id)))


;  (current-logger (make-logger 'Engine-load-mud mudlogger))
;  (log-debug "called with events ~a and services ~a"
;             (hash-keys events)
;             (service-ids services))
;  (set! known-events events)
;  (set! known-services services)
;  (load-services services)
;  (log-debug "complete")
;  #t)

(define (load-service service)
  (log-debug "Loading the ~a service." (service-id service))
  (let ([id (service-id service)]
        [load-proc (service-load-proc service)]
        [tick-proc (service-tick-proc service)])
    (set! known-services (append known-services (list service)))
    (when (procedure? load-proc)
      (log-debug "It has a load procedure, calling it.")
      (load-proc))
    (when (procedure? tick-proc)
      (log-debug "It has a tick procedure: adding this service to the list of tickable services.")
      (set! tickable-services (append tickable-services (list service))))))

(define (start-mud)
  (log-info "Starting the MUD.")
  (for-each (lambda (service) (let ([start-proc (service-start-proc service)])
                               (when (procedure? start-proc)
                                 (log-debug "Starting the ~a service." (service-id service))
                                 (start-proc))))
           known-services))

(define (run-mud)
  (log-debug "Running the MUD engine.")
  (with-handlers
      ([exn:break?
        (lambda (exc)
          (log-info "A break has been caught: stopping the MUD.")
          (stop-mud))])
    (tick)))

(define (tick)
  (tock)
  (tick))

(define (tock)
  (when (> (length scheduled-events) 0)
    (for-each (lambda (event)
           (call-event event)
           (set! scheduled-events (remove event scheduled-events)))
         scheduled-events))
    (for-each (lambda (service) ((service-tick-proc service)))
         tickable-services))

(define (stop-mud)
  (log-info "Stopping the MUD.")
  (for-each (lambda (service)
         (let ([stop-proc (service-stop-proc service)])
           (when (procedure? stop-proc)
             (stop-proc))))
       known-services)
  (log-info "The MUD has stopped."))

(define (schedule event payload)
  (cond
    [(hash-has-key? known-events event)
     (set! scheduled-events
           (append scheduled-events (list (list event payload))))]
    [else
     (log-warning "Tried to schedule unknown event ~a" event)]))

(define (call-event event-load)
  (let ([event (car event-load)]
        [payload (cdr event-load)])
    (when (hash-has-key? known-events event)
      ((event-procedure (hash-ref known-events event)) (car payload)))))