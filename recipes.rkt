#lang racket
(provide
 setup-stringy-quality-value
 setup-listy-quality-value
 std-or-qual
         area
         area/outdoors
         area/outdoors/fort
         area/outdoors/road
         area/outdoors/river
         area/outdoors/rural-road
         area/outdoors/urban-district
         area/outdoors/urban-street
         area/outdoors/village
         area/room
         area/room/castle
         area/room/inn
         area/room/store
         lookable
         object
         person
         person/human
         person/human/innkeep
         person/ghost)

(define (setup-stringy-quality-value
         std-qual
         qual
         append-qual
         [separator " "])
  (cond
    [qual
     (cond [append-qual
            (format "~a~a~a"
                    std-qual
                    separator
                    qual)]
           [else qual])]
    [else std-qual]))

(define (setup-listy-quality-value
         std-qual
         qual
         append-qual)
  (cond
    [qual
     (cond [append-qual
            (append qual std-qual)]
           [else qual])]
    [else std-qual]))

(define (std-or-qual
         std-qual
         qual)
  (setup-stringy-quality-value
   std-qual qual #f))
   

(define (area
         #:name [name #f]
         #:append-name [append-name #f]
         #:nouns [nouns #f]
         #:adjectives [adjectives #f]
         #:description [description #f]
         #:append-description [append-description #f]
         #:exits [exits #f]
         #:contents [contents #f]
         #:actions [actions #f]
         #:trivia [trivia #f])
  (λ (make)
    (let ([std-name "area"]
          [std-description "This is an area."])
    (make
     (setup-stringy-quality-value std-name name append-name ", ")
     #:nouns nouns
     #:adjectives adjectives
     #:qualities
     (list (cons 'exits
                 (cond [exits (make-hash exits)] [else (make-hash)]))
           (cond [description (cons 'description (setup-stringy-quality-value std-description description append-description))]
                 [else #f])
           (cons 'contents
                 (cond [contents contents] [else (list)]))
           (cond [trivia (cons 'trivia trivia)]
                 [else #f])
           (cond [actions (cons 'actions actions)]
                 [else #f]))))))

(define (area/outdoors
         #:name [name #f]
         #:nouns [nouns #f]
         #:adjectives [adjectives #f]
         #:description [description #f]
         #:exits [exits #f]
         #:contents [contents #f]
         #:actions [actions #f]
         #:trivia [trivia #f])
  (area #:name name  #:description description
        #:exits exits #:contents contents #:actions actions #:trivia trivia))

(define area/outdoors/fort
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (area/outdoors #:name name #:description description
           #:exits exits #:contents contents #:actions actions
           #:trivia trivia)))
(define (area/outdoors/river
         #:name [name #f]
         #:nouns [nouns #f]
         #:adjectives [adjectives #f]
         #:description [description #f]
         #:exits [exits #f]
         #:contents [contents #f]
         #:actions [actions #f]
         #:trivia [trivia #f])
  (let ([std-name "river"]
        [std-description "This is a river."])
    (area/outdoors
     #:name (std-or-qual std-name name)
     #:nouns nouns
     #:adjectives adjectives
     #:description std-or-qual std-description description
     #:exits exits
     #:contents contents
     #:actions actions
     #:trivia trivia)))
(define area/outdoors/road
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (area/outdoors #:name name
            #:nouns nouns  #:adjectives adjectives #:description description
              #:exits exits #:contents contents
              #:actions actions #:trivia trivia)))

(define area/outdoors/rural-road
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (area/outdoors/road #:name name
            #:nouns nouns  #:adjectives adjectives #:description description
              #:exits exits #:contents contents
              #:actions actions #:trivia trivia)))
(define area/outdoors/urban-district
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (area/outdoors #:name name #:description description
           #:exits exits #:contents contents #:actions actions
           #:trivia trivia)))
(define area/outdoors/urban-street
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (area/outdoors #:name name #:description description
           #:exits exits #:contents contents #:actions actions
           #:trivia trivia)))
(define area/outdoors/village
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (let ([std-name "village"] [std-nouns '("village")])
      (area/outdoors #:name (cond [name name][else std-name])
            #:nouns (cond [nouns nouns][else std-nouns])
            #:description description
            #:exits exits #:contents contents #:actions actions
            #:trivia trivia))))
(define area/room
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (area #:name name #:description description
          #:exits exits #:contents contents #:actions actions #:trivia trivia)))
(define area/room/castle
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (let ([std-name "castle"] [std-nouns '("castle")])
      (area/room #:name (cond [name name][else std-name])
            #:nouns (cond [nouns nouns][else std-nouns])
            #:description description
            #:exits exits #:contents contents #:actions actions
            #:trivia trivia))))
(define area/room/inn
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (let ([std-name "inn"] [std-nouns '("inn")])
      (area/room #:name (cond [name name][else std-name])
            #:nouns (cond [nouns nouns][else std-nouns])
            #:description description
            #:exits exits #:contents contents #:actions actions
            #:trivia trivia))))

(define area/room/store
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f] #:exits [exits #f]
           #:contents [contents #f] #:actions [actions #f] #:trivia [trivia #f])
    (let ([std-name "store"] [std-nouns '("store")])
      (area/room #:name (cond [name name][else std-name])
            #:nouns (cond [nouns nouns][else std-nouns])
            #:description description
            #:exits exits #:contents contents #:actions actions
            #:trivia trivia))))


(define lookable
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f]
           #:actions [actions #f] #:trivia [trivia #f])
    (lambda (make)
      (make name
            #:nouns nouns  #:adjectives adjectives
            #:qualities
            (list
             (cond [description (cons 'description description)]
                   [else #f])
             (cond [actions (cons 'actions actions)]
                   [else #f])
             (cond [trivia (cons 'trivia trivia)]
                   [else #f]))))))
(define object
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
           #:description [description #f] #:mass [mass #f]
           #:contents [contents #f] #:actions [actions #f]
           #:trivia [trivia #f])
    (lambda (make)
      (let ([std-name "object"] [std-nouns '("object")])
        (make (cond [name name][else std-name])
              #:nouns (cond [nouns nouns][else std-nouns])
              #:qualities
              (list 
               (cond [description (cons 'description description)]
                     [else #f])
               (cons 'contents
                     (cond [contents contents] [else (list)]))
               (cond [trivia (cons 'trivia trivia)]
                     [else #f])
               (cons 'mass (cond [mass mass][else 1]))
               (cond [actions (cons 'actions actions)]
                     [else #f])))))))












(define person
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f]
           #:contents [contents #f] #:actions [actions #f]
           #:mass [mass #f] #:trivia [trivia #f])
    (lambda (make)
      (make name
            #:nouns nouns
            #:adjectives adjectives
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

(define person/human
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f]
           #:contents [contents #f] #:actions [actions #f]
           #:trivia [trivia #f] #:mass [mass #f])
    (person #:name name
            #:nouns nouns  #:adjectives adjectives #:description description
            #:contents contents #:actions actions
            #:mass 1 #:trivia trivia)))
(define person/human/innkeep
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f]
           #:contents [contents #f] #:actions [actions #f]
           #:trivia [trivia #f] #:mass [mass #f])
    (person/human #:name name
            #:nouns nouns  #:adjectives adjectives #:description description
            #:contents contents #:actions actions
            #:mass 1 #:trivia trivia)))
(define person/ghost
  (lambda (#:name name #:nouns [nouns #f] #:adjectives [adjectives #f]
            #:description [description #f]
           #:contents [contents #f] #:actions [actions #f]
           #:trivia [trivia #f])
    (person #:name name  
            #:nouns nouns  #:adjectives adjectives
           #:description description
            #:contents contents #:actions actions
            #:trivia trivia)))