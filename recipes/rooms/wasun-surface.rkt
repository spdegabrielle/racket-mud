#lang racket

(require "../../qualities/room.rkt")
(require "../../qualities/container.rkt")

(provide wasun-surface)
(define wasun-surface
  (list
   (room
    'wasun-surface
    "Surface of Kaga-Wasun"
    "This is the surface of Kaga-Wasun, a habitat constructed into a rocky body of Chumni-mima. The area, enclosed by shiny metal poles and clear panels, is pressurized with a breathable atmosphere. Residents use it as a community garden and park, and travelers must pass through it on their way from the landing bay to the rest of the habitat. Around thirty meters in diameter, most of the ground is covered in a series of raised gardening beds, but nothing is planted in them. Between the beds, paths lead to a covered stairwell which descend's to the habitat's entrance, the landing bay, and an airlock toward the asteroid's surface."
    (make-hash
     (list (cons "down" 'kaga-wasun-entrance))))
   (container (list))))
