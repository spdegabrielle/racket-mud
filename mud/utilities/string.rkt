#lang racket

(provide oxfordize-list
         filter-multiple-word-strings-from-strings)

(define (oxfordize-list strings)
  (cond
    [(null? (cdr strings))
     (car strings)]
    [(null? (cddr strings))
     (string-join strings " and ")]
    [else
     (string-join strings ", "
                  #:before-first ""
                  #:before-last ", and ")]))


(define (filter-multiple-word-strings-from-strings strings)
  (filter values
          (map
           (lambda (str)
             (cond
               [(> (length (string-split str)) 1)
                str]
               [else #f]))
           strings)))