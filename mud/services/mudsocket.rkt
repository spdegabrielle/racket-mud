#lang racket

(require "../service.rkt")
(require "../thing.rkt")

(provide
 mudsocket-service)

(define socket-listener (void))
(define socket-port 4242)
(define socket-connections (make-hash))

(define (load-mudsocket)
  #t)

(define (start-mudsocket)
  (set! socket-listener (tcp-listen 4242 5 #t))
  #t)

(define (tick-mudsocket)
  ; when there's a new connection:
  ; -> create a new thing
  ; -> give it a mudsocket-connection quality, its value a pair of in/out from tcp-accept
  (when (tcp-accept-ready? socket-listener)
    (let ([new-thing (create-thing)])
      (define-values (in out) (tcp-accept socket-listener))
      (define-values (lip lport rip rport) (tcp-addresses in #t))
      (set-thing-qualities
       new-thing
       (list
        (list 'socket-in in)
        (list 'socket-out out)
        (list 'remote-ip rip)
        (list 'remote-port rport)
        (list 'messages-buffer "")))
      (hash-set! socket-connections (thing-id new-thing) new-thing)
      (set-thing-quality new-thing 'messages-buffer "Heya!")))
  (hash-map socket-connections
            (lambda (id thing)
              (let ([thing-in (get-thing-quality thing 'socket-in)]
                    [thing-out (get-thing-quality thing 'socket-out)])
                (when (byte-ready? thing-in)
                  ; send input to the client parser... coming soon!
                  (set-thing-quality
                   thing 'messages-buffer (read-line thing-in)))
                (let ([messages-buffer (get-thing-quality thing 'messages-buffer)])
                  (when (> (string-length messages-buffer) 0)
                    (send-socket-out-message thing-out messages-buffer)
                    (set-thing-quality thing 'messages-buffer "")))))))

(define (stop-mudsocket)
  (tcp-close socket-listener)
  #t)

(define (send-socket-out-message out message)
  (display (format "~a~n" message) out)
  (flush-output out))

(define mudsocket-service
  (service "mudsocket"
           load-mudsocket
           start-mudsocket
           tick-mudsocket
           stop-mudsocket))
