#lang racket

(require uuid)

(require "./engine.rkt"
         "./commands/move.rkt")

(provide client-login-parser
         client-parser
         client-sender)

(define (client-sender thing)
  (lambda (R)
  (let* ([name (name thing)]
         [quality (quality-getter thing)]
         [set-quality! (quality-setter thing)]
         [message (quality 'client-out)]
         [out (quality 'mudsocket-out)])
    (log-debug "THING QUALITIES ARE ~a" (thing (lambda (thing) (thing-qualities thing))))
    (log-debug "Sending ~a a message:\n   ~a" name
               (cond
                 [(> (string-length message) 60)
                  (format "~a..." (substring message 0 60))]
                 [else message]))
    (with-handlers ([exn? (lambda (exn) (log-warning "Issue sending message to client: ~a" exn))])
      (display
       (format
        (cond
          [(eq? #\newline (last (string->list message))) "~a"]
          [else "~a\n"]) message) out)
      (flush-output out))
    (set-quality! 'client-out ""))
    R))


(define (client-login-parser thing)
  (define quality (quality-getter thing))
  (define set-quality! (quality-setter thing))
  (define add-to-out ((string-quality-appender thing) 'client-out))
  (define mud (thing (λ (thing) (thing-mud thing))))
  (define schedule (car mud)) (define state (cdr mud))
  (log-debug "MUD's hooks are ~a" (mud-hooks state))
  (define login-stage 0)
  (lambda (line)
    (log-debug "Received the following login line from ~a:\n   ~a"
               (name thing) line)
    (let ([reply ""])
        (cond
          [(= login-stage 0)
           (set-quality! 'user-name line)
           (rename! thing line)
           ; account services
           (cond [((hash-ref (mud-hooks state) 'account?) line)
                  (set! reply (format "There's a extant account for ~a. If it's yours, enter the password and press ENTER. Otherwise, disconnect [and reconnect]." line))
                  (set! login-stage 1)]
                 [else
                  (let ([pass (substring (uuid-string) 0 8)])
                    (set-quality! 'pass pass)
                    ((hash-ref (mud-hooks state) 'create-account) line pass)
                    (set! reply (format "There's no account named ~a. Your new password is\n\n~a\n\nPress ENTER when you're ready to log in." line pass)))
                  (set! login-stage 9)])]
          [(= login-stage 1)
           (cond
             [(string=? (hash-ref ((hash-ref (mud-hooks state) 'account)
                                   (quality 'user-name)) 'pass)
                        line)
              (set! reply "Correct. Press ENTER to complete login.")
              (set! login-stage 9)]
             [else (set! reply "Incorrect. Type your [desired] user-name and press ENTER.") (set! login-stage 0)])]
          [(= login-stage 9)
           (set-quality! 'client-parser (client-parser thing))
           (let ([hooks (mud-hooks state)])
             ((hash-ref hooks 'move) thing ((hash-ref hooks 'room) 'green-delta/game/south-arathel/crossed-candles-inn))
             ((hash-ref hooks 'tune-in) "cq" thing))
           (add-to-out "You've been moved into the Crossed Candles Inn. Take a \"look\" around, and \"move\" or directly input exit names. You may chat with the \"cq\" command. Please remember this project is in the earliest stages of development.")])
        (when reply (add-to-out reply)))))

(define parse-args
  (lambda (args)
  ; before parsing arguments, take any elements (an element which starts with -- and has =") until (an element that ends with ") and join them together.
    (define results (make-hash))
    (map
     (lambda (arg)
       (cond
         [(and (> (string-length arg) 2)
               (string=? (substring arg 0 2) "--"))
          (let ([sparg (string-split arg "=")])
            (hash-set! results (substring (car sparg) 2) (cdr sparg)))]
         [(string=? (substring arg 0 1) "-")
          (map (lambda (char)
                 (hash-set! results char #t))
               (string->list (substring arg 1)))]
         [else (hash-set! results 'line
                          (cond [(hash-has-key? results 'line)
                                 (append (hash-ref results 'line)
                                         (list arg))]
                                [else (list arg)]))]))
     args)
    (when (hash-has-key? results 'line) (hash-set! results 'line (string-join (hash-ref results 'line))))
    results))

(define (client-parser thing)
  (define quality (quality-getter thing))
  (define set-quality! (quality-setter thing))
  (define add-to-out ((string-quality-appender thing) 'client-out))
  (λ (line)
    (let ([reply ""]
          [commands (quality 'commands)]
          [location (quality 'location)])
      (log-debug "Received the following line from ~a:\n   ~a" (name thing) line)
      (when (> (string-length line) 0)
        (let* ([spline (string-split line)]
               [input-command (car spline)] [args (parse-args (cdr spline))])
          (cond [(hash-has-key? commands input-command)
                   ((hash-ref commands input-command) args)]
                [(and location (hash-has-key? ((quality-getter location) 'exits) (string->symbol input-command)))
                ((move thing) (hash 'line input-command))]
                [(member input-command (quality 'channels))
                 (when (hash-has-key? args 'line)
                   ((hash-ref (mud-hooks (cdr (thing (lambda (t) (thing-mud t))))) 'broadcast)
                    input-command thing
                    (hash-ref args 'line)))]
                [else (set! reply "Invalid command.")])))
      (when reply (add-to-out reply)))))