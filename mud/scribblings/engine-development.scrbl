#lang scribble/manual
@(require (for-label racket))

@title{Racket-MUD Engine Development}

The Racket-MUD engine may just be the core features of a MUD engine, but that there's still a lot to it!

I'd love help developing this thing: I'm really new to writing Racket, and I'm only a hobbyist programmer to start with.


@section{Roadmap}

Right now, Racket-MUD is in super-duper-early-alpha development: it's barely even functional, and not even close to being a viable product, no matter how minimal your criteria. I'd say bugs are common, but the truth is, it's properly-functioning code that's the rarity.

Nevertheless, we do have fond aspirations for where the project will end up. What follows is a listing of planned (or hopeful) features, categorized by which version in which we plan to release them. (To learn how Racket-MUD uses versioning numbers, see Versioning.)

@subsection{pre-1.0.0}

@subsubsection{0.1.0: The Basics}

The first release of Racket-MUD, our expectations for this version are relatively limited. The concepts of events, services, things, qualities, and a ticking engine should be implemented. There should be a MUDSocket service handling a socket server, a user account service handling the loading, saving, and modification of persistent user accounts, a talker service handling receiving and distribution of chat messages, and whatever events and qualities are required to make those work. Connected users should also have at least the following commands available:

@itemlist{
 @item{finger}
 @item{help}
 @item{talker}
 @item{who}
}

@subsubsection{0.2.0: Libraries}

The second release of Racket-MUD should provide for loading in additional services, events, and qualities as a MUD library. Connected users should gain at least the following commands:

@itemlist{
 @item{mudname}
}
@section{Changelog}

@section{Style Guide}

@subsection{Versioning}

This project will use semantic versioning (SemVer: https://semver.org) for all versions past version 1.0.0. Each version number has three parts: for version 1.23.4, 1 is the major version, 23 is the minor version, and 4 is the patch. Major versions are incremented when a non-compatible change is made to the software's API, requiring a change in the code of that software which uses it. Minor versions are incremented when compatible changes are made to the API, and patches are incremented when the version upgrade just deals with fixing bugs.

Prior to version 1.0.0, there is no point in history against which the API's compatibility might be measured, so the minor version is incremented any time the API is changed, whether it breaks compatibility or not. It should be assumed that every minor version is incompatible with any previous version. Patches work the same.

@subsection{Writing Documentation}
- Write documentation in plural first: we, our, ours.