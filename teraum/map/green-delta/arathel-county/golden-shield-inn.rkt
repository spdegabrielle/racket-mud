#lang racket

(require "../../../../rpg-basics/recipes/areas/rooms/inn.rkt")
(require "../../../../rpg-basics/recipes/people/innkeep.rkt")

(provide golden-shield-inn)

(define athyer
  (innkeep
   #:brief "Athyer"
   #:description "This is Athyer, a masculine human person."))

(define golden-shield-inn
  (inn
   'teraum/green-delta/arathel-county/golden-shield-inn
   #:brief "Golden Shield Inn"
   #:description "This is the Golden Shield Inn. It is a large single-storey timber-framed building, with a reinforced wooden door and unusually high ceilings. Accomodations consist of a several large rooms with beds and straw mattresses, and a mezzanine with several wooden cots. The innkeeper is a young human man named Athyer."
   #:exits '(("out" . teraum/green-delta/arathel-county/outside-golden-shield-inn))
   #:contents (list athyer)))