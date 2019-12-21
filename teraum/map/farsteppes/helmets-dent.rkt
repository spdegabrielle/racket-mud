#lang racket

(require "../../../rpg-basics/recipes/people/basic.rkt")
(require "../../recipes/areas/farsteppes/village.rkt")

(provide helmets-dent)

(define nash-celson
  (person
   #:nouns "nash celson"
   #:brief "Nash Celson"
   ; cons out-of-towners into robbing houses/businesses.
   #:description "Nash Celson is dressed in a fairly nice suit."))

(define helmets-dent
  (village
   'teraum/farsteppes/helmets-dent
   #:brief "Helmet's Dent"
   #:description "This is the town of Helmet's Dent. It is the largest town in the Farsteppes, existing around a large market where traders from the local nomadic tribes do business with merchants from the Central Plains and Green Delta. The buildings of the town reflect the diverse population, highlighting architectural styles from around the world."
   #:exits '(("northeast" . teraum/farsteppes/castle-oru)
             ("southeast" . teraum/farsteppes/road-to-culver-estate)
             ("west" . teraum/farsteppes/central-plains-road))))