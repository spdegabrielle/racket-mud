#lang racket

(provide filter-multiple-word-strings-from-strings
         force-stringy-list
         merge-stringy-lists
         oxfordize-list
         str-and-sym-list-joiner)

(define (filter-multiple-word-strings-from-strings strings)
  (filter values
          (map
           (lambda (str)
             (cond
               [(> (length (string-split str)) 1)
                str]
               [else #f]))
           strings)))

(define (oxfordize-list strings)
  (cond
    [(null? strings)
     (log-warning "Tried to oxfordize an empty list.")]
    [(null? (cdr strings))
     (car strings)]
    [(null? (cddr strings))
     (string-join strings " and ")]
    [else
     (string-join strings ", "
                  #:before-first ""
                  #:before-last ", and ")]))

(define str-and-sym-list-joiner
    (lambda (strings [sep ""])
      (string->symbol
       (string-join
        (map
         (lambda (string)
           (cond
             [(string? string)
              string]
             [(symbol? string)
              (symbol->string
               string)]))
         strings)
        sep))))

(define (force-stringy-list strings)
    (cond [(list? strings) strings] [(pair? strings) (list (car strings) (cdr strings))]
          [(string? strings) (list strings)] [else (list)]))

(define (merge-stringy-lists list1 [list2 #f])
  (filter values
          (force-stringy-list
           (append
            (force-stringy-list list1)
            (cond [list2 (force-stringy-list list2)] [else (list)])))))