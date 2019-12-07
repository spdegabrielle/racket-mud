#lang scribble/manual
@(require (for-label racket
                     "../engine.rkt"
                     "../thing.rkt"
                     "../commands/help.rkt"))

@title{Racket-MUD Module Documentation}


@section{The Engine}
@defmodule[racket-mud/engine]{
 @defform[(known-events)]{
  Table of every known event.

 This variable is used by the engine's scheduling functions to look up an event's associated procedure. It is populated when the engine is loaded.}
 @defform[(scheduled-events)]{
  List of events to be called during the engine's next tick.

 This variable is used by the engine's scheduling procedures to store which events must be called during the next tick. It is populated by events and services, and cleared out at the end of each tick.}
 @defform[(known-services)]{
  List of every known service.

 This variable is used by the engine's loading starting, and ticking procedures. It is populated when the engine is loaded.}
 @defform[(tickable-services)]{
  Table of every service which ticks.

 This variable is used by the engine's tick to call the tick procedure for each recorded service, allowing them to "run."}
 @defproc[(load-services [services hash?])
          (void)]{
  bingle bangle.}              
 @defproc[(load-mud [events hash?]
                    [services hash?])
          (void)]{
 Populate the records of known events and services, and load services with load procedures.}
 @defproc[(load-service [service service?])
         (void)]{
 Call the service's load procedure.}
 @defproc[(start-mud)
          (void)]{
 Start known services with start procedures.}
 @defproc[(start-services [services list?])
          (void)]{
 Call the start-service procedure for every service in the list of services. }
 @defproc[(start-service [service service?])
          (void)]{
 Call the service's start procedure.}
 @defproc[(run-mud)
          (void)]{
 Calls the tick procedure until told to stop, then calls the stop-mud procedure.}
 @defproc[(tick)
          (void)]{
 Calls the tock procedure, then itself.

 This is the time-keeping part of the game loop.}
 @defproc[(tock)
          (void)]{
 Calls every scheduled event, clears the list of scheduled events, and calls the tick procedure of every service which has one.

 This is the doing-stuff part of the game loop.}
 @defproc[(stop-mud)
          (void)]{
 Calls the stop procedure for every known service that has one.}
 @defproc[(schedule)
          (void)]{
 Adds an event to the list of scheduled events.}
 @defproc[(call-event)
          (void)]{
Calls the event with payload.}}
@section{Commands}

@defmodule[racket-mud/commands]{
                                
 Commands are the means by which clients make requests of the engine. If you want to learn about these from the perspective of a user, see the Commands section of the User Manual.
}

@subsection{Commands}
@defmodule[racket-mud/commands/commands]{
 @defproc[(commands-procedure [client thing?]
                              [kwargs hash?]
                              [args list?])
          (void)]{
  The @tt{commands} command is how clients request a list of their
  available commands.}}

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