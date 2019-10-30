#lang pollen
◊(require "0.1.0.rkt")
◊(require libuuid)

Milestones:

- [X] A (hash) table of extant things: their (unique) ID and instanced structure.
- [X] Procedures for creating a thing

In version 0.1.0 I set up the basics of a ticking engine, and in this one I'll set up a basic Thing, with a unique ID and list of names. For the unique ID we'll need the libuuid module.

So first, define the "thing" data structure. For now, it has two parts, an "id" which will be a string and "names" which will be a list of strings.

There's also the "extant-things" variable, a hash-table of all existing things, stored by their "id".

◊(struct thing/0.1.0 (id names))

◊(define extant-things/0.1.0 (make-hash))

When I generate a new ID, I'll need to make sure it's not already in the table of extant things. ("Table of Extant Things," sounds like a section from one of my fantasy encyclopedias.)

◊(define (generate-thing-id/0.1.0)
  (let ([potential-id (substring (uuid-generate/random) 0 35)])
    ; if the ID is already an extant Thing's ID, try again.
    (cond
     [(hash-ref extant-things/0.1.0 potential-id #f)
      (generate-thing-id)]
     [else
      potential-id])))

Finally, a function to "create-thing", that adds the new thing to the Table of Extant Things.

◊(define (create-thing/0.1.0)
  (let ([new-thing (thing/0.1.0 (generate-thing-id/0.1.0) (list "thing"))])
    (hash-set! extant-things/0.1.0 (thing/0.1.0-id new-thing) new-thing)))

Oh! But there should also be a function to destroy a thing.

◊(define (destroy-thing/0.1.0 id)
  (hash-remove! extant-things/0.1.0 id))

While looking up the syntax for "hash-remove!" I learned of another command, so I'm going to change a line in "generate-thing-id"

◊(define (generate-thing-id/0.1.1)
  (let ([potential-id (substring (uuid-generate/random) 0 35)])
    ; if the ID is in the Table of Extant Things, try again.
    (cond
     [(hash-has-key? extant-things/0.1.0 potential-id)
      potential-id]
     [else
      (generate-thing-id/0.1.1)])))

Looking at my milestones for this version, I've completed them! So I'm going to call this a wrap.

In the next version, I'll be adding a "stop" procedure to the MUD's core, and then the versions after that will be implementing a socket server and handling player connection.

Then, letting players send commands and receiving replies, then I'll start working on basic account stuff and logging in/out.

That'll push me to work on saving and loading the world state from a storage of some sort, so account info can persist between boots.

Then I'll probably work on the talker - in-game chat. That's... a fair bit, and will require a lot of smaller features between here and there, so that's all the planning out I feel I need to do, for now.

◊(provide
 thing/0.1.0
 extant-things/0.1.0
 create-thing/0.1.0
 destroy-thing/0.1.0
 generate-thing-id/0.1.1)