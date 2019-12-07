#lang scribble/manual

@title{Development Journals}

@section{emsenn's devlog}

@subsection{Planning Rooms}

I have about five dozen irons in the fire right now, but I'd like to stop working on most of what I'm working on with the engine and talk through how rooms would work.

"Rooms" are the traditional way MUDs handle environments, be it a clearing in a forest or a closet or blacksmith, and for the RPG library I'm wanting, I think that's a great approach.

To think about how rooms should work, I should think about how in-game objects work right now.

There's a ./thing.rkt file, which has a create-thing function that creates a thing: a struct with an id, list of names, and table of qualities.

There's a create-mudsocket-client procedure, in ./things/mudsocket-client.rkt

It currently directly adds attributes and values to the table of qualities, but now I'm wondering if I shouldn't rework this, and have each quality be a defined structure?

The engine tracks known services and known events, and extant (instanced) things.

Should it also track known things and known qualities?

The table of known things would be names of things - either generic like "room" or specific like "hala-bridge," and the value would be... a list of the qualities that thing has?

Maybe I need to think about this backward: A player walks into a bar: how?

The player is a thing with a bunch of qualities:
- qualities like mud-ip and mud-port, because it's a MUDSocket client
- qualities like health and skills, because it's a user

The bar is a thing with a bunch of qualities:
- qualities like an inventory and a list of exits

Each quality could be a struct...

I think I need to just rewrite my code for Things to be more Racket-y, but I'm having a hard time holding the concepts in my head all at once.

I think it's time to play in the REPL
