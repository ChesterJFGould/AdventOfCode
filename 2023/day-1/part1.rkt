#lang racket

(define (pipe . fs)
  (match fs
    ['() (λ (x) x)]
    [(cons f fs)
      (λ (x) ((apply pipe fs) (f x)))]))

(define (read-lines)
  (define l (read-line))
  (if (eof-object? l)
    '()
    (cons l (read-lines))))

(define pipeline
  (pipe
    (curry map string->list)
    (curry map (curry filter char-numeric?))
    (curry map (λ (l) (list (first l) (last l))))
    (curry map list->string)
    (curry map string->number)
    (curry foldr + 0)))

(pipeline (read-lines))
