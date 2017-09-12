class Controller
  def initialize(filename)
    @filename = filename
    open_history_file
  end

  def open_history_file
    @file = File.open(filename, "r")
  end

  def scan_for_commands
    file.readlines.each do |line|
      id, command = line.split(/  /).reject { |part| part == ""}
      case command
      when /ls/
        puts "Found ls"
      end
    end
  end

  private

  attr_reader :filename, :file
end
