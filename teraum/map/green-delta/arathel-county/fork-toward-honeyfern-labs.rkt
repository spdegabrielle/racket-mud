#lang racket

(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide fork-toward-honeyfern-labs)

(define fork-toward-honeyfern-labs
  (rural-road
   'teraum/green-delta/arathel-county/fork-toward-honeyfern-labs
   #:brief "an intersection two roads, Arathel County"
   #:description "This is the intersection of two dirt roads in Arathel County. One road leads off to the northeast, toward Honeyfern Laboratories. The other runs southeast, toward Ack, or north, into Arathel County."
   #:exits '(("northeast" . teraum/green-delta/arathel-county/road-to-honeyfern-labs)
             ("east" . teraum/green-delta/arathel-county/outside-broken-arrow-inn)
             ("north" . teraum/green-delta/arathel-county/road-near-frekes-grave))))