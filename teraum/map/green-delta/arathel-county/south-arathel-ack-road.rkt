#lang racket

(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide south-arathel-ack-road)

(define south-arathel-ack-road
  (rural-road
   'teraum/green-delta/arathel-county/south-arathel-ack-road
   #:brief "south Arathel-Ack Road"
   #:description "This is the road between the city of Ack and Arathel County, its northern neighbor. The road leads southwest to Ack and northeast toward Arathel County. Near the road is a blacksmith."
   #:exits '(("northeast" . teraum/green-delta/arathel-county/north-arathel-ack-road)
             ("southwest" . teraum/green-delta/ack/astar-ward)
             ("west" . teraum/green-delta/arathel-county/belys-blades))))