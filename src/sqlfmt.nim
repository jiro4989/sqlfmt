import parsesql, tables, strutils
from sequtils import mapIt
from strformat import `&`

const
  reservedWords = {
    "lower": {
      nkSelect: "select",
      nkFrom: "from",
      nkWhere: "where",
    }.toTable,
    "upper": {
      nkSelect: "SELECT",
      nkFrom: "FROM",
      nkWhere: "WHERE",
    }.toTable,
  }.toTable

proc parsing(node: SqlNode, ret: var string) =
  echo "Src: " & $node.kind & " -> " & $node
  case node.kind
  of nkIdent, nkQuotedIdent, nkStringLit, nkBitStringLit, nkHexStringLit, nkIntegerLit, nkNumericLit:
    echo "Val: " & node.strVal
    ret.add(" " & $node)
  of nkSelect:
    ret.add(reservedWords["upper"][node.kind])
    for node in node.sons:
      parsing(node, ret)
  of nkSelectColumns:
    let s = node.sons.mapIt($it).join(", ")
    ret.add(&" {s}")
  of nkFrom:
    ret.add("\n  " & reservedWords["upper"][node.kind])
    for node in node.sons:
      parsing(node, ret)
  of nkWhere:
    ret.add("\n " & reservedWords["upper"][node.kind])
    for node in node.sons:
      parsing(node, ret)
  of nkInfix:
    let s = node.sons
    echo "Infix: " & $s
    echo "Infix.kind: " & $s[0].kind
    let infix = $s[0]
    case infix
    of "=":
      ret.add(&" {s[1]} {infix} {s[2]}")
    else:
      var p = infix.toUpperAscii
      p = p.align(6)
      ret.add(&" {s[1]}\n{p} {s[2]}")
  else:
    echo "Sons: ", node.sons
    for node in node.sons:
      #ret.add($node)
      parsing(node, ret)

proc formatSQL*(node: SqlNode, lower = false, upper = true): string =
  var ret: string
  parsing(node, ret)
  ret

proc formatSQL*(sql: string, lower = false, upper = true): string =
  parseSQL(sql).formatSQL(lower = lower, upper = upper)
