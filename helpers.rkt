#lang racket

(define (reduce f xs)
  (if (empty? xs) '() (foldl f (first xs) (rest xs))))

(define (nil? x)
  (eqv? empty x))

(define (map-cat f xs)
  (apply append (map f xs)))

(define concat append)

(define partial curry)

(define str string-append)

