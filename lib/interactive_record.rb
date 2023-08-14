require_relative "../config/environment.rb"
require 'active_support/inflector'

#	NOTE: This lab lacks detailed instructions of the expected return value, datatypes, or data shape to pass tests! => Refer back to the Dynamic ORMs readme lesson often or review solution

class InteractiveRecord

  def self.table_name # Ruby => SQL; converts Ruby class name to SQL table name
    self.to_s.downcase.pluralize
  end

  def self.column_names # SQL => Ruby; convert SQL column names to Ruby array to be used for class attributes (attr_accessors)
    sql = <<-SQL
      PRAGMA table_info("#{table_name}")
    SQL

    table_info = DB[:conn].execute(sql)
    # pp table_info
    column_names = []
    table_info.each do |column|
      column_names << column["name"]
    end
    column_names.compact
    # pp column_names
  end

  def initialize options={} # need results_as_hash in environment.rb?
    options.each do |key, value|
      self.send("#{key}=", value)
    end
  end
  
  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert # Tests expects columns to return as one single STRING separated by ", " => To be used in a SQL statement => SQL query not required yet
    self.class.column_names.reject {|column| column == "id"}.join(", ")
  end

  def values_for_insert # Tests expects values to return as one single STRING separated by ", " => To be used in a SQL statement => SQL query not required yet
    values = []
    self.class.column_names.each do |column|
      values << "'#{send(column)}'" unless send(column).nil?
    end
    values.join(", ")
  end

  def save # Ruby => SQL
    sql = <<-SQL
      INSERT INTO #{self.table_name_for_insert} (#{self.col_names_for_insert}) VALUES (#{self.values_for_insert})
    SQL

    DB[:conn].execute(sql)

    self.id = DB[:conn].execute("SELECT last_insert_rowid() from #{self.table_name_for_insert}")[0][0]
  end

  def self.find_by_name name
    sql = <<-SQL
      SELECT * FROM #{self.table_name} WHERE name = ?
    SQL

    DB[:conn].execute(sql, name)
  end

  def self.find_by hash # argument is a hash => hash = {attribute: value}
    value = hash.values.first
    # formatted_value = value.class == Fixnum ? value : "'#{value}'"
    # formatted_value = value.class == Float || value.class == Integer ? value : "'#{value}'"
    formatted_value = value.class == Numeric ? value : "'#{value}'"
    sql = <<-SQL
      SELECT * FROM #{self.table_name} WHERE #{hash.keys.first} = #{formatted_value}
    SQL

    DB[:conn].execute(sql)
  end

end

# binding.pry
# 0