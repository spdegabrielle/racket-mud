#lang scribble/manual

@title{Racket-MUD}

@author[(author+email "emsenn" "emsenn@emsenn.net")]

@defmodule[racket-mud]

@emph{@bold{NOTE:} A lot of the documentation right now talks about things that will be a part of Racket-MUD version 0.1.0 as though they exist. I didn't wanna have to go back and rewrite a bunch of "will" to "is".}

Racket-MUD is a Racket package containing a @emph{MUD engine} written by emsenn and released for the benefit of the commons. It is currently in earliest alpha.

@emph{MUDs}, or @emph{multi-user dimensions}, are a class of server where clients traditionally receive text output and interact by typing commands. MUDs are usually games, and are often role-playing games.


Racket-MUD is the engine, or driver, for running a MUD server, and is intended to be used with one or more @emph{MUD libraries}: modules for adding game features.

By providing a limited set of features and focusing on documentation, Racket-MUD aims to be the non-programmer’s way to create and run a MUD.

@include-section["user-guide.scrbl"]
@include-section["server-administration.scrbl"]
@include-section["library-development.scrbl"]
@include-section["engine-development.scrbl"]
@include-section["module-documentation.scrbl"]
@include-section["libraries.scrbl"]
@include-section["further-reading.scrbl"]
