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
           #:contents [contents #f] #:actions [actions #f]
           #:trivia [trivia #f])
    (lambda (make)
      (make name
            #:qualities
            (list (cons 'exits
                        (cond [exits (make-hash exits)] [else (make-hash)]))
                  (cond [description (cons 'description description)]
                        [else #f])
                  (cons 'contents
                        (cond [contents contents] [else (list)]))
                  (cond [trivia (cons 'trivia trivia)]
                        [else #f])
                  (cond [actions (cons 'actions actions)]
                        [else #f]))))))

(define outdoors
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (area #:name name  #:description description
          #:exits exits #:contents contents #:actions actions #:trivia trivia)))

(define room
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (area #:name name #:description description
          #:exits exits #:contents contents #:actions actions #:trivia trivia)))

(define inn
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (room #:name name #:description description
           #:exits exits #:contents contents #:actions actions
           #:trivia trivia)))

(define road
  (lambda (#:name name #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (outdoors #:name name #:description description
              #:exits exits #:contents contents
              #:actions actions #:trivia trivia)))

(define lookable
  (lambda (#:name name #:description [description #f]
           #:actions [actions #f] #:trivia [trivia #f])
    (lambda (make)
      (make name
            #:qualities
            (list
             (cond [description (cons 'description description)]
                   [else #f])
             (cond [actions (cons 'actions actions)]
                   [else #f])
             (cond [trivia (cons 'trivia trivia)]
                   [else #f]))))))

(define person
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f]
           #:mass [mass #f] #:trivia [trivia #f])
    (lambda (make)
      (make name
            #:qualities
            (list
             (cond [description (cons 'description description)]
                   [else #f])
             (cons 'contents
                   (cond [contents contents] [else (list)]))
             (cond [actions (cons 'actions actions)]
                   [else #f])
             (cond [mass (cons 'mass mass)]
                   [else #f])
             (cond [trivia (cons 'trivia trivia)]
                   [else #f]))))))

(define human
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f]
           #:trivia [trivia #f] #:mass [mass #f])
    (person #:name name #:description description
            #:contents contents #:actions actions
            #:mass 1 #:trivia trivia)))

(define ghost
  (lambda (#:name name #:description [description #f]
           #:contents [contents #f] #:actions [actions #f]
           #:trivia [trivia #f])
    (person #:name name #:description description
            #:contents contents #:actions actions
            #:trivia trivia)))