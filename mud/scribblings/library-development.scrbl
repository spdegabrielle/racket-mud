#lang scribble/manual
@(require (for-label racket))

@title{Racket-MUD Library Development}

At the moment, Racket-MUD is in very early development, so I discourage you from attempting to write a library for it.


@section{Things and Qualities}

When you connect to any Racket-MUD, a new "thing" is created and you're associated with it. It has a unique ID, some gibberish like "4aeb829...," a list of names, like your user-name, and it has a table of qualities: attributes like "remote IP" and "socket input."

Almost everything you interact with while connected is also a thing: rooms, other players, your inventory items. These things have qualities as well: some that you have, some that you don't. For example, a short sword doesn't have a "remote IP" quality, but it does have a "sharpness" quality.

