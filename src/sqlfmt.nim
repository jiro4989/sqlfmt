import parsesql
import sqlfmtpkg/submodule

proc parsing(node: SqlNode) =
  echo $node.kind & " => " & $node
  case node.kind
  of nkIdent, nkQuotedIdent, nkStringLit, nkBitStringLit, nkHexStringLit, nkIntegerLit, nkNumericLit:
    echo node.strVal
  else:
    for node in node.sons:
      parsing(node)

parseSQL("SELECT * FROM test").parsing()
echo "--------------------"
parseSQL("SELECT id, name, gender, email FROM test WHERE id = 1").parsing()
echo "--------------------"
parseSQL("SELECT id, name, gender, email FROM test WHERE name = 'taro'").parsing()
echo "--------------------"
parseSQL("SELECT u.name, u.hobby FROM user AS u JOIN hobby AS h ON u.id = h.user_id").parsing()

when isMainModule:
  echo(getWelcomeMessage())
