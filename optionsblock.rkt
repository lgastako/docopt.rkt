#lang racket

(require "util.rkt")

;; (ns docopt.optionsblock
;;   (:require [clojure.string :as s])
;;   (:use      docopt.util))

;; (defn tokenize-option
;;   "Generates a sequence of tokens for an option specification string."
;;   [string]
;;   (tokenize string [[#"\s{2,}(?s).*\[(?i)default(?-i):\s*([^\]]+).*" :default]
;;                     [#"\s{2,}(?s).*"]
;;                     [#"(?:^|\s+),?\s*-([^-,])"                       :short]
;;                     [#"(?:^|\s+),?\s*--([^ \t=,]+)"                  :long]
;;                     [(re-pattern re-arg-str)                         :arg]
;;                     [#"\s*[=,]?\s*"]]))

(define (tokenize-option string)
  (tokenize string '('((regexp "\\s{2,}(?s).*\\[(?i)default(?-i):\\s*([^\\]]+).*") '#:default)
                     '((regexp "\\s{2,}(?s).*"))
                     '((regexp "(?:^|\\s+),?\\s*-([^-,])"                          '#:short))
                     '((regexp "(?:^|\\s+),?\\s*--([^ \\t=,]+)")                   '#:long)
                     '((re-pattern re-arg-str)                                     '#:arg)
                     '((regexp "\\s*[=,]?\\s*")))))

;; (defn parse-option
;;   "Parses option description line into associative map."
;;   [option-line]
;;   (let [tokens (tokenize-option option-line)]
;;     (err (seq (filter string? tokens)) :syntax
;;          "Badly-formed option definition: '" (s/replace option-line #"\s\s.*" "") "'.")
;;   (let [{:keys [short long arg default]} (reduce conj {} tokens)
;;         [value & more-values] (filter seq (s/split (or default "") #"\s+"))]
;;     (into (if arg
;;             {:takes-arg true :default-value (if (seq more-values) (into [value] more-values) value)}
;;             {:takes-arg false})
;;           (filter val {:short short :long long})))))

(define (parse-option option-line)
  (let ([tokens (tokenize-option option-line)])
    (err (nil-if-empty (filter string? tokens)) #':syntax
         "Badly-formed option definition: '" (string-replace (regexp "\s\s.*") "") "'."))
  ;; ugh this next part is all bad...
;;  (let ([... (reduce conj {} tokens)]))
  )

;; (defn parse [options-lines]
;;   "Parses options lines."
;;   (let [options (map parse-option options-lines)]
;;     (err (not (and (distinct? (filter identity (map :long options)))
;;                    (distinct? (filter identity (map :short options)))))
;;          :syntax "In options descriptions, at least one option defined more than once.")
;;     (into #{} options)))

(define (options->set options)
  (let ([set (make-hash)])
    (for [(k v) options]
      (hash-set! set (k . v) #t))))

(define (parse-opts options-lines)
  (let ([options (map parse-option option-lines)]
        (err (not (and (distinct? (filter identity (map '#:long options)))
                       (distinct? (filter identity (map '#:short options))))
                  #':syntax "In options descriptions, at least one option defined more than once."))
        (options->set options))))
