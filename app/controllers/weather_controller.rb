class WeatherController < UIViewController

  # This will set our icon in the "tab navigation"
  def init
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemSearch, tag: 1)
    self
  end

  # This mehtod is called when, you guessed it, the view loads
  def viewDidLoad
    controller_setup
    add_a_label
    add_weather_labels
    add_an_input
    @input_field.delegate = self
  end

  def controller_setup
    # Setting the controllers title (top of the screen)
    self.title = "Weather Controller"

    # Setting the controllers background color
    self.view.backgroundColor = BW.rgb_color(50, 50, 50)

    @view_height = self.view.frame.size.height
    @view_width = self.view.frame.size.width
  end

  # helper for horizontal center
  def center_h(width)
    (@view_width / 2) - (width / 2)
  end

  # Adding a label to our View
  def add_a_label
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = "Find the weather in:"
    @label.color = BW.rgb_color(255, 255, 255)
    @label.sizeToFit
    @label.center = CGPointMake(@view_width / 2, 50)
    self.view.addSubview(@label)
  end

  # Label to be used for weather
  def add_weather_labels
    @city_label = UILabel.alloc.initWithFrame(CGRectZero)
    @temperature_label = UILabel.alloc.initWithFrame(CGRectZero)
    @humidity_label = UILabel.alloc.initWithFrame(CGRectZero)
    @condition_label = UILabel.alloc.initWithFrame(CGRectZero)
    @city_label.text = @temperature_label.text = @humidity_label.text = @condition_label.text = nil
    @city_label.color = @temperature_label.color = @humidity_label.color = @condition_label.color = BW.rgb_color(255, 255, 255)
    [@city_label, @temperature_label, @humidity_label, @condition_label].each do |label|
      label.sizeToFit
      label.center = CGPointMake( (@view_width/2), (@view_height/2) )
    end
    self.view.addSubview(@city_label)
    self.view.addSubview(@temperature_label)
    self.view.addSubview(@humidity_label)
    self.view.addSubview(@condition_label)
  end

  def add_an_input
    # A text input field instantiated with initWithFrame
   @input_field = UITextField.alloc.initWithFrame([[center_h(200), (@label.center.y + 30)], [200, 50]])

   # Set the text color using the UIColor class which offers named colors
   @input_field.textColor = UIColor.blackColor

   # Set the background color for the text field
   @input_field.backgroundColor = UIColor.whiteColor

   # @input_field.setKeyboardType UIKeyboardTypeNumbersAndPunctuation
   @input_field.setReturnKeyType UIReturnKeyDone

   # Set the border style of the text field to rounded rectangle
   # We need a rounded border, defined by the constant UITextBorderStyleRoundedRect
   @input_field.setBorderStyle UITextBorderStyleRoundedRect

   # Add the text field to the controller's view
   self.view.addSubview @input_field
  end

  # Runs when the input field is filled when
  def textFieldShouldReturn(textField)
    @input_field.resignFirstResponder
    request_weather
    true
  end

  # Adding a button to our View
  def add_the_button
    @theButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @theButton.setTitle('Refresh Weather!', forState:UIControlStateNormal)
    # @theButton.setTitleColor(BW.rgb_color(255, 255, 255), forState:UIControlStateNormal)
    @theButton.backgroundColor = BW.rgb_color(255, 255, 255)
    # @theButton.layer.borderColor = BW.rgb_color(255, 255, 255)
    # @theButton.layer.borderWidth = 0.5
    @theButton.layer.cornerRadius = 10
    @theButton.frame = [[center_h(200), (@view_height - 200)], [200,50]] #[[x-axis, y-axis], [width, height]]
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
    @input_field.resignFirstResponder
    request_weather
    true
  end

  # Simple API call to request weather data
  def request_weather
    unless @theButton
      add_the_button
    end
    # Use our Geocoder to get lat lon
    get_location_info(@input_field.text)

    # Our request url, you are going to need a forcase IO api key,
    url_string = "https://api.forecast.io/forecast/#{ENV['FORCAST_IO_TOKEN']}/#{@lat},#{@lon}"

    # Send the request and encode it for us `app/lib/url_request.rb`
    url_response = UrlRequest.send_request(url_string)

    # Decode the request and parse it as JSON `app/lib/json_parser.rb`
    json_data = JsonParser.decode(url_response)

    # Now you can use the JSON!
    load_weather(json_data)
  end

  # Uses the same methods as request weather, and sets our variables we need.
  # We are using our company geocode lookup, you will need to replace this with your own.
  def get_location_info(zip)
    url_string = "https://offer-demo.adcrws.com/v1/geolocation.json?access_token=#{ENV['ACCESS_DEVELOPMENT_TOKEN']}&search=#{zip}"
    url_response = UrlRequest.send_request(url_string)
    json_data = JsonParser.decode(url_response)
    @lat = json_data['location'][0]['geometry']['location']['lat']
    @lon = json_data['location'][0]['geometry']['location']['lng']
    @city = json_data['location'][0]['formatted_address'].split(",").first
  end

  # Simple method to update our label text, resize it, and center it again
  def load_weather(json_data)
    @city_label.text = @city
    font = @city_label.font
    @city_label.font = font.fontWithSize(30)
    @city_label.sizeToFit
    @city_label.center = CGPointMake( (@view_width/2), 200 )

    @condition_label.text = "Currently: #{json_data['currently']['summary']}"
    @temperature_label.text = "Temperature: #{json_data['currently']['temperature']}"
    @humidity_label.text =  "Humidity: #{json_data['currently']['humidity']}"
    [@temperature_label, @humidity_label, @condition_label].each_with_index do |label, index|
      label.sizeToFit
      size = ( 250 + (index * 30) )
      label.center = CGPointMake( (@view_width/2), size )
    end
  end
end
