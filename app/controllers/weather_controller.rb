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

  # Adding a label to our View
  def add_a_label
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = @data = "click for the weather"
    @label.color = BW.rgb_color(255, 255, 255)
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview(@label)
  end

  # Adding a button to our View
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
    url_string = "https://api.forecast.io/forecast/2afcbe3cdc7ba1ba6c828e466d3ecb57/40.75475,-111.89678"

    # Send the request and encode it for us `app/lib/url_request.rb`
    url_response = UrlRequest.send_request(url_string)

    # Decode the request and parse it as JSON `app/lib/json_parser.rb`
    json_data = JsonParser.decode(url_response)

    # Now you can use the JSON!
    @data = json_data["currently"]["summary"]
    reload_weather(@data)
  end

  # Simple method to update our label text, resize it, and center it again
  def reload_weather(new_weather)
    @label.text = new_weather
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
  end

end
