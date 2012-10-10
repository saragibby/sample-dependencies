class Dependency
  attr_accessor :input_lines, :class_names
  
  def initialize(input_lines=nil)
    @class_names = Hash.new
    process_input_lines(input_lines) unless input_lines.nil?
  end
  
  def dependencies_for(class_name)
    all_dependents = new_dependents = class_names[class_name]
    begin
      new_dependents = new_dependents.collect{|dep| class_names[dep] }.flatten.compact
      new_dependents -= all_dependents
      all_dependents += new_dependents
    end until new_dependents.empty?  
    all_dependents.delete(class_name)  
    all_dependents.uniq.sort
  end
  
  def add_direct(class_name, dependent_class_names)    
    if class_names.has_key?(class_name) 
      class_names[class_name] = class_names[class_name] | dependent_class_names
    else
      class_names[class_name] = dependent_class_names
    end  
  end
  
  private 
  
    def process_input_lines(input_lines)
      @input_lines = input_lines
      input_lines.split(/\r\n?/).each do |input_line|
        line_array = input_line.split(/\s/)
        add_direct(line_array[0], line_array[1..line_array.length-1])
      end
    end
end