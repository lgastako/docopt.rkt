#lang racket

(require rackunit)

(define (nil? x)
  (eqv? empty x))

(define (map-cat f xs)
  (apply append (map f xs)))

;; (defn load-test-cases
;;   "Loads language-agnostic docopt tests from file (such as testcases.docopt)."
;;   [path]
;;   (into [] (mapcat (fn [[_ doc tests]]
;;                    (map (fn [[_ args result]]
;;                           [doc (into [] (filter seq (s/split (or args "") #"\s+"))) (json/read-str result)])
;;                         (re-seq test-block-regex tests)))
;;                  (re-seq doc-block-regex (s/replace (slurp path) #"#.*" "")))))

(define (load-test-cases path)
  (printf "load-test-cases coming soon\n"))

;; (defn test-case-error-report
;;   "Returns a report of all failed test cases"
;;   [doc in out]
;;   (let [docinfo (try (d/parse doc)
;;                   (catch Exception e (.getMessage e)))]
;;     (if (string? docinfo)
;;       (str "\n" (s/trim-newline doc) "\n" docinfo)
;;       (let [result (or (m/match-argv docinfo in) "user-error")]
;;         (if (not= result out)
;;           (str "\n" (s/trim-newline doc) "\n$ prog " (s/join " " in)
;;                "\nexpected: " out "\nobtained: " result "\n\n"))))))

(define (test-case-error-report doc in out)
  (let ([docinfo (parse-opts doc)])
    (if (string? docinfo)
        (string-append "\n" (trim-newline doc) "\n" docinfo)
        (let ([result (or (...) "user-error")])
          (when (not (eqv? result out))
            (string-append "\n" (trim-newline doc) "\n$ prog " (string-join in " ")
                           "\nexpected: " out "\nobtained: " result "\n\n"))))))

;; (defn valid?
;; "Validates all test cases found in the file named 'test-cases-file-name'."
;; [test-cases-file-name]
;; (let [test-cases (load-test-cases test-cases-file-name)]
;;   (when-let [eseq (seq (remove nil? (map (partial apply test-case-error-report) test-cases)))]
;;     (println "Failed" (count eseq) "/" (count test-cases) "tests loaded from '" test-cases-file-name "'.\n")
;;     (throw (Exception. (apply str eseq))))
;;   (println "Successfully passed" (count test-cases) "tests loaded from '" test-cases-file-name "'.\n")
;;   true))

(define (valid? test-cases-file-name)
  (let ([test-cases (load-test-cases test-cases-file-name)])
    (let ([eseq (remove nil? (map (curry apply test-case-error-report)))])
      (when eseq
        (printf "Failed ~a / ~a tests loaded from '~a'.\n"
                (length eseq)
                (length test-cases)
                test-cases-file-name)
        (raise (string-append "EXCEPTION: "
                              (apply string-append eseq)))))
    (printf "Successfully passed ~a tests loaded from '~a'.\n"
            (length test-cases)
            test-cases-file-name)
    #t))
