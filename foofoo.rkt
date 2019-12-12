#lang racket
(struct thing (id nouns adjectives qualities))
(struct quality (procedure attributes))


(struct recipe (nouns adjectives qualities))

(define (get-thing-quality thing quality-symbol)
  (car (filter values (hash-map (thing-qualities thing) (lambda (quality-key quality-value) (cond [(eq? quality-key quality-symbol) quality-value] [else #f]))))))

(define (get-quality-attribute quality attribute)
  (hash-ref (quality-attributes quality) attribute))

(define (make-recipe recipe)
  (let ([new-thing 
         (thing 1 (recipe-nouns recipe)
                (recipe-adjectives recipe)
                (recipe-qualities recipe))])
    (hash-map (thing-qualities new-thing)
             (lambda (quality-key quality-value)
               ((quality-procedure quality-value) new-thing)))
    new-thing))


(define (visual brief description)
  (quality apply-visual-quality
  (make-hash
   (list (cons 'brief brief)
         (cons 'description description)))))

(define (apply-visual-quality thing)
  thing)

(define (get-visual-description thing)
  (get-quality-attribute (get-thing-quality thing 'visual) 'description))

(define goose-recipe
  (recipe (list "goose" "bird")
          (list)
          (make-hash
           (list
            (cons 'visual (visual "goose" "This is a goose."))))))

(define handmade-goose-thing
  (thing 1 (list "goose" "bird") (list "handmade")
         (make-hash
          (list
           (cons 'visual (quality apply-visual-quality (make-hash (list (cons 'brief "goose") (cons 'description "This is a handmade goose. If you look closely, you might see bugs.")))))))))

