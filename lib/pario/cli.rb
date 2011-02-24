require 'pario'
require 'optparse' 
require 'erb'
require 'fileutils'

module Pario
  class Cli
    include FileUtils
  
    Directories = %w{game lib media config}
  
    attr_reader :options, :command, :game_name, :arguments

    def initialize(arguments, stdin)
      @command = arguments[0]
      @arguments = arguments
    end

    # Parse options, check arguments, then process the command
    def run  
      if valid_pario_command?   
        @command = arguments.delete_at(0)
        process_command 
      else
        puts "Command not recognized."
      end
    end
  
    protected

      def output_version
        puts "pario version #{Version::STRING}"
      end
    
      def valid_pario_command?
        %w{new add play -v}.include? @command
      end
    
      def process_command
          @command = "output_version" if command == "-v"
          send @command
      end
    
      # Create a game
      def new
        create_directories
        create_base_files
        copy_files
        build_config_yaml
      end
    
      def copy_files
        cp File.join(File.expand_path(File.dirname(__FILE__)), "..", "util.rb"), "../lib/util.rb"
        cp File.join(File.expand_path(File.dirname(__FILE__)), "media", "pario_background.png"), "../media/pario_background.png"
        cp File.join(File.expand_path(File.dirname(__FILE__)), "..", "docs", "README"), "../README"
        cp File.join(File.expand_path(File.dirname(__FILE__)), "..", "docs", "LICENSE"), "../LICENSE"
      end
    
      # Set game name
      def game_name
        @game_name ||= @arguments.delete_at(0)
      end
      
      def game_name_camelcase
        game_name.gsub(/(.)([A-Z])/,'\1_\2').downcase
      end
      
      def create_base_files
        build_main
        build_extra_classes unless @arguments.empty?
        # build_game_config
        build_game_class
      end
    
      def build_game_class
        Dir.chdir('game')
        game_file = File.open("#{game_name_camelcase}.rb", "w+") 
        game_file.puts game_class
      end
    
      def build_main
        # "do you want to overwrite main.rb? Y/n" if File.exist?("main.rb")
        main_file = File.open("main.rb", "w+") 
        main_file.puts main_class
      end
      
      def build_config_yaml
        Dir.chdir('../config')
        config_file = File.open("config.yml", "w+") 
        config_file.puts config_yaml
      end
    
      def build_extra_classes
        Dir.chdir("game") unless Dir.getwd.split("/").last == "game"
        @arguments.each do |new_class|
          class_file  = File.open("#{new_class.gsub(/(.)([A-Z])/,'\1_\2').downcase}.rb", "w+")
          class_file.puts class_template(new_class)
        end
      end
      
      def config_yaml
template = ERB.new <<-EOF
:screen_width: 600
:screen_height: 800
EOF
template.result(binding)
      end
            
      def class_template(name)
template = ERB.new <<-EOF
class #{name.to_s.gsub(/\b\w/){$&.upcase}}
  def initialize
  end
end
EOF
template.result(binding)
      end
    
      def main_class
main_template = ERB.new <<-EOF
require 'rubygems'
require 'gosu'
require 'yaml'

Dir['{game,lib}/*.rb'].each { |f| require f }

config = YAML::load(File.open("config/config.yml"))

#Add lib includes here
include Util

game = #{game_name.capitalize}.new(config[:screen_height], config[:screen_width])
game.show
EOF
main_template.result(binding)
      end

      def game_class
game_template = ERB.new <<-EOF
class #{game_name.capitalize} < Gosu::Window
  def initialize(window_width, window_height)
    super(window_width,window_height,0)
    @background_image = background_image "media/pario_background.png"
  end

  def update
    # Code to your object around goes here
    # TODO: Need more details
  end

  def draw
    # Code to draw what you see goes here
    @background_image.draw 0,0,0
  end
end
EOF
game_template.result(binding)
      end
    
      def create_directories
        folder_name = game_name.gsub(/(.)([A-Z])/,'\1_\2').downcase
        Dir.mkdir(folder_name) unless File.directory?(folder_name)
        Dir.chdir(folder_name)
        Directories.each do |sub_folder|
          Dir.mkdir sub_folder unless File.directory?(sub_folder)
        end
      end
  
      def add
        build_extra_classes unless @arguments.empty?
      end
    
      def play
       %x{ruby main.rb}
      end
    end
end