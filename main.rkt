#lang racket

(require "accounts.rkt"
         "actions.rkt"
         "engine.rkt"
         "mudmap.rkt"
         "mudsocket.rkt"
         "talker.rkt"
         "./teraum/main.rkt")

(define teraum
  (run-engine
   (make-engine
    "Teraum"
    (list (accounts)
          (actions)
          (mudmap teraum-map)
          (mudsocket)
          (talker)))))