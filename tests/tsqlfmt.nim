import unittest

include sqlfmt

suite "proc formatSQL(string)":
  test "SELECT * FROM test_table":
    check formatSQL("SELECT * FROM test_table") == "" &
      "SELECT *\n" &
      "  FROM test_table"
  test "SELECT * FROM test_table WHERE id = 1":
    check formatSQL("SELECT * FROM test_table WHERE id = 1 AND name = 'bob'") == "" &
      "SELECT *\n" &
      "  FROM test_table\n" &
      " WHERE id = 1 AND name = 'bob'"

