class WeatherController < UIViewController

  # This will set our icon in the "tab navigation"
  def init
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemSearch, tag: 1)
    self
  end

  # This mehtod is called when, you guessed it, the view loads
  def viewDidLoad
    puts ENV['FORCAST_IO_TOKEN']

    controller_setup
    add_an_input
    add_the_button
    add_a_label
  end

  def controller_setup
    # Setting the controllers title (top of the screen)
    self.title = "Weather Controller"

    # Setting the controllers background color
    self.view.backgroundColor = BW.rgb_color(50, 50, 50)
  end

  def center_h(width)
    (self.view.frame.size.width / 2) - (width / 2)
  end

  def add_an_input
    # A text input field instantiated with initWithFrame
   @input_field = UITextField.alloc.initWithFrame([[center_h(200), 10], [200, 50]])

   # Set the text color using the UIColor class which offers named colors
   @input_field.textColor = UIColor.blackColor

   # Set the background color for the text field
   @input_field.backgroundColor = UIColor.whiteColor

   # Set the border style of the text field to rounded rectangle
   # We need a rounded border, defined by the constant UITextBorderStyleRoundedRect
   @input_field.setBorderStyle UITextBorderStyleRoundedRect

   # Add the text field to the controller's view
   self.view.addSubview @input_field
  end

  # Adding a label to our View
  def add_a_label
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = @data = "Enter a Zip Code"
    @label.color = BW.rgb_color(255, 255, 255)
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview(@label)
  end

  # Adding a button to our View
  def add_the_button
    @theButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @theButton.setTitle('Get Weather!', forState:UIControlStateNormal)
    # @theButton.setTitleColor(BW.rgb_color(255, 255, 255), forState:UIControlStateNormal)
    @theButton.backgroundColor = BW.rgb_color(255, 255, 255)
    # @theButton.layer.borderColor = BW.rgb_color(255, 255, 255)
    # @theButton.layer.borderWidth = 0.5
    @theButton.layer.cornerRadius = 10
    @theButton.frame = [[center_h(200),50], [200,50]] #[[x-axis, y-axis], [width, height]]
    # @theButton.setTitle('Stop', forState:UIControlStateSelected)

    # Add an event for the button when touched
    # 'self' refers to the handler class for the action in which the callback is defined
    # buttonClicked is the method that will be called when the event happens
    # forControlEvents will take the event name
    @theButton.addTarget(self, action:'buttonClicked', forControlEvents:UIControlEventTouchUpInside)

    self.view.addSubview(@theButton)
  end

  # Our action for our button
  def buttonClicked
    request_weather
    # App.alert("#{@input_field.text} was in the box man!", {cancel_button_title: "pshh...", message: "But why did you click that???"})
  end

  # Simple API call to request weather data
  def request_weather
    # Use our Geocoder to get lat lon
    get_location_info(@input_field.text)

    # Our request url, you are going to need a forcase IO api key,
    url_string = "https://api.forecast.io/forecast/#{ENV['FORCAST_IO_TOKEN']}/#{@lat},#{@lon}"

    # Send the request and encode it for us `app/lib/url_request.rb`
    url_response = UrlRequest.send_request(url_string)

    # Decode the request and parse it as JSON `app/lib/json_parser.rb`
    json_data = JsonParser.decode(url_response)

    # Now you can use the JSON!
    @data = "It is #{json_data["currently"]["summary"]} in #{@city}"
    reload_weather(@data)
  end

  # Uses the same methods as request weather, and sets our variables we need.
  # We are using our company geocode lookup, you will need to replace this with your own.
  def get_location_info(zip)
    url_string = "https://offer-demo.adcrws.com/v1/geolocation.json?access_token=#{ENV['ACCESS_DEVELOPMENT_TOKEN']}&search=#{zip}"
    puts url_string
    url_response = UrlRequest.send_request(url_string)
    json_data = JsonParser.decode(url_response)
    puts json_data
    @lat = json_data['location'][0]['geometry']['location']['lat']
    @lon = json_data['location'][0]['geometry']['location']['lng']
    @city = json_data['location'][0]['address_components'][1]['short_name']
  end


  # Simple method to update our label text, resize it, and center it again
  def reload_weather(new_weather)
    @label.text = new_weather
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
  end
end
