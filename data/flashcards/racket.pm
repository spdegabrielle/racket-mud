#lang pollen

◊(define tags (list "Racket"))

◊flashcard{
◊question{
  To make the ◊code{make-bread} procedure available outside of the ◊code{bakery} module, what line must be added to the module?}

◊answer{◊code{
  (provide make-bread)
}}}


◊flashcard{
◊question{
  To define the variable ◊code{flour-weight} as an integer of ◊code{400}, what line must be used?}

◊answer{◊code{
  (define flour-weight 400)
}}}