class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # Controllers with a Tab Bar
    # The first variable is the actual controller being initialized
    # The second variable is setting it to a navigation controller that can be used with our "tab controller"
    # Icons for these tabs are set in the controllers themselves
    tap_controller = TapController.alloc.init
    tap_nav_controller = UINavigationController.alloc.initWithRootViewController(tap_controller)

    tip_controller = TipController.alloc.init
    tip_nav_controller = UINavigationController.alloc.initWithRootViewController(tip_controller)

    weather_controller = WeatherController.alloc.init
    weather_nav_controller = UINavigationController.alloc.initWithRootViewController(weather_controller)

    alphabet_controller = AlphabetController.alloc.init
    alphabet_nav_controller = UINavigationController.alloc.initWithRootViewController(alphabet_controller)

    # Sets up the tabs at the bottom of the screen, array is the controllers in order of tab placement
    tab_controller = UITabBarController.alloc.init
    tab_controller.viewControllers = [weather_nav_controller, tap_nav_controller, tip_nav_controller, alphabet_controller]

    # Sets the root controller to the tab controller we just defined
    @window.rootViewController = tab_controller

    # This makes the window a receiver of events
    @window.makeKeyAndVisible

    # This method must return true
    true
  end
end
