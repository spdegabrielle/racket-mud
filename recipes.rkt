#lang racket
(provide lookable
         area
         outdoors
         room
         inn
         person
         human
         ghost
         road)

(define area
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (lambda (make)
      (make name
            #:qualities
            (list (cons 'exits
                        (cond [exits (make-hash exits)] [else (make-hash)]))
                  (cond [description (cons 'description description)]
                        [else #f])
                  (cons 'contents
                        (cond [contents contents] [else (list)])))))))

(define outdoors
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (area #:name name  #:description description
          #:exits exits #:contents contents)))

(define room
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (area #:name name #:description description
          #:exits exits #:contents contents)))

(define inn
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (room #:name name #:description description
           #:exits exits #:contents contents)))

(define road
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f])
    (outdoors #:name name #:description description
              #:exits exits #:contents contents)))

(define lookable
  (lambda (#:name name #:description [description #f]
           #:actions [actions #f])
    (lambda (make)
      (make name
            #:qualities
            (list
             (cond [description (cons 'description description)]
                   [else #f])
             (cond [actions (cons 'actions actions)]
                   [else #f]))))))

(define person
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f]
           #:mass [mass #f])
    (lambda (make)
      (make name
            #:qualities
            (list
             (cond [description (cons 'description description)]
                   [else #f])
             (cons 'contents
                   (cond [contents contents] [else (cons 'contents (list))]))
             (cond [actions (cons 'actions actions)]
                   [else #f])
             (cond [mass (cons 'mass mass)]
                   [else #f]))))))

(define human
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f])
    (person #:name name #:description description
            #:contents contents #:actions actions
            #:mass 1)))

(define ghost
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f])
    (person #:name name #:description description
            #:contents contents #:actions actions)))