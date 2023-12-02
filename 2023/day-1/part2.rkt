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

(define replace-table
  '(("one" . "one1one")
     ("two" . "two2two")
     ("three" . "three3three")
     ("four" . "four4four")
     ("five" . "five5five")
     ("six" . "six6six")
     ("seven" . "seven7seven")
     ("eight" . "eight8eight")
     ("nine" . "nine9nine")))

(define replace-digit-names
  (apply pipe (map (λ (e) (λ (s) (string-replace s (car e) (cdr e)))) replace-table)))

(define pipeline
  (pipe
    (curry map replace-digit-names)
    (curry map string->list)
    (curry map (curry filter char-numeric?))
    (curry map (λ (l) (list (first l) (last l))))
    (curry map list->string)
    (curry map string->number)
    (curry foldr + 0)))

(pipeline (read-lines))
