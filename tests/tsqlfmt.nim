import unittest

include sqlfmt

suite "proc formatSQL(string)":
  test "SELECT * FROM test_table":
    check formatSQL("SELECT * FROM test_table") == "" &
      "SELECT *\n" &
      "  FROM test_table"
  test "SELECT * FROM test_table WHERE id = 1":
    check formatSQL("SELECT * FROM test_table WHERE id = 1") == "" &
      "SELECT *\n" &
      "  FROM test_table\n" &
      " WHERE id = 1"
  test "SELECT id, name FROM test_table WHERE id = 1 AND name = 'bob'":
    check formatSQL("SELECT id, name FROM test_table WHERE id = 1 AND name = 'bob'") == "" &
      "SELECT id, name\n" &
      "  FROM test_table\n" &
      " WHERE id = 1\n" &
      "   AND name = 'bob'"
