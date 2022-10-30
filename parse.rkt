#lang racket
(require rackunit)

(define BLOCK-PREFIX "    ")

(define (parse the-path)
  (let ([the-string (port->string (open-input-file the-path))])
    (parse-top-level the-string)))

(define (parse-top-level the-string)
  `(block
    (group)
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
                        ,(parse-group head)
                        ,(parse-block-body body))
                      (parse-block-body lineN)))))]
         [else
          (cons (parse-group line0)
                (parse-block-body lineN))]))]))

(define (parse-group the-string)
  `(group ,@(map parse-atom (string-split the-string " "))))

(define (parse-atom the-string)
  (or (string->number the-string)
      (string->symbol the-string)))

(check-equal? (parse "examples/two-atoms")
              '(block
                (group)
                ((group 1)
                 (group 2))))
(check-equal? (parse "examples/one-block")
              '(block
                (group)
                ((block
                  (group foo)
                  ((group 2)
                   (group 3))))))
(check-equal? (parse "examples/nested-blocks")
              '(block
                (group)
                ((block
                  (group b1)
                  ((block
                     (group b1.1)
                     ((group a)))
                   (block
                     (group b1.2)
                     ())
                   (block
                     (group b1.3)
                     ((group b)
                      (group c)))))
                 (block
                  (group b2)
                  ((group 1)
                   (group 2)
                   (group 3))))))
(check-equal? (parse "examples/multiple-exprs")
              '(block
                 (group)
                 ((group a b c))))
