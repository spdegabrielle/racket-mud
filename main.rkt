#lang racket

(require "./engine.rkt")
(require "./services/mudsocket.rkt")
(require "./services/accounts.rkt")
(require "./services/actions.rkt")
(require "./services/talker.rkt")
(require "./services/mudmap.rkt")
(require "./teraum/main.rkt")

(define test-mud (start-mud "TestMUD"
                            (list (mudsocket)
                                  (accounts)
                                  (talker)
                                  (actions)
                                  (mudmap teraum-map)
                                  )))
;        K-P
;        |
;        D-+-L
;          |^
;        s-+
;
;