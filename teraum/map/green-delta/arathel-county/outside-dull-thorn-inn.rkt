#lang racket

(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide outside-dull-thorn-inn)

(define outside-dull-thorn-inn
  (rural-road
   'teraum/green-delta/arathel-county/outside-dull-thorn-inn
   #:brief "Outside the Dull Thorn Inn"
   #:description "This is the road outside the Dull Thorn Inn, where the road from Ack ends against the Arathel-Pled road."
   #:exits '(("north" . teraum/green-delta/arathel-county/dull-thorn-inn)
             ("east" . teraum/green-delta/arathel-county/west-arathel-pled-road)
             ("south" . teraum/green-delta/arathel-county/outside-golden-shield-inn)
             ("west" . teraum/green-delta/arathel-county/outside-slow-lighting-inn))))