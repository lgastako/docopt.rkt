#lang racket

(define (reduce f xs)
  (if (empty? xs) '() (foldl f (first xs) (rest xs))))

;; (ns docopt.util
;;   (:require [clojure.string :as s]))

;; ;; macros

;; (defmacro err [err-clause type & err-strs]
;;   `(when ~err-clause
;;      (throw (Exception. (str "DOCOPT ERROR " ~(case type :syntax "(syntax) " :parse "(parse) ") \| ~@err-strs)))))

;; (defmacro defmultimethods
;;   "Syntactic sugar for defmulti + multiple defmethods."
;;   [method-name docstring args dispatch-fn-body & body]
;;   `(do (defmulti ~method-name ~docstring (fn ~args (do ~dispatch-fn-body)))
;;        ~@(map (fn [[dispatched-key dispatched-body]]
;;                 `(defmethod ~method-name ~dispatched-key ~args (do ~dispatched-body)))
;;               (apply array-map body))))

;; (defmacro specialize [m]
;;   "Syntactic sugar for derive."
;;   `(do ~@(mapcat (fn [[parent children]] (map (fn [child] `(derive ~child ~parent)) children)) m)))

;; ;; tokenization

;; (def re-arg-str "(<[^<>]*>|[A-Z_0-9]*[A-Z_][A-Z_0-9]*)") ; argument pattern

;; (defn re-tok
;;   "Generates tokenization regexp, bounded by whitespace or string beginning / end."
;;   [& patterns]
;;   (re-pattern (str "(?<=^| )" (apply str patterns) "(?=$| )")))

;; (defn tokenize
;;   "Repeatedly extracts tokens from string according to sequence of [re tag];
;; tokens are of the form [tag & groups] as captured by the corresponding regex."
;;   [string pairs]
;;   (letfn [(tokfn [[re tag] source]
;;                  (if (string? source)
;;                    (let [substrings (map s/trim (s/split (str " " (s/trim source) " ") re))
;;                          new-tokens (map #(into [tag] (if (vector? %) (filter seq (rest %))))
;;                                          (re-seq re source))]
;;                      (filter seq (interleave substrings (concat (if tag new-tokens) (repeat nil)))))
;;                    [source]))]
;;     (reduce #(mapcat (partial tokfn %2) %1) [string] pairs)))

(define (hack-seq maybe-seq)
  ;; Trying to approximate the semantics as used below not as available in clojure in general...
  (list? maybe-seq))

(define (tokenize string pairs)
  (let ([tokfn (lambda (re-tag source)
                 (let* ([re (first re-tag)]
                        [re (if (regexp? re) re (regexp re))]
                        [tag (second re-tag)])
                   (if (string? source)
                       (let* ([substrings (map string-trim (string-split (string-append " " (string-trim source) " ")))]
                              [new-tokens (map (lambda (x)
                                                 (append (list tag) (when (vector? x) (filter hack-seq (rest x)))))
                                               (regexp-match* re source))])
                         (filter hack-seq (interleave substrings (concat (if tag new-tokens) (repeat nil)))))
                       '(source))))])
    (reduce (lambda (a b) (map-cat (curry tokfn b) a)) (append '(string) pairs))))
