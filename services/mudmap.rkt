#lang racket
(require "../engine.rkt")
(provide mudmap)
(define mudmap
  (lambda ([areas (make-hash)])
    (lambda (mud sch make)
      (hash-set!
       (mud-hooks mud) 'rooms
       areas)
      (hash-set!
       (mud-hooks mud) 'room
       (lambda (id) (hash-ref areas id)))
      (hash-set!
       (mud-hooks mud) 'move
       (lambda (mover destination)
         (let* ([mover-quality (quality-getter mover)]
                [set-mover-quality! (quality-setter mover)]
                [destination-quality (quality-getter destination)]
                [set-destination-quality! (quality-setter destination)]
                [location (mover-quality 'location)])
           (when location
             (let ([location-quality
                    (quality-getter location)]
                   [set-location-quality!
                    (quality-setter (mover-quality 'location))])
               (when (location-quality 'contents)
                 (set-location-quality!
                  'contents
                  (remove mover (location-quality 'contents))))))
           (set-mover-quality! 'location destination)
           (set-destination-quality!
            'contents
            (append (list mover) (destination-quality 'contents))))))
      (hash-map
       areas
       (lambda (id area)
         (let ([area (area make)])
           (hash-set! areas id area))))
      (printf "Preloaded ~a areas.\n" (length (hash-keys areas)))
      (hash-map areas
                (lambda (id area)
                  (printf "Loading area\n   ~a\n" id)
                  (let ([contents ((quality-getter area) 'contents)]
                        [created-contents (list)])
                    (map (lambda (item)
                           (let ([item (item make)])
                             (set! created-contents
                                   (append (list item)
                                           created-contents))
                             ((quality-setter item) 'location area)))
                         contents)
                    ((quality-setter area) 'contents created-contents))
                  (hash-map ((quality-getter area) 'exits)
                            (lambda (id exit)
                              (hash-set! ((quality-getter area) 'exits)
                                         id
                                         (hash-ref areas exit))))))
      #f)))