class WeatherController < UIViewController

  # This will set our icon in the "tab navigation"
  def init
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemSearch, tag: 1)
    self
  end

  # This mehtod is called when, you guessed it, the view loads
  def viewDidLoad
    controller_setup
    add_the_button
    add_a_label
  end

  def controller_setup
    # Setting the controllers title (top of the screen)
    self.title = "Weather Controller"

    # Setting the controllers background color
    self.view.backgroundColor = BW.rgb_color(50, 50, 50)
  end

  def add_a_label
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = @data = "click for the weather"
    @label.color = BW.rgb_color(255, 255, 255)
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview(@label)
  end

  def add_the_button
    @theButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @theButton.setTitle('Click Me!', forState:UIControlStateNormal)
    # @theButton.setTitleColor(BW.rgb_color(255, 255, 255), forState:UIControlStateNormal)
    @theButton.backgroundColor = BW.rgb_color(255, 255, 255)
    # @theButton.layer.borderColor = BW.rgb_color(255, 255, 255)
    # @theButton.layer.borderWidth = 0.5
    @theButton.layer.cornerRadius = 10
    @theButton.frame = [[(self.view.frame.size.width / 2) - 100,50], [200,50]] #[[x-axis, y-axis], [width, height]]
    # @theButton.setTitle('Stop', forState:UIControlStateSelected)
    @theButton.addTarget(self, action:'buttonClicked', forControlEvents:UIControlEventTouchDown)

    self.view.addSubview(@theButton)
  end

  # Our action for our button
  def buttonClicked
    request_weather
  end

  # Simple API call to request weather data
  def request_weather
    # Our request url, you are going to need a forcase IO api key,
    url_string = "https://api.forecast.io/forecast/#{ForcastKey.get_key}/40.75475,-111.89678"
    url_response = UrlRequest.send_request(url_string)
    json_data = JsonParser.decode(url_response)
    @data = json_data["currently"]["summary"]
    reload_weather(@data)
  end

  def reload_weather(new_weather)
    @label.text = new_weather
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
  end

end
