(require [hy.contrib.walk [let]]
         [url-match.utils [f if-let]])
(import re
        pkgutil
        [furl [furl]]
        lark)


(defclass Transformer [lark.Transformer]
  (defn start [_ x]
    (dict x))

  (defn proto [_ [x]]
    ["proto" (str x)])

  (defn domain [_ subdoms]
    ["domain" (.join "" subdoms)])
  (defn maybe-subdom [_ [x]]
    #f r"({x}\.)?")
  (defn subdom [_ exprs]
    (.join "" exprs))

  (defn path [_ ps]
    ["path" (.join "" ps)])
  (defn path-char [_ [x]]
    (re.escape x))
  (defn path-kw [_ exprs]
    (setv kw (.strip (.join "" exprs) ":"))
    #f r"(?P<{kw}>.*)")
  (defn path-simp-kw [_ exprs]
    (setv kw (.strip (.join "" exprs) ":"))
    #f r"(?P<{kw}>[^/]+)")
  
  (defn query [_ x]
    ["query" (dict x)])
  (defn pair [_ x]
    (list x))
  (defn key [_ exprs]
    (.join "" exprs))
  (defn query-kw [_ exprs]
    (keyword (.strip (.join "" exprs) ":")))
  
  (defn letter [_ [x]]
    (str x))
  (defn digit [_ [x]]
    (str x))

  (setv dot (constantly "\.")
        kw-escape (constantly ":")))


(setv transformer (Transformer)
      grammar-parser
      (lark.Lark (.decode (pkgutil.get-data "url_match" "grammar.g"))))


(defn make-schema [pattern]
  (.transform transformer (.parse grammar-parser pattern)))


(defn match [schema url]
  (setv fu (furl url)

        [proto domain path query]
        (map schema.get ["proto" "domain" "path" "query"]))

  (when (and (re.fullmatch proto fu.scheme)
             (re.fullmatch domain fu.host))
    (if-let [path-match (re.fullmatch path (str fu.path))]
      ;; does the url have all of the required query parameters?
      (when (<= (set (.keys fu.args)) (.keys query))
        {#** (.groupdict path-match)
         #** (dict-comp (name var-name) (get fu.args qry-key)
                        [[qry-key var-name] (.items query)])}))))
