require_relative "../config/environment.rb"
require 'active_support/inflector'
# require 'interactive_record.rb'
require_relative "./interactive_record.rb"

#	NOTE: This lab lacks detailed instructions of the expected return value, datatypes, or data shape to pass tests! => Refer back to the Dynamic ORMs readme lesson often or review solution

class Student < InteractiveRecord

  self.column_names.each do |column_name|
    attr_accessor column_name.to_sym
  end

end

# Feedback Tests:
# pp Student.column_names
# pp Student.table_name
# puts
# new_student = Student.new(name: "Tonka", grade: "9th")
# pp new_student
# puts
# pp new_student.table_name_for_insert
# pp new_student.col_names_for_insert
# pp new_student.values_for_insert
# puts

# binding.pry
# 0