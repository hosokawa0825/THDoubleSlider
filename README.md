THDoubleSlider
======================
A slider that has 2 buttons

Features
------
+ Changing slider bar colors is allowed.
+ Changing slider handle views and highlighted slider handle views is allowed.
+ Like iOS defalut music app, if dragging finger is far away from slider bar, slider handle moves slow.
+ Move slider handle by inputted number.
+ Value change function is customizable.(defalut is linear)

How to run demo
------
1. clone repository to local
2. At THDoubleSlider folder, exec `pod install`
3. Open THDoubleSlider.xcworkspace and run.

How to use
------
1. Installation  
  THDoubleSlider can be added to a project using CocoaPods.  
  (But now podspec file is not added CocoaPods/Specs yet. So please use this spec repo https://github.com/hosokawa0825/Specs)  
  Execute this command, then added spec repository.  
  `pod repo add hosokawa0825Specs https://github.com/hosokawa0825/Specs`  

  Podfile example is this. Note that deployment_target => '5.0' is needed.
    platform :ios, :deployment_target => '5.0'
    pod 'THDoubleSlider'

2. Method swizzling  
  Add this code to top of didFinishLaunchingWithOptions method.

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
        NSError *error = nil;
        [UIWindow jr_swizzleMethod:@selector(sendEvent:)
                withMethod:@selector(mySendEvent:)
                error:&error];
        ...
    }

Documentation
------
Please see header files.

License
----------
Copyright &copy; 2012 hosokawa0825
Distributed under the [MIT License][mit].  
[MIT]: http://www.opensource.org/licenses/mit-license.php
