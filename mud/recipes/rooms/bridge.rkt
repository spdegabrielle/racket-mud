#lang racket

(require "../../services/room.rkt")


(define bridge
  (void (lambda ()
    (create-room
   "Bridge of the Hala"
   "This is the bridge of the intrastellar craft Hala. A circular room about 12 meters in diameter, it contains seven large chairs facing each other in a circle. In the center of the seating is a projected display of the star system."))))