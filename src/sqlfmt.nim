import parsesql, tables
import sqlfmtpkg/submodule

const
  reservedWords = {
    "lower": {
      nkSelect: "select",
      nkFrom: "from",
    }.toTable,
    "upper": {
      nkSelect: "SELECT",
      nkFrom: "FROM",
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
  of nkFrom:
    ret.add("\n  " & reservedWords["upper"][node.kind])
    for node in node.sons:
      parsing(node, ret)
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

echo formatSQL("SELECT * FROM test")
echo "--------------------"
echo formatSQL("SELECT id, name, gender, email FROM test WHERE id = 1")
echo "--------------------"
echo formatSQL("SELECT id, name, gender, email FROM test WHERE name = 'taro'")
echo "--------------------"
echo formatSQL("SELECT u.name, u.hobby FROM user AS u JOIN hobby AS h ON u.id = h.user_id")

when isMainModule:
  echo(getWelcomeMessage())
