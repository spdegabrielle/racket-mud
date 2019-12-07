#lang racket
(require racket/serialize)

(require "../logger.rkt")

(provide read-data-from-file
         save-data-to-file)

(define (read-data-from-file file)
  (current-logger (make-logger 'Serialization-read-data-from-file
                               mudlogger))
  (when (file-exists? file)
    (with-input-from-file file
      (lambda () (deserialize (read))))))

(define (save-data-to-file data file)
  (current-logger (make-logger 'Serialization-write-data-to-file
                               mudlogger))
    (cond
      [(serializable? data)
       (with-output-to-file file
         (lambda () (write (serialize data)))
         #:exists 'replace)]
      [else (printf "Data not serializable.")]))
