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

(define (parse-opts doc)
  (let* ([sec-re (lambda (name) (regexp (string-append "(?:^|\\n)(?!\\s).*(?i)" name ":\\s*(.*(?:\\n(?=[ \\t]).+)*)")))]
         [section (lambda (name splitfn)
                    (map string-trim (map-cat (compose1 splitfn second) (regexp-match* (sec-re name) doc))))]
         [osplitfn (lambda (options-block) (regexp-match* "(?<=^|\n)\\s*-.*(?:\\s+[^- \t\n].*)*" options-block))])
    (parse-usage (section "usage" split-lines)
                 (parse-options (section "options" osplitfn)))))

