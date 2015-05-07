class TipController < UIViewController

  def init
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemTopRated, tag: 1)
    self
  end

  def viewDidLoad
    super

    # Label in the center of the screen
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = "This Tips controller is awesome!"
    @label.color = BubbleWrap.rgb_color(255, 255, 255)
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview @label

    # Title at the top of the navigation
    self.title = "Tip (#{self.navigationController.viewControllers.count})"

    # Random color!!! /app/lib/random_color.rb
    self.view.backgroundColor = RandomColor.randomize_it

    # Button on the right side of the navigation
    right_button = UIBarButtonItem.alloc.initWithTitle("Push", style: UIBarButtonItemStyleBordered, target:self, action:'nextView')
    self.navigationItem.rightBarButtonItem = right_button
  end

  # This is what our button action will use ( action:'nextView' )
  def nextView
    new_controller = TapController.alloc.init
    self.navigationController.pushViewController(new_controller, animated: true)
  end

end
