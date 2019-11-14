#lang racket

; Set the environmental variable PLTSTDERR to "warning debug@MUD" to see all MUD logs.
; I don't really get how Racket logging works *shrug*
; This gets the job done

(provide mudlog-debug
         mudlog-info
         mudlog-warning
         mudlog-error
         mudlog-fatal)
