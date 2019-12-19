#lang racket

(require (prefix-in basics/ "../../../../../rpg-basics/recipes/areas/outdoors/urban-district.rkt"))

(provide district)

(define (district id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "district")]
        [standard-brief "district of Ack"] [standard-description "This is one of the districts of Ack."]
        [standard-actions '((3 . "Two groups of pedestrians navigate sharing an intersection like only natives of Ack can do.")
                            (1 . "A young man wearing the red uniform robes of the Red Union runs down a street, delivering a parcel.")
                            (2 . "A slurping splashing sound betrays a resident dumping their blackwater from a second-storey window.")
                            (2 . "Shouting on a street builds then falls to laughter."))])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (basics/urban-district id
     #:nouns (filter values (cond [nouns (append standard-nouns nouns)] [else standard-nouns]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents (cond [contents contents] [else (list)])
     #:actions (cond [action-listing (append action-listing standard-actions)]
                     [else standard-actions])
     #:exits exits)))