#lang racket

(define (read-lines)
  (let ([l (read-line)])
    (cond
      [(eof-object? l) '()]
      [else (cons l (read-lines))])))

(define (pipe . funs)
  (match funs
    [(? empty?) (λ (x) x)]
    [(cons (? list? sub-funs) funs)
      (λ x (apply (apply pipe funs) (map (λ (f) (apply f x)) sub-funs)))]
    [(cons (? procedure? f) funs)
      (λ x ((apply pipe funs) (apply f x)))]))

(struct bounding-box (x y w h) #:transparent)

;; Point is bounding-box -> Boolean

(define (mk-point x y)
  (λ (bb)
    (match bb
      [(bounding-box bb-x bb-y bb-w bb-h)
        (and
          (>= x bb-x)
          (>= y bb-y)
          (< x (+ bb-x bb-w))
          (< y (+ bb-y bb-h)))])))

(define (combine-points x y)
  (λ (bb) (or (x bb) (y bb))))

(define empty-point
  (λ (bb) #f))

;; (Listof (Listof Character)) -> (Listof Point)
(define (symbol-points ls)
  (for/list
    ([l ls]
     [y (in-range 0 +inf.0)]
     #:when #t
     [c l]
     [x (in-range 0 +inf.0)]
     #:when (not (or (char=? #\. c) (char-numeric? c))))
    (mk-point x y)))

;; (Listof (Listof Character)) -> (Listof (Pair bounding-box Number))
(define (number-bounding-boxes ls)
  (apply append
    (for/list
      ([l ls]
       [y (in-range 0 +inf.0)])
      (let loop ([l l] [x 0])
        (match l
          [(? empty?) '()]
          [(cons (? char-numeric?) _)
            (let*
              ([ns (list->string (takef l char-numeric?))]
               [n (string->number ns)]
               [bb (bounding-box (- x 1) (- y 1) (+ (string-length ns) 2) 3)])
              (cons (cons bb n) (loop (dropf l char-numeric?) (+ x (string-length ns)))))]
          [(cons _ l) (loop l (+ x 1))])))))

;; (Listof String) -> Number
(define pipeline
  (pipe
    (curry map string->list)
    (list
      (pipe
        symbol-points
        (curry foldl combine-points empty-point))
      number-bounding-boxes)
    (λ (points bbns) (filter-map (λ (bbn) (and (points (car bbn)) (cdr bbn))) bbns))
    (curry foldl + 0)))

(displayln (pipeline (read-lines)))
