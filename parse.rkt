#lang racket
(require rackunit)

(define BLOCK-PREFIX "    ")

(define (parse the-path)
  (let ([the-string (port->string (open-input-file the-path))])
    (parse-top-level the-string)))

(define (parse-top-level the-string)
  `(block
    ,(list)
    ,(parse-block-body (string-split the-string "\n"))))

(define (parse-block-body lines)
  (cond
    [(empty? lines) '()]
    [else
     (let ([line0 (car lines)]
           [lineN (cdr lines)])
       (cond
         [(string-suffix? line0 ":")
          (let ([head (substring line0 0 (sub1 (string-length line0)))])
            (let-values ([(body lineN) (splitf-at lineN (lambda (x) (string-prefix? x BLOCK-PREFIX)))])
              (let ([body (for/list ([line body])
                            (substring line (string-length BLOCK-PREFIX)))])
                (cons `(block
                        (,(parse-atom head))
                        ,(parse-block-body body))
                      (parse-block-body lineN)))))]
         [else
          (cons (parse-atom line0)
                (parse-block-body lineN))]))]))

(define (parse-atom the-string)
  (or (string->number the-string)
      (string->symbol the-string)))

(check-equal? (parse "examples/two-atoms")
              '(block
                ()
                (1 2)))
(check-equal? (parse "examples/one-block")
              '(block
                ()
                ((block
                  (foo)
                  (2 3)))))
(check-equal? (parse "examples/nested-blocks")
              '(block
                ()
                ((block
                  (b1)
                  ((block
                     (b1.1)
                     (a))
                   (block
                     (b1.2)
                     ())
                   (block
                     (b1.3)
                     (b c))))
                 (block
                  (b2)
                  (1 2 3)))))
