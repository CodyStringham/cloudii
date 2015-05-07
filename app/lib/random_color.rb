class RandomColor

  def self.randomize_it
    [
      BW.rgb_color(255, 75, 35),
      BW.rgb_color(0, 189, 255),
      BW.rgb_color(43, 255, 183),
      BW.rgb_color(185, 97, 255),
      BW.rgb_color(59, 99, 232),
      BW.rgb_color(232, 188, 43),
    ].sample
  end

end
