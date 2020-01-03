#lang racket

(require "engine.rkt")
(provide mudmap)
(define (mudmap [areas (make-hash)])
  (λ (state)
    (let ([set-hook!
           (λ (hook value)
             (hash-set!
              (mud-hooks (cdr state))
              hook value))])
      (set-hook!
       'rooms areas)
      (set-hook!
       'room (λ (id) (hash-ref areas id)))
      (set-hook!
       'move
       (λ (mover destination)
         (let* ([mover-quality (quality-getter mover)]
                [set-mover-quality! (quality-setter mover)]
                [destination-quality (quality-getter destination)]
                [set-destination-quality! (quality-setter destination)]
                [location (mover-quality 'location)])
           (when location
             (let ([location-quality (quality-getter location)]
                   [set-location-quality! (quality-setter location)])
               (when (location-quality 'contents)
                 (set-location-quality!
                  'contents
                  (remove mover (location-quality 'contents))))))
           (set-mover-quality! 'location destination)
           (set-destination-quality!
            'contents
            (append (list mover) (destination-quality 'contents)))))))
    (let ([make (mud-maker (cdr state))])
      (hash-map areas (λ (id area) (let ([area (area make)])
                                     (hash-set! areas id area))))
      (log-debug "Preloaded ~a areas." (length (hash-keys areas)))
      (hash-map areas
                (lambda (id area)
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
                                         (hash-ref areas exit)))))))        
    state))