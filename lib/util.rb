module Util

  def background_image(pic)
    Gosu::Image.new(self, pic, true)
  end
  
  #########################
  # There are more keys than the ones below, this is just a start
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
    $game_window.button_down?(key_const)
  end
  
  def set_game_window(game)
    # For now, use $game_window 
    # This may change
    $game_window = game
  end
  
  # positioning layers within a game
  # module ZOrder
  #  Background, UI = *0..3  
  # end
end