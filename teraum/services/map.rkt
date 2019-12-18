#lang racket

(require "../../mud/data-structures/service.rkt")

(require "../../rpg-basics/services/map.rkt")

(require (prefix-in teraum/ "../map/main.rkt"))

(provide teraum-map-service)

(define teraum-map
  (list
   teraum/green-delta/ack/angers-place
   teraum/green-delta/ack/astar-ward
   teraum/green-delta/ack/bank-hill
   teraum/green-delta/ack/brass-ward
   teraum/green-delta/ack/carper-falls
   teraum/green-delta/ack/copper-ward
   teraum/green-delta/ack/dock-ward
   teraum/green-delta/ack/eastgate
   teraum/green-delta/ack/garys-gate
   teraum/green-delta/ack/gasper
   teraum/green-delta/ack/north-ward
   teraum/green-delta/ack/piketown
   teraum/green-delta/ack/piketown-gate
   teraum/green-delta/ack/poplar-gate
   teraum/green-delta/ack/red-ward
   teraum/green-delta/ack/reinhold-wood
   teraum/green-delta/ack/squash-ward
   teraum/green-delta/ack/sugar-heights
   teraum/green-delta/ack/the-dog
   teraum/green-delta/ack/tin-ward
   teraum/green-delta/ack/wineglass
   teraum/green-delta/arathel-county/bellybrush-road
   teraum/green-delta/arathel-county/belys-blades
   teraum/green-delta/arathel-county/broken-arrow-inn
   teraum/green-delta/arathel-county/crossed-candles-inn
   teraum/green-delta/arathel-county/dull-thorn-inn
   teraum/green-delta/arathel-county/dull-thorn-inn-quarters
   teraum/green-delta/arathel-county/fork-toward-honeyfern-labs
   teraum/green-delta/arathel-county/golden-shield-inn
   teraum/green-delta/arathel-county/honeyfern-labs/dining-hall
   teraum/green-delta/arathel-county/honeyfern-labs/first-floor-hallway
   teraum/green-delta/arathel-county/honeyfern-labs/foyer
   teraum/green-delta/arathel-county/honeyfern-labs/front-path
   teraum/green-delta/arathel-county/honeyfern-labs/front-porch
   teraum/green-delta/arathel-county/honeyfern-labs/kitchen
   teraum/green-delta/arathel-county/honeyfern-labs/library
   teraum/green-delta/arathel-county/honeyfern-labs/outside-gate
   teraum/green-delta/arathel-county/honeyfern-labs/pantry
   teraum/green-delta/arathel-county/honeyfern-labs/sitting-room
   teraum/green-delta/arathel-county/north-arathel-ack-road
   teraum/green-delta/arathel-county/outside-broken-arrow-inn
   teraum/green-delta/arathel-county/outside-crossed-candles-inn
   teraum/green-delta/arathel-county/outside-dull-thorn-inn
   teraum/green-delta/arathel-county/outside-golden-shield-inn
   teraum/green-delta/arathel-county/road-to-honeyfern-labs
   teraum/green-delta/arathel-county/south-arathel-ack-road
   teraum/green-delta/arathel-county/west-arathel-pled-road
   teraum/green-delta/marby-county/eridrin
   ))

(define (load-map)
  (add-area-recipes-to-known-areas teraum-map))

(define teraum-map-service (service 'teraum-map-service
                              load-map #f #f #f))
