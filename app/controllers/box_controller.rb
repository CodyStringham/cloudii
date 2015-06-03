class BoxController < UIViewController

  def init
    super
    self.tabBarItem = UITabBarItem.alloc.init
    self.tabBarItem.title = "Boxes"
    self.tabBarItem.setFinishedSelectedImage(UIImage.imageNamed("icon-3.png"), withFinishedUnselectedImage:UIImage.imageNamed("icon-3.png"))
    self
  end

  def viewDidLoad
    super

    # Tab controller title
    self.title = "Boxes"
    self.view.backgroundColor = "#e1e1e1".to_color

    setup_view
    setup_button
    setup_color_field
    add_labels_to_boxes
  end

  def setup_view
    @vh = self.view.frame.size.height
    @vw = self.view.frame.size.width
    @box_color = UIColor.blueColor
    @first_view = UIView.alloc.initWithFrame(CGRect.new([10, 140], [35, 35]))
    @first_view.backgroundColor = @box_color
    @first_view.layer.cornerRadius = 5
    self.view.addSubview(@first_view)
  end

  def setup_button
    @add_button = UIButton.buttonWithType(UIButtonTypeSystem)
    @add_button.setTitle('Add', forState:UIControlStateNormal)
    @add_button.backgroundColor = "#fff".to_color
    @add_button.sizeToFit
    @add_button.layer.cornerRadius = 5
    @add_button.frame = CGRect.new([0, 0],[100, 50])
    @add_button.center = CGPointMake(@vw * 0.5, 100)

    @add_button.addTarget(
      self, action:"add_tapped", forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(@add_button)

    @remove_button = UIButton.buttonWithType(UIButtonTypeSystem)
    @remove_button.setTitle("Remove", forState:UIControlStateNormal)
    @remove_button.backgroundColor = "#fff".to_color
    @remove_button.sizeToFit
    @remove_button.layer.cornerRadius = 5
    @remove_button.frame = CGRect.new([0, 0],[100, 50])
    @remove_button.center = CGPointMake(@vw * 0.666 + 50, 100)
    self.view.addSubview(@remove_button)
    @remove_button.addTarget(
      self, action:"remove_tapped",
      forControlEvents:UIControlEventTouchUpInside
    )
  end

  def setup_color_field
    @color_field = UITextField.alloc.initWithFrame(CGRectZero)
    @color_field.borderStyle = UITextBorderStyleRoundedRect
    @color_field.text = "Blue"
    @color_field.enablesReturnKeyAutomatically = true
    @color_field.backgroundColor = "#fff".to_color
    @color_field.returnKeyType = UIReturnKeyDone
    @color_field.autocapitalizationType = UITextAutocapitalizationTypeNone
    @color_field.sizeToFit
    @color_field.frame = CGRect.new([0, 0],[100, 50])
    @color_field.center = CGPointMake(@vw * 0.333 - 50, 100)
    self.view.addSubview(@color_field)

    @color_field.delegate = self
  end

  def textFieldShouldReturn(textField)
    color_tapped
    textField.resignFirstResponder
    false
  end

  def color_tapped
    color_prefix = @color_field.text
    if @color_field.text.downcase == 'random'
      @box_color = RandomColor.randomize_it
      self.boxes.each do |box|
        box.backgroundColor = @box_color
      end
    else
      color_method = "#{color_prefix.downcase}Color"
      if UIColor.respond_to?(color_method)
        @box_color = UIColor.send(color_method)
        self.boxes.each do |box|
          box.backgroundColor = @box_color
        end
      else
        UIAlertView.alloc.initWithTitle(
          "Invalid Color",
          message: "#{color_prefix} is not a valid color",
          delegate: nil,
          cancelButtonTitle: "OK",
          otherButtonTitles: nil
        ).show
      end
    end


  end

  def add_tapped
    new_view = UIView.alloc.initWithFrame(CGRect.new([0, 0], [35, 35]))
    new_view.backgroundColor = @box_color
    last_view = self.view.subviews[0]

    if last_view.frame.origin.y > (@vh - 150) && last_view.frame.origin.x > (@vw - 70)
      UIAlertView.alloc.initWithTitle(
        "No more room!",
        message: "Dude... you ran out of space, try removing some boxes first!",
        delegate: nil,
        cancelButtonTitle: "Fine...",
        otherButtonTitles: nil
      ).show
      return false
    end

    if last_view.frame.origin.y > (@vh - 150)
      new_x = last_view.frame.origin.x + 45
      new_y = 140
    else
      new_x = last_view.frame.origin.x
      new_y = last_view.frame.origin.y + last_view.frame.size.height + 10
    end

    new_view.frame = CGRect.new(
      [new_x,
        new_y],
      last_view.frame.size)
    new_view.layer.cornerRadius = 5
    self.view.insertSubview(new_view, atIndex:0)
    add_labels_to_boxes
  end

  def remove_tapped
    other_views = self.view.subviews.reject { |subview| subview.is_a?(UIButton) or subview.is_a?(UILabel) or subview.is_a?(UITextField)
    }
    last_view = other_views.first
    return unless last_view && other_views.count > 1

    animations_block = lambda {
      last_view.alpha = 0
    }
    completion_block = lambda { |finished|
      last_view.removeFromSuperview
    }
    UIView.animateWithDuration(0.2,
      animations: animations_block,
      completion: completion_block
    )
    add_labels_to_boxes
  end

  def boxes
    self.view.subviews.reject { |subview| subview.is_a?(UIButton) or subview.is_a?(UILabel) or subview.is_a?(UITextField) }
  end

  def add_labels_to_boxes
    self.boxes.each do |box|
      # box.backgroundColor = RandomColor.randomize_it
      add_label_to_box(box)
    end
  end

  def add_label_to_box(box)
    box.subviews.each do |subview|
      subview.removeFromSuperview
    end

    index_of_box = (self.view.subviews.reverse.index(box) - 2)
    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text = "#{index_of_box}"
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.clearColor
    label.sizeToFit
    label.center = [box.frame.size.width / 2, box.frame.size.height / 2]
    box.addSubview(label)
  end

end



