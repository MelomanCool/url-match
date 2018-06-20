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
