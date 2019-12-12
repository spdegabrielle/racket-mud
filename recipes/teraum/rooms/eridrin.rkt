#lang racket

(require "../../../thing.rkt")
(require "../../../qualities/container.rkt")
(require "../../../qualities/room.rkt")
(require "../../../qualities/visual.rkt")
(provide teraum-eridrin)
(define teraum-eridrin
  (recipe (list "eridrin") (list)
        (make-hash (list (cons 'room  (room 'teraum-eridrin
                                       (make-hash
                                        (list (cons "northwest" 'teraum-bellybrush)
                                              (cons "southeast" 'teraum-marby-county)))))
                         (cons 'visual (visual "Eridrin"
                                               "This is the town of Eridrin. It consists of about a dozen wattle cottages erected near the gravel banks of the Marlbreen River, grey with silt. A well-worn road reveals sandy loam under thin topsoil. The road leads northwest to the large town of Bellybrush, and southeast through Marby County."))
                         (cons 'container (container
                                           (list
                                            (recipe (list "cottages" "homes" "houses") (list "wattle")
                                                    (make-hash (list (cons 'visual (visual "wattle cottages"
                                                                                           "There are about a dozen wattle cottages arranged near the road."))))))))))))