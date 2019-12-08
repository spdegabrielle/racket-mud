#lang racket
(require uuid)

(define extant-things (make-hash))

(define known-rooms (make-hash))

(struct thing (id qualities) #:mutable)

(struct physical (proper-name common-names description location) #:mutable)

(struct room (id name description exits) #:mutable)

(struct user (name password) #:mutable)



(define (generate-thing-id)
  (let ([potential-id (uuid-string)])
    ; if the ID is in the Table of Extant Things, try again.
    (cond
      [(hash-has-key? extant-things potential-id)
       (generate-thing-id)]
      [else
       potential-id])))


(define (create-thing qualities
                      [updates #f])
  (let ([new-thing
         (thing (generate-thing-id) qualities)])
    (when (hash? updates)
      (hash-map
       (lambda (quality value)
         (hash-set! (thing-qualities thing) quality value))
       updates))
    (hash-set! extant-things (thing-id new-thing) new-thing)
    new-thing))

(define (create-all-rooms)
  (map (lambda (this-room)
         (hash-set! known-rooms
                    (get-thing-quality this-room room? room-id)
                    this-room))
       required-rooms))

(define (get-thing-quality thing setp quality)
  (car
   (remq (void)
         (map
          (lambda (set)
            (when (setp set)
            (quality set)))
          (thing-qualities thing)))))

(define (set-thing-quality thing setp quality-setter value)
  (map (lambda (set)
         (when (setp set)
           (quality-setter set value)))
       (thing-qualities thing)))

(define (get-user-name thing)
  (get-thing-quality thing user? user-name))
(define (set-user-name thing name)
  (set-thing-quality thing user? set-user-name! name))
(define (get-user-password thing)
  (get-thing-quality thing user? user-password))

(define (get-physical-proper-name thing)
  (get-thing-quality thing physical? physical-proper-name))
(define (get-physical-common-names thing)
  (get-thing-quality thing physical? physical-common-names))
(define (get-physical-description thing)
  (get-thing-quality thing physical? physical-description))
(define (get-physical-location thing)
  (let ([location
         (get-thing-quality thing physical? physical-location)])
    (when (hash-has-key? known-rooms location)
      (hash-ref known-rooms location))))
(define (set-physical-location thing location)
  (set-thing-quality thing physical? set-physical-location! location))

(define (move-thing-through-location-exit thing exit)
  (let* ([location (get-physical-location thing)]
         [destination (get-room-exit location exit)])
    (set-physical-location thing destination)))

(define (get-room-name thing)
  (get-thing-quality thing room? room-name))
(define (get-room-description thing)
  (get-thing-quality thing room? room-description))
(define (get-room-exits thing)
  (get-thing-quality thing room? room-exits))
(define (get-room-exit thing exit)
  (let ([exits (get-room-exits thing)])
    (when (hash-has-key? exits exit)
      (let ([exit (hash-ref exits exit)])
        (when (hash-has-key? known-rooms exit)
          (hash-ref known-rooms exit))))))


(define hala-bridge
  (create-thing
   (list
    (room
     'hala-bridge
     "Bridge of the Hala"
     "This is the bridge of the Hala."
     (make-hash
      (list (cons "port" "hala-ready-room")))))))

(define hala-ready-room
  (create-thing
   (list
    (room
     'hala-ready-room
     "Ready Room of the Hala"
     "This is the ready room of the Hala."
     (make-hash
      (list (cons "starboard" "hala-bridge")))))))


(define bob
  (create-thing
   (list
    (user
     "bob" "p@ss")
    (physical
     "Bob" (list "human") "This is masculine human." 'hala-bridge))))

(define bobby
  ((lambda ()
     (let ([bobby (create-thing (thing-qualities bob))])
       (set-user-name bobby "bobby")
       bobby))))


(define required-rooms
  (list hala-bridge
        hala-ready-room))


; (get-user-name bob) ; "bob"
; (get-physical-proper-name bob) ; "Bob"
; (get-room-name (get-physical-location bob)) ; "Bridge of the Hala"