#lang racket

(define (make-set-with f)
  )

(define (make-set)
  (make-set-with equal?))

(define (make-seteqv)
  (make-set-with eqv?))

(define (make-seteq)
  (make-set-with eq))
