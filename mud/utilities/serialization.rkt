#lang racket
(require racket/serialize)

(require "../logger.rkt")

(provide read-data-from-file
         save-data-to-file)

(define (read-data-from-file file)
  (when (file-exists? file)
    (with-handlers ([exn:fail:filesystem:errno?
                     (λ (exn) (log-warning "~a" exn))])
      (with-input-from-file file
        (lambda () (deserialize (read)))))))

(define (save-data-to-file data file)
    (cond
      [(serializable? data)
       (with-output-to-file file
         (lambda () (write (serialize data)))
         #:exists 'replace)]
      [else (printf "Data not serializable.")]))
