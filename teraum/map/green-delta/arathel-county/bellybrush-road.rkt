#lang racket

(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide bellybrush-road)

(define bellybrush-road
  (rural-road
   'teraum/green-delta/arathel-county/bellybrush-road
   #:brief "Bellybrush Road, Arathel County"
   #:description"This is Bellybrush Road, in Arathel County. It leads northwest further toward Arathel County, and southeast, toward Bellybrush."
   #:exits '(("southeast" . teraum/green-delta/bellybrush/bellybrush-road)
             ("northwest" . teraum/green-delta/arathel-county/outside-crossed-candles-inn))))