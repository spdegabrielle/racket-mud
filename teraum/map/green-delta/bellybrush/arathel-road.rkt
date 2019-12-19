#lang racket

(require "../../../recipes/areas/green-delta/bellybrush/road.rkt")

(provide arathel-road)

(define arathel-road
  (road
   'teraum/green-delta/bellybrush/arathel-road
   #:brief "Arathel Road"
   #:description "This is Arathel Road, in the north part of the town of Bellybrush."
   #:exits '(("north" . teraum/green-delta/arathel-county/bellybrush-road)
             ("east"  . teraum/green-delta/bellybrush/east-harbrook-street)
             ("west" . teraum/green-delta/bellybrush/west-harbrook-street))))