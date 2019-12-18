#lang racket

(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide road-to-honeyfern-labs)

(define road-to-honeyfern-labs
  (rural-road
   'teraum/green-delta/arathel-county/road-to-honeyfern-labs
   #:brief "Road toward Honeyfern Laboratories"
   #:description "This is the road toward Honeyfern Laboratories, in Arathel County. Tall pines scatter the area. To the northeast is Honeyfern Laboratories, and to the southwest is a road leading elsewhere."
   #:exits '(("northeast" . 'teraum/green-delta/arathel-county/honeyfern-labs/outside-gate)
             ("southwest" . teraum/green-delta/arathel-county/fork-toward-honeyfern-labs))))