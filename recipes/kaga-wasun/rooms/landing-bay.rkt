#lang racket

(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")

(provide kaga-wasun-landing-bay)
(define kaga-wasun-landing-bay
  (list (list "kaga-wasun" "landing") (list "bay")
        (list
   (room
    'kaga-wasun-landing-bay
    (make-hash
     (list (cons "inside" 'kaga-wasun-surface)
           (cons "teraum" 'teraum-marby-county))))
   (visual
    "Kaga-wasun landing bay"
    "This landing bay provides access to other parts of the universe. The main exit leads back inside, and magical transports allow for transit to Teraum.")
   (container (list)))))