require 'sqlite3'
require 'pry'

#	NOTE: This lab lacks detailed instructions of the expected return value, datatypes, or data shape to pass tests! => Refer back to the Dynamic ORMs readme lesson often or review solution

DB = {:conn => SQLite3::Database.new("db/students.db")}
DB[:conn].execute("DROP TABLE IF EXISTS students")

sql = <<-SQL
  CREATE TABLE IF NOT EXISTS students (
  id INTEGER PRIMARY KEY, 
  name TEXT, 
  grade INTEGER
  )
SQL

DB[:conn].execute(sql)
DB[:conn].results_as_hash = true

# binding.pry
# 0