require 'optparse' 
require 'rdoc/usage'
require 'ostruct'
require 'erb'

class Pario
  Version = '0.3.4'
  Directories = %w{game lib media config}
  
  attr_reader :options, :command, :game_name, :arguments

  def initialize(arguments, stdin)
    @command = arguments[0]
    @arguments = arguments
    @stdin = stdin
    
    # Set defaults
    @options = OpenStruct.new
    @options.verbose = false
    @options.quiet = false
  end

  # Parse options, check arguments, then process the command
  def run
    if (parsed_options? && arguments_valid?) && !valid_pario_command? 
      #TODO
    elsif valid_pario_command?
      
      @command = arguments.delete_at(0)
      process_command 
    else
      output_usage
    end
      
  end
  
  protected
  
    def parsed_options?
      # Specify options
      opts = OptionParser.new 
      opts.on('-v', '--version')    { output_version ; exit 0 }
      opts.on('-h', '--help')       { output_help }
      opts.on('-V', '--verbose')    { @options.verbose = true }  
            
      opts.parse!(@arguments) rescue return false
      
      process_options
      true      
    end

    # Performs post-parse processing on options
    def process_options
      @options.verbose = false if @options.quiet
    end
    
    def output_options
      puts "Options:\
"
      
      @options.marshal_dump.each do |name, val|        
        puts "  #{name} = #{val}"
      end
    end

    # True if required arguments were provided
    def arguments_valid?
      # TO DO - implement your real logic here
      true if @arguments.length == 1 
    end
    
    # Setup the arguments
    def process_arguments
      #TODO
    end
    
    def output_help
      output_version
      RDoc::usage() #exits app
    end
    
    def output_usage
      RDoc::usage('usage') # gets usage from comments above
    end
    
    def output_version
      puts "#{File.basename(__FILE__)} version #{Version}"
    end
    
    def valid_pario_command?
      %w{create add play}.include? @command
    end
    
    def process_command
        send @command
      #process_standard_input # [Optional]
    end
    
    # Create a game
    def create
      create_directories
      create_base_files
      copy_files
    end
    
    def copy_files
      # TODO copy over README, LICENSE and pario_background
    end
    
    # This will take ""
    def game_name
      @game_name ||= @arguments[0]
    end
    
    def game_name_downcase
      game_name.split(/(?=[A-Z]+_)/).join('_').downcase
    end
    
    def game_name_upcase
      #TODO: need to handle camelcase
      game_name.to_s.gsub(/\b\w/){$&.upcase}
    end
    
    def create_base_files
      build_main
      # build_game_config
      build_game_class
    end
    
    def build_game_class
      Dir.chdir("game")
      game_file = File.open(game_name_downcase + ".rb", "w+") 
      game_file.puts game_class
    end
    
    def build_main
      # "do you want to overwrite main.rb? Y/n" if File.exist?("main.rb")
      main_file = File.open("main.rb", "w+") 
      main_file.puts main_class
    end
    
    def main_class
main_template = ERB.new <<-EOF
require 'rubygems'
require 'gosu'

Dir.glob(File.join("game", "*.rb")).each {|file|  require file }


game = #{game_name_upcase}.new(800, 600)
game.show
EOF
main_template.result(binding)
    end

    def game_class
game_template = ERB.new <<-EOF
class #{game_name_upcase} < Gosu::Window
  def initialize(window_width, window_height)
    super(window_width,window_height,0)
  end
  
  def update
    # Code to your object around goes here
    # TODO: Need more details
  end
  
  def draw
    # Code to draw what you see goes here
    # TODO: Need more details
  end
end
EOF
game_template.result(binding)
    end
    
    def create_directories
      Dir.mkdir(game_name_downcase) unless File.directory?(game_name_downcase)
      Dir.chdir(game_name_downcase)
      Directories.each do |sub_folder|
        Dir.mkdir sub_folder unless File.directory?(sub_folder)
      end
    end
  
    def add
      puts "Feature to come soon, I'm working on it!"
    end
    
    def play
     %x{ruby main.rb}
    end

    def process_standard_input
      input = @stdin.read      
      # TO DO - process input
      
      # [Optional]
      # @stdin.each do |line| 
      #  # TO DO - process each line
      #end
    end
end


# TO DO - Add your Modules, Classes, etc


# Create and run the application
app = Pario.new(ARGV, STDIN)
app.run