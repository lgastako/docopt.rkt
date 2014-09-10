#lang racket

(require "usageblock.rkt")
(require "optionsblock.rkt")

;; (defn parse
;;   "Parses doc string."
;;   [doc]
;;   {:pre [(string? doc)]}
;;   (letfn [(sec-re   [name]          (re-pattern (str "(?:^|\\n)(?!\\s).*(?i)" name ":\\s*(.*(?:\\n(?=[ \\t]).+)*)") ))
;;           (section  [name splitfn]  (map s/trim (mapcat (comp splitfn second) (re-seq (sec-re name) doc))))
;;           (osplitfn [options-block] (re-seq #"(?<=^|\n)\s*-.*(?:\s+[^- \t\n].*)*" options-block))]
;;     (u/parse (section "usage" s/split-lines) (o/parse (section "options" osplitfn)))))

(define (parse-opt-string doc)
  (let* ([sec-re (lambda (name) (regexp (string-append "(?:^|\\n)(?!\\s).*(?i)" name ":\\s*(.*(?:\\n(?=[ \\t]).+)*)")))]
         [section (lambda (name splitfn)
                    (map string-trim (map-cat (compose1 splitfn second) (regexp-match* (sec-re name) doc))))]
         [osplitfn (lambda (options-block) (regexp-match* "(?<=^|\n)\\s*-.*(?:\\s+[^- \t\n].*)*" options-block))])
    (parse-usage (section "usage" split-lines)
                 (parse-options (section "options" osplitfn)))))


;; (defmacro docopt
;;   "Parses doc string at compile-time and matches command line arguments at run-time.
;; The doc string may be omitted, in which case the metadata of '-main' is used"
;;   ([args]
;;     (let [doc (:doc (meta (find-var (symbol (pr-str (ns-name *ns*)) "-main"))))]
;;       (if (string? doc)
;;         `(m/match-argv ~(parse doc) ~args)
;;         (throw (Exception. "Docopt with one argument requires that #'-main have a doc string.\n")))))
;;   ([doc args]
;;     `(m/match-argv ~(parse doc) ~args)))

(define-syntax-rule (docopt args)
  (let ([doc (:doc (meta (find-var (symbol (pr-str (ns-name *ns*)) "-main"))))])
    (if (string? doc)
        `(m/match-argv ~(parse doc) ~args)
        (throw (Exception. "Docopt with one argument requires that #'-main have a doc string.\n")))))

;; (defn -docopt
;;   "Java-capable run-time equivalent to 'docopt';
;; argument 'doc' can be either a doc string or the result of a call to 'parse'.
;; Returns a java.util.HashMap of the matched values provided by the 'args' sequence."
;;   [doc args]
;;   (if-let [cljmap (m/match-argv (if (string? doc) (parse doc) doc) (into [] args))]
;;     (let [javamap (HashMap. (count cljmap))]
;;       (doseq [[k v] cljmap]
;;         (.put javamap k (if (vector? v) (into-array v) v)))
;;       javamap)))

;; I don't think we need an equivalent of this.
