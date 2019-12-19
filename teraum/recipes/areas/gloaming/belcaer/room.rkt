#lang racket

(require (prefix-in basics/ "../../../../../rpg-basics/recipes/areas/rooms/basic.rkt"))
(provide room)

(define (room id
         #:nouns [nouns #f] #:adjectives [adjectives #f]
         #:brief [brief #f] #:description [description #f]
         #:contents [contents #f] #:actions [action-listing #f]
         #:exits [exits #f])
  (let ([standard-nouns (list "room")]
        [standard-brief "room in Belcaer"] [standard-description "This is room in Belcaer."]
        [standard-actions '((2 . "There is a brief cascade of ringing rolling coins as a slot machine in a nearby room pays out its jackpot.")
                            (1 . "A security officer for the casino briefly enters the room, looking around before leaving again."))])
    (when nouns
      (set! nouns (cond [(list? nouns) nouns] [(string? nouns) (list)])))
    (when adjectives
      (set! adjectives (cond [(list? adjectives) adjectives] [(string? adjectives) (list adjectives)])))
    (basics/room id
     #:nouns (filter values (cond
                              [nouns (append nouns standard-nouns)]
                              [else standard-nouns]))
     #:brief (cond [brief brief] [else standard-brief])
     #:description (cond [description description] [else standard-description])
     #:contents contents
     #:actions (cond [action-listing (append action-listing standard-actions)]
                     [else standard-actions])
     #:exits exits)))