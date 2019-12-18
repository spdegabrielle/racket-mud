#lang racket

(provide parse-arguments)

(define (parse-arguments spline)
  (let ([kwargs (make-hash)]
        [args (list)])
    ;; begin parsing of arguments
    ;; for every arg in targs
    (map (lambda (arg)
           (cond
             ;; if arg starts with --
             [(string=? (substring arg 0 2) "--")
              ;; split along it
              ;; if arg contains =
              (when (string-contains? arg "=")
                (let ([sparg (string-split arg "=")])
                  ;; and add it to kwargs hash,
                  ;; first part as key, second as value
                  (hash-set! kwargs
                             (substring (car sparg) 2)
                             (cdr sparg))))]
             ;; if arg starts with -
             [(string=? (substring arg 0 1) "-")
              (map (lambda (char)
                     (hash-set! kwargs char #t))
                   (string->list (substring arg 1)))]
             ;; otherwise, add to args
             [else
              (set! args (append args (list arg)))]))
         spline)
    (cons kwargs args)))