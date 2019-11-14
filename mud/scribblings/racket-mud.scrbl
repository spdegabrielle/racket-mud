#lang scribble/manual

@(require (for-label racket))

@title{Racket-MUD}

@emph{@bold{NOTE:} A lot of the documentation right now talks about things that will be a part of Racket-MUD version 0.1.0 as though they exist. I didn't wanna have to go back and rewrite a bunch of "will" to "is".}

Racket-MUD is a Racket package containing a @emph{MUD engine} written by emsenn and released for the benefit of the commons. It is currently in earliest alpha.

@emph{MUDs}, or @emph{multi-user dimensions}, are a class of server where clients traditionally receive text output and interact by typing commands. MUDs are usually games, and are often role-playing games.

Racket-MUD is the engine, or driver, for running a MUD server, and is intended to be used with one or more @emph{MUD libraries}: modules for adding game features.

This documentation will contain information about the project, a list of Racket-MUD libraries, as well as several manuals for learning to work with the codebase:

@itemlist[
@item{Server Administration}
@item{Racket-MUD Library Development}
@item{Racket-MUD Development}]

It also contains the package documentation, which explains the codebase in-depth.

Finally, the following resources will be included:

@itemlist[
@item{Changelog}
@item{Plans}
@item{Dictionary}
@item{Index}]

By providing a limited set of features and focusing on documentation, Racket-MUD aims to be the non-programmer’s way to create and run a MUD.

@section{The Engine}

The Racket-MUD engine is the core set of functions that handle the basic operations of the MUD as a server. Its main responsibility is the maintenance of two data structures: the currently created @emph{Things}, and scheduled @emph{Events}. The engine conducts this maintenance by @tt{tick}ing: calling a procedure to perform the maintenance over-and-over until the engine is @tt{stop}ped.

@subsection{Services and the Tick}

I think the simplest way to explain the functions of the engine is to look at what happens when it is @tt{load}ed, @tt{start}ed, @tt{run}, and @tt{stop}ped.

The engine's @tt{load} procedure looks through a list of known services. and calls each of those services' @tt{load} procedures (if the service has one.) Each service handles a chunk of the engine's functioning, like running a server or handling client accounts. As they do different things, each service's @tt{load} procedure does something different, based on the service: the MUDSocket and Web services bind themselves to their appropriate ports, while the Client service checks to see if there's a record of clients and if not, makes a new one. Additionally, every service that has a @tt{tick} function is added to a list of @emph{tickable functions}.

The engine's @tt{start} procedure works in a similar way to @tt{load}: it goes through the list of known services and, if they have a @tt{start} procedure of their own, it gets called.

The @tt{run} procedure calls the @tt{tick} procedure until it is told to stop, at which point it calls the @tt{stop} procedure.

The @tt{tick} procedure calls the @tt{tock} procedure, and then the @tt{tick} procedure again, which means that it just keeps calling @tt{tick} then @tt{tock} then @tt{tick} again - until told to stop.

The main part of the @emph{tick} then comes from the @tt{tock} procedure, which calls the @tt{tick} procedure of every @emph{tickable service}, and calls every @emph{scheduled event}. (More on events soon.)

Each service's @tt{tick} procedure, like their @tt{load} and @tt{start} procedures, is different. The MUDSocket service's @tt{tick} procedure accepts new connections, reads info from existing connections, and sends out messages queued in their buffer, for example.

@subsection{Events}

@emph{Events} are procedures which are @emph{scheduled}, usually by another event or a service's @tt{tick} procedure, and then called the next @tt{tick}. For example, on Tick 0, Client Alpha, connected trhough the MUDSocket server types "help" and hits enter.

on Tick 1, the MUDSocket service's @tt{tick} procedure looks through the connected clients for any that have submited messages, and for Client Alpha, reads in the line "@tt{help}". The MUDSocket service @emph{schedules} a @tt{mudparse} event. Each @emph{event} has a @emph{payload}, which is a set of keys and values that help inform the event's operation. The @tt{mudparse} event expects two pieces of information: a @tt{client} (Alpha) and @tt{message} ("help").

On Tick 2, the engine's main @tt{tick} reads the @tt{mudparse} event in the list of @emph{scheduled events}, and calls the assocated procedure with the payload as arguments. The @tt{mudparse} procedure does its work, ultimately deciding that Client Alpha entered the "help" command without arguments. The @tt{mudparse} procedure then schedules a @tt{help} event.

On Tick 3, the @tt{help} procedure, triggered by the @emph{scheduled event}, generates a help message for Client Alpha and @emph{schedules} a @tt{send} event containing the message.

On Tick 4, the @tt{send} procedure sends the message to Client Alpha 1.

@itemlist[
@item{0: Client submits "help"}
@item{1: MUDSocket service reads in command and schedules...}
@item{2: MUDParse interprets the command and schedules...}
@item{3: Help generates a response and schedules...}
@item{4: Sending it to the client.}]

@section{Services}

The MUD engine relies on a variety of services to actually do anything.

@subsection{MUDSocket Service}

@subsection{Client Service}

@subsection{Web Service}

@section{Events}

Events are, well, events. Iunno I'll write this once I've got other docs done.

@subsection{Test Event}

This event simply echoes its payload into the console.

@subsection{Send Client Message Event}

This event sends a message to a client.

@section{Libraries}

At the moment there are no libraries for Racket-MUD, but I have plans for two:

@itemlist[
@item{Fyreside is a chatroom card game.}
@item{Okaga is a role-playing game.}]
