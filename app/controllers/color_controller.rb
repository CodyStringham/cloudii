class ColorController < UIViewController

  def init
    super
    self.tabBarItem = UITabBarItem.alloc.init
    self.tabBarItem.title = "Colors"
    self.tabBarItem.setFinishedSelectedImage(UIImage.imageNamed("icon-2.png"), withFinishedUnselectedImage:UIImage.imageNamed("icon-2.png"))
    self
  end

  def viewDidLoad
    super
    setup_view
    setup_label

    # Making a UIBarButton button with Bubble Wrap
    # @new_button = BW::UIBarButtonItem.styled(:bordered, "Push") do
    #   new_controller = ColorController.alloc.init
    #   self.navigationController.pushViewController(new_controller, animated: true)
    # end
    # self.navigationItem.rightBarButtonItem = @new_button

    ["red", "green", "blue"].each_with_index do |color_text, index|
      color = UIColor.send("#{color_text}Color")
      button_width = 80

      button = UIButton.buttonWithType(UIButtonTypeSystem)
      button.setTitle(color_text, forState:UIControlStateNormal)
      button.setTitleColor(color, forState:UIControlStateNormal)
      button.sizeToFit
      button.frame = [
        [30 + index*(button_width + 10),
         @label.frame.origin.y + button.frame.size.height + 30],
        [80, button.frame.size.height]
      ]
      button.autoresizingMask =
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
      button.addTarget(self,
        action:"tap_#{color_text}",
        forControlEvents:UIControlEventTouchUpInside)
      self.view.addSubview(button)
    end
  end

  def setup_view
    @vh = self.view.frame.size.height
    @vw = self.view.frame.size.width

    # Title at the top of the navigation
    # self.title = "Tap (#{self.navigationController.viewControllers.count})"
    self.title = "Colors"
    self.view.backgroundColor = UIColor.whiteColor
  end

  def setup_label
    # Label in the center of the screen
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = "Colors"
    @label.sizeToFit
    @label.center = [self.view.frame.size.width / 2, self.view.frame.size.height / 2]
    @label.autoresizingMask =
      UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    self.view.addSubview(@label)
  end

  def tap_red
    controller = ColorDetailController.alloc.initWithColor(UIColor.redColor)
    self.navigationController.pushViewController(controller, animated: true)
  end
  def tap_green
    controller = ColorDetailController.alloc.initWithColor(UIColor.greenColor)
    self.navigationController.pushViewController(controller, animated: true)
  end
  def tap_blue
    controller = ColorDetailController.alloc.initWithColor(UIColor.blueColor)
    self.navigationController.pushViewController(controller, animated: true)
  end

end

# Controller that opens a new tab when our color is pressed
class ColorDetailController < UIViewController
  def initWithColor(color)
    super
    self.initWithNibName(nil, bundle:nil)
    @color = color
    self.title = "Detail"
    self
  end

  def viewDidLoad
    super
    self.view.backgroundColor = @color
    rightButton =
      UIBarButtonItem.alloc.initWithTitle("Change",
        style: UIBarButtonItemStyleBordered,
        target:self,
        action:'change_color')
    self.navigationItem.rightBarButtonItem = rightButton
  end

  def change_color
    controller = ChangeColorController.alloc.initWithNibName(nil, bundle:nil)
    controller.color_detail_controller = self
    self.presentViewController(
      UINavigationController.alloc.initWithRootViewController(controller),
      animated:true,
      completion: lambda {})
  end
end

# Controller that opens a new modal prompting the user to change a color
class ChangeColorController < UIViewController
  attr_accessor :color_detail_controller

  def viewDidLoad
    super
    self.title = "Change Color"
    self.view.backgroundColor = UIColor.whiteColor
    @text_field = UITextField.alloc.initWithFrame(CGRectZero)
    @text_field.borderStyle = UITextBorderStyleRoundedRect
    @text_field.textAlignment = UITextAlignmentCenter
    @text_field.placeholder = "Enter a color"
    @text_field.frame = [CGPointZero, [150,32]]
    @text_field.center =
      [self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 170]
    self.view.addSubview(@text_field)
    @button = UIButton.buttonWithType(UIButtonTypeSystem)
    @button.setTitle("Change", forState:UIControlStateNormal)
    @button.frame = [[
       @text_field.frame.origin.x,
       @text_field.frame.origin.y + @text_field.frame.size.height + 10
      ],
      @text_field.frame.size]
    self.view.addSubview(@button)
    @button.addTarget(self,
      action:"change_color",
      forControlEvents:UIControlEventTouchUpInside)
  end

  def change_color
    color_text = @text_field.text
    color_text ||= ""
    color_text = color_text.downcase
    color_method = "#{color_text}Color"
    if UIColor.respond_to?(color_method)
      color = UIColor.send(color_method)
      self.color_detail_controller.view.backgroundColor = color
      self.dismissViewControllerAnimated(true, completion: nil)
      return
    end

    @text_field.text = "Error!"
  end
end
