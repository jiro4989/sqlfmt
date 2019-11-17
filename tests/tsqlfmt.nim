import unittest

include sqlfmt

suite "proc formatSQL(SqlNode)":
  test "Simple SQL":
    discard

suite "proc formatSQL(string)":
  test "Simple SQL":
    check formatSQL("SELECT * FROM test_table") == "" &
      "SELECT *\n" &
      "  FROM test_table"
