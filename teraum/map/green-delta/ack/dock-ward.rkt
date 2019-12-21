#lang racket

(require "../../../../rpg-basics/recipes/basics/lookable.rkt")
(require "../../../recipes/areas/green-delta/ack/district.rkt")

(provide dock-ward)

(define ack (lookable #:nouns "ack"
                      #:brief "Ack"
                      #:description "This is the city of Ack, or at least, that of it visible from the Dock Ward. From here, you get the impression that the city is heavily-populated and busy with trade and industry."))
(define blocks (lookable #:nouns '("block" "blocks")
                         #:adjectives "city"
                         #:brief "The city blocks here are not very block-y in shape. The streets instead yield to the footprint of the large warehouses, and are narrowed to paths by permanent tent encampments built throughout the Ward."))
(define bridge (lookable #:nouns "bridge"
                         #:adjectives '("iron" "north" "northern")
                         #:brief "bridge"
                         #:description "A bridge to the north, made of iron, crosses the Green River and leads to the North Ward."))
(define clerks (lookable #:nouns '("bureaucrat" "bureaucrats" "clerk" "clerks")
                         #:adjectives '("red union")
                         #:brief "There are a few bureaucrats from the Red Union walking around the Ward, doing inspections on various shops and warehouses."))
(define copper-ward (lookable #:nouns "copper ward"
                              #:brief "Copper Ward"
                              #:description "The Copper Ward is the district east of here."))
(define graffiti (lookable #:nouns "graffiti"
                           #:brief "graffiti"
                           ; show random line of graffiti
                           #:description "The wall around the Dock Ward, separating it from the rest of the city, is covered in graffiti."))
(define harbour (lookable #:nouns "harbour"
                          #:brief "harbour"
                          #:description "To the west is the harbour, where ships berth."))
(define humans (lookable #:nouns '("human" "humans" "working class")
                         #:brief "humans"
                         #:description "There are a lot of humans here in the Dock Ward, of various sorts. Many have darker complexions, revealing their time spent sailing the Optic Ocean. Others are dressed in red robes and have notably light complexions: the clerks of the Red Union, who rarely leave the towers of the Red Ward except on their bureaucratic assignments. One commonality is that most appear to be working class."))
(define kingsroad (lookable #:nouns '("kingsroad" "road")
                            #:brief "Kingsroad"
                            #:description "The Kingsroad is the widest boulevard in the district, going directly from the harbour, to the west, along the Green River to the city's Eastgate and out into the Green Delta beyond."))
(define north-ward (lookable #:nouns "north ward"
                             #:brief "North Ward"
                             #:description "The North Ward is well, north, across the Green River from here."))
(define ocean (lookable #:nouns '("ocean" "optic ocean")
                        #:brief "Optic Ocean"
                        #:description "The Optic Ocean isn't visible from here, but the tang of churning algae is heavy in the air."))
(define river (lookable #:nouns '("green river" "river")
                        #:adjectives '("brown" "murky")
                        #:brief "Green River"
                        #:description "This is near the mouth of the Green River. Here, the river's waters are a murky brown, and creep by, carrying the sewage of nearly every settlement between here and the Worldkeeper Mountains, a few thousand miles east."))
(define sailors (lookable #:nouns '("sailor" "sailors")
                         #:brief "sailors"
                         #:description "There are quite a few sailors here. This is the Dock Ward, after all: the harbour is just west of here."))
(define sewage (lookable #:nouns "sewage"
                         #:brief "sewage"
                         #:description "I'm not going to describe sewage."))
(define ships (lookable #:nouns '("ship" "ships")
                        #:adjectives '("decommissioned" "old")
                        #:brief "ships"
                        #:description "The ships that make up the wall around the Dock Ward are old and covered in graffiti. Many of the ships show signs of severe fire damage."))
(define stores (lookable #:nouns '("store" "stores")
                         #:brief "stores"
                         #:description "Some of the ships that make up the Dock Ward's outer wall have small stores tucked inside them."))
(define squash-ward (lookable #:nouns "squash ward"
                              #:brief "Squash Ward"
                              #:description "The Squash Ward is the district south of here."))
(define tents (lookable #:nouns '("camp" "camps" "encampment" "encampments" "tent" "tents")
                        #:adjectives '("canvas" "tent")
                        #:brief "tent camps"
                        #:description "The streets are filled with canvas tents: where the workers and various warehouses live."))
(define wall (lookable #:nouns "wall"
                       #:brief "wall"
                       #:description "The wall around the Dock Ward is made from old ships, too damaged to repair, that were dragged on shore and laid on their sides. Many of the ships have stores tucked inside them."))
(define warehouses (lookable #:nouns '("warehouse" "warehouses")
                             #:brief "warehouses"
                             #:description "The Dock Ward is mostly warehouses these days, housing the goods coming in and out of the harbour. Most of the warehouses look recently constructed."))
(define dock-ward
  (district
   'teraum/green-delta/ack/dock-ward
   #:nouns '("ward" "dock ward")
   #:brief "Dock Ward"
   #:description "This is the Dock Ward, the oldest district in the city of Ack. Originally settled by humans retiring from a life fishing the Optic Ocean, the district is a hub of import and export. The blocks are filled with warehouses, and the streets are nearly blocked by the workers tent camps. Around the district is an unusual wooden wall. It was constructed by rolling decommissioned ships on their side, helping to protect against the militant tribes that then roamed the Central Plains.\n\n\

A bridge from here lead north across the murky brown Green River toward the North Ward. The Kingsroad cuts east and west through the district, leading to the Copper Ward and the harbour, respectively. Heading south through the maze of tents and warehouses leads to the Squash Ward."
   #:exits '(("north" . teraum/green-delta/ack/north-ward)
             ("east" . teraum/green-delta/ack/copper-ward)
             ("south" . teraum/green-delta/ack/squash-ward)
             ("west" . teraum/green-delta/ack/dock-ward/harbour))
   #:actions '((2 . "At the harbour, a sailor argues with a representative from the Red Union.")
               (1 . "A young woman pulls a roll of paper from her satchel, tacks it to a segment of the Ward's wall, and paints over it with a paintbrush quickly, before pulling down the paper. Whatever message she meant to leave is entirely illegible. At least she tried."))
   #:contents (list ack blocks bridge clerks copper-ward graffiti harbour humans kingsroad north-ward ocean river sailors sewage ships stores squash-ward tents wall warehouses)))