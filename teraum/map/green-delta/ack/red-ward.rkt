#lang racket

(require "../../../../rpg-basics/recipes/basics/lookable.rkt")
(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide red-ward)

(define buildings-lookable
  (lookable
   #:nouns '("building" "buildings")
   #:adjectives '("clay" "red")
   #:brief "buildings"
   #:description "The buildings here form a maze of alleys, which once served as a great defense against invaders. These days, it simply serves to confuse tourists and inhibit trade. There are a few towers which rise higher than any other building."))

(define towers-lookable
  (lookable
   #:nouns '("tower" "towers")
   #:adjectives '("clay" "tall" "red")
   #:brief "towers"
   #:description "Many of the buildings in the Red Ward are four or even six-storeys tall, but even they look small compared to the half dozen towers in the district, which each rise at least a dozen storeys."))

(define red-ward
  (district
   'teraum/green-delta/ack/red-ward
   #:brief "Red Ward"
   #:description "This is the Red Ward, one of Ack's oldest districts. Originally a keep constructed by one of Ack's first kings, the district's buildings are almost all constructed from the indigenous red clay. These days, the district is home to the eponymous Red Union, a conglomerate that has its hand in almost every contemporary human endeavor."
   #:exits '(("east" . teraum/green-delta/ack/astar-ward)
             ("west" . teraum/green-delta/ack/north-ward))
   #:actions '((2 . "A group of pedestrians wearing the uniform robes of the Red Union hurry down one street and up another, from one red tower to another."))
   #:contents (list buildings-lookable towers-lookable)))