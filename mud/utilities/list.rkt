#lang racket

(provide force-stringy-list
         merge-stringy-lists)

(define (force-stringy-list strings)
    (cond [(list? strings) strings]
          [(pair? strings) (list (car strings) (cdr strings))]
          [(string? strings) (list strings)]
          [else (list)]))

(define (merge-stringy-lists list1 [list2 #f])
  (filter values
          (force-stringy-list (append
                       (force-stringy-list list1)
                       (cond [list2 (force-stringy-list list2)] [else (list)])))))