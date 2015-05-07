class TapController < UIViewController

  def init
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
    self
  end

  def viewDidLoad
    super

    # Label in the center of the screen
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = "This Taps controller is awesome!"
    # @label.text = AFMotion::HTTP.get("http://www.google.com") { |result| p result.body.to_s }
    @label.color = BW.rgb_color(255, 255, 255)
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview @label


    # Making a UIBarButton button with Bubble Wrap
    @new_button = BW::UIBarButtonItem.styled(:bordered, "Push") do
      new_controller = TapController.alloc.init
      self.navigationController.pushViewController(new_controller, animated: true)
    end

    self.navigationItem.rightBarButtonItem = @new_button

    # Title at the top of the navigation
    self.title = "Tap (#{self.navigationController.viewControllers.count})"

    # Random color!!! /app/lib/random_color.rb
    self.view.backgroundColor = RandomColor.randomize_it

    # Making a UIBarButton button vanilla ( See nextView method below )
    # right_button = UIBarButtonItem.alloc.initWithTitle("Push", style: UIBarButtonItemStyleBordered, target:self, action:'nextView')
    # self.navigationItem.rightBarButtonItem = right_button
  end

  # This is what our button action will use ( action:'nextView' )
  # def nextView
  #   new_controller = TapController.alloc.init
  #   self.navigationController.pushViewController(new_controller, animated: true)
  # end

  def the_button_was_clicked
    App.alert("The button was clicked!!!", {cancel_button_title: "pshh...", message: "But why did you click that???"})
  end

end