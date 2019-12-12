#lang racket

(require "../../../qualities/actions.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/container.rkt")
(require "../../../qualities/visual.rkt")

(provide kaga-wasun-surface)
(define kaga-wasun-surface
  (list (list) (list "kaga-wasun" "surface")
        (list
         (visual
          "surface of Kaga-wasun"
          "This is the surface of Kaga-wasun, a habitat constructed into one of the rocky asteroids of Chumni-mima. The area, enclosed by shiny metal poles and clear panels, is pressurized with a breathable atmosphere. Residents use it as a community garden and park, and travelers must pass through it on their way from the landing bay to the rest of the habitat. Around thirty meters in diameter, most of the ground is covered in a series of raised gardening beds, but nothing is planted in them. Between the beds, paths lead to a covered stairwell which descend's to the habitat's entrance, the landing bay, and an airlock toward the asteroid's surface.")
    (room
     'kaga-wasun-surface
     (make-hash
      (list (cons "down" 'kaga-wasun-entrance)
            (cons "bay" 'kaga-wasun-landing-bay)
            (cons "airlock" 'kaga-wasun-airlock))))
    (container
     (list
      (list (list) (list "habitat")
            (list
             (visual
              "A habitable structure built into a rocky asteroid."
              "Kaga-wasun is a large metal and plastic structure built into a rocky asteroid.")))
      (list (list "rocky" "stony") (list "asteroid" "body")
            (list
             (visual
              "A large chunk of igneous rock orbiting Wi, part of Chumni-mima." (list))))
      (list (list "asteroid") (list "chumni-mama" "belt")
            (list
             (visual
              "Chumni-mima is an asteroid belt orbiting Wi." (list))
             (actions
              (list "A small patch of sky glistens as two icy rocks crash into each other, out in Chumni-mima."))))
      (list (list "shiny" "metal") (list "poles")
            (list
             (visual
              "This poles are about 10 centimeters in diameter and three meters tall, and approximately five meters apart from each other." (list)))))))))