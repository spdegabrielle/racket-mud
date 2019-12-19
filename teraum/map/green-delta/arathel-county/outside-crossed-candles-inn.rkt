#lang racket

(require "../../../../rpg-basics/recipes/basics/lookable.rkt")
(require "../../../recipes/areas/green-delta/arathel-county/rural-road.rkt")

(provide outside-crossed-candles-inn)

(define inn-lookable
  (lookable
   #:nouns '("building" "inn" "shack")
   #:adjectives '("crossed candles")
   #:brief "Crossed Candles Inn"
   #:description "The Crossed Candles Inn is one of several inns on the roads between the city of Ack, to the south, and the town of Arathel, seat of Arathel County, to the north. The inn is a single-storey building, resembling a barn more than a home. There are two windows on each side of the door, closed with wooden shutters."))
(define windows-lookable
  (lookable
   #:nouns '("window" "windows")
   #:adjectives '("closed" "shuttered")
   #:brief "shuttered windows"
   #:description "The facade of the inn has four windows, each closed by a pair of shutters."))
(define shutters-lookable
  (lookable
   #:nouns "shutters"
   #:adjectives (list "closed" "windows")
   #:brief "shutters"
   #:description "The shutters are closed, preventing people from seeing into the inn."))

(define outside-crossed-candles-inn
  (rural-road
   'teraum/green-delta/arathel-county/outside-crossed-candles-inn
   #:brief "outside Crossed Candles Inn"
   #:description "This is the road outside Crossed Candles Inn, in southeast Arathel County. The inn is a relatively simple wooden-slatted shack, with several shutter-covered windows facing the road. The road leads north, further into Arathel County, southeast toward the town of Bellybrush, and southwest toward the road to Ack."
   #:exits
   '(("north"  . teraum/green-delta/arathel-county/outside-golden-shield-inn)
     ("southeast" . teraum/green-delta/arathel-county/bellybrush-road)
     ("southwest" . teraum/green-delta/arathel-county/north-arathel-ack-road)
     ("west" . teraum/green-delta/arathel-county/crossed-candles-inn))
   #:contents
   (list
    inn-lookable
    windows-lookable
    shutters-lookable)))