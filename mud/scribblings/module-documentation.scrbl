#lang scribble/manual
@(require (for-label racket
                     "../engine.rkt"
                     "../thing.rkt"
                     "../commands/help.rkt"))

@title{Racket-MUD Module Documentation}


 @section{The Engine}
@defmodule[racket-mud/engine]{
 @defform[(known-events)]{
  foo bar}
 @defform[(scheduled-events)]{
  aaar}
 @defform[(known-services)]{
  aaa}
 @defform[(tickable-services)]{
  aaaa}
 @defproc[(load-services [services hash?])
          (void)]{
  bingle bangle.}              
 @defproc[(load-mud [events hash?]
                    [services hash?])
          (void)]{Loads the MUD}
@defproc[(load-service [service service?])
         (void)]{fofoof}
@defproc[(start-mud)
         (void)]{ fofoof}
@defproc[(start-services)
         (void)]{fofoof}
@defproc[(start-service)
         (void)]{fofoof}
@defproc[(run-mud)
         (void)]{fofoof}
@defproc[(tick)
         (void)]{fofoof}
@defproc[(tock)
         (void)]{fofoof}
@defproc[(stop-mud)
         (void)]{fofoof}
@defproc[(schedule)
         (void)]{fofoof}
@defproc[(call-event)
         (void)]{fofoof}}
@section{Commands}

@defmodule[racket-mud/commands]{

 Commands are the means by which clients make requests of the engine.
}
@subsection{Help}

@defmodule[racket-mud/commands/help]{

@defproc[(help-procedure [client thing?]
                         [kwargs hash?]
                         [args list?])
         (boolean)]{                      
 The @tt{help} command is how clients request helpful information from
the engine.}}

@section{Events}

@defmodule[racket-mud/event]{
 Events are, well, events. Iunno I'll write this once I've got other
 docs done.}
@subsection{Send}
@defmodule[racket-mud/events/send]{
 @defproc[(send-procedure)
          (void)]{
  Blah blah blah.}}
@section{Services}

The MUD engine relies on a variety of services to actually do anything.

@subsection{MUDSocket Service}

@subsection{Client Service}

@subsection{Web Service}