#lang racket

(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide outside-broken-arrow-inn)

(define outside-broken-arrow-inn
  (rural-road
   'teraum/green-delta/arathel-county/outside-broken-arrow-inn
   #:brief "Outside the Broken Arrow Inn"
   #:description "This is a dirt road outside the Broken Arrow Inn, in Arathel County. The road leads southeast toward the Arathel-Ack road, and northwest into Arathel County."
   #:exits '(("north" . teraum/green-delta/arathel-county/broken-arrow-inn)
             ("southeast" . teraum/green-delta/arathel-county/north-arathel-ack-road)
             ("northwest" . teraum/green-delta/arathel-county/fork-toward-honeyfern-labs))))