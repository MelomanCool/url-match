start: proto _WS+ domain _WS+ path _WS+ query

!proto: "http" | "https" | "https?"

!domain: (subdom dot | maybe_subdom)+ subdom
maybe_subdom: subdom ".?"
!subdom: _diglet ((_diglet | "-")* _diglet)?
_diglet: digit | letter

!path: ("/" (path_char | "/" | path_kw)* | ("/" (path_char+ | path_simp_kw))*) ("/" "?"?)?
!path_char: letter | digit | "-" | "_" | "." | kw_escape
path_kw: _keyword
path_simp_kw: _simp_keyword
kw_escape: "\:"

query: "{" (pair (_WS+ pair)*)? "}"
pair: key "=" query_kw
query_kw: _simp_keyword
!key: (letter | digit | "-" | "_")+

!_simp_keyword: /(?<!\\):/ (letter | digit | "-" | "_")+
!_keyword: /(?<!\\):/ (letter | digit | "-" | "_")+ /(?<!\\):(?!:)/i

dot: "."
letter: LETTER
digit: DIGIT

%import common.LETTER
%import common.DIGIT
%import common.WS -> _WS
