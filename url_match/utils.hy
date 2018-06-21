(require [hy.contrib.walk [let]])


(defmacro/g! if-let
  [bindings then-form &optional else-form]
  (let [g!form (nth bindings 0)
        g!tst  (nth bindings 1)]
    `(let [g!temp ~g!tst]
       (if g!temp
         (let [~g!form g!temp]
           ~then-form)
         ~else-form))))


(deftag f [string-literal]
  (import re)
  (setv exprs [])
  (setv string-literal (re.sub :flags re.VERBOSE
    r"\{
      (?P<expr> [^}!:]+)
      (?P<suffix> [!:] [^}]+)?
      \}"
    (fn [m]
      (.append exprs (read-str (.group m "expr")))
      (+ "{" (or (.group m "suffix") "") "}"))
    string-literal))
  `(.format ~string-literal ~@exprs))


(defn merge [a b]
  (doto (.copy a)
        (.update b)))
