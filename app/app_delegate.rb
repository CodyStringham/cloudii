class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # Controllers with a Tab Bar
    # The first variable is the actual controller being initialized
    # The second variable is setting it to a navigation controller that can be used with our "tab controller"
    # Icons for these tabs are set in the controllers themselves
    color_controller = ColorController.alloc.init
    color_nav_controller = UINavigationController.alloc.initWithRootViewController(color_controller)

    box_controller = BoxController.alloc.init
    box_nav_controller = UINavigationController.alloc.initWithRootViewController(box_controller)

    weather_controller = WeatherController.alloc.init
    weather_nav_controller = UINavigationController.alloc.initWithRootViewController(weather_controller)

    alphabet_controller = AlphabetController.alloc.init
    alphabet_nav_controller = UINavigationController.alloc.initWithRootViewController(alphabet_controller)

    # Sets up the tabs at the bottom of the screen, array is the controllers in order of tab placement
    tab_controller = UITabBarController.alloc.init
    tab_controller.viewControllers = [weather_nav_controller, color_nav_controller, box_nav_controller, alphabet_controller]

    # Sets the root controller to the tab controller we just defined
    @window.rootViewController = tab_controller

    # This makes the window a receiver of events
    @window.makeKeyAndVisible

    # This method must return true
    true
  end
end
