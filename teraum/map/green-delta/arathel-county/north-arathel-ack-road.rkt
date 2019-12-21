#lang racket

(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide north-arathel-ack-road)

(define north-arathel-ack-road
  (rural-road
   'teraum/green-delta/arathel-county/north-arathel-ack-road
   #:brief "north Arathel-Ack Road"
   #:description "This is the northern end of the road from Ack toward Arathel County, where it forks to the northwest and east. Both forks ultimately lead further north into the County. The difference is in what one passes on the way. The road northwest leads past Honeyfern Laboratories, while the road east passes more inns. To the southeast, the road leads to Ack."
   #:exits '(("northeast" . teraum/green-delta/arathel-county/outside-crossed-candles-inn)
             ("southwest" . teraum/green-delta/arathel-county/south-arathel-ack-road)
             ("northwest" . teraum/green-delta/arathel-county/outside-broken-arrow-inn))))
