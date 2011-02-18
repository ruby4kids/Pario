module Util
  
  # module Font
  #   def initialize(window, size, obj=nil, name=nil)
  #     super window, Gosu::default_font_name, size.to_i
  #   end
  #   def draw(text, color)
  #     super text, 0, 0, 99, 1, 1, color
  #   # @font.draw("Score: 0", 10, 10, 0, 1.0, 1.0, 0xffffff00)
  #   end
  # end
  
  def background_image(pic)
    Gosu::Image.new(self, pic, true)
  end
  
  #########################
  # There are more than the ones below
  # TODO: link here to a key map of all of the possiblities 
  # EXAMPLE: 
  # if key_pressed? :left
  # ...
  # end
  # 
  # UP    - :up
  # Down  - :down
  # Left  - :left
  # Right - :right
  # Space Bar :space
  # #########################
  def key_pressed?(key)
    key_const = Gosu.const_get(:"Kb#{key.to_s.gsub(/\b\w/){$&.upcase}}")
    button_down?(key_const)
  end
  
  # module ZOrder
  #  Background, Stars, Player, UI = *0..3  
  # end
end