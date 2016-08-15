//
// Copyright (C) 2016 Foursquare, Inc. and other contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//         http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?
    var viewController: ViewController!

    /**
     Handle URL Request e.g. fsoauthexample://authenticate....
     @param application A singleton app object.
     @param url The URL resource to open
     @param options A dictionary of launch options
     
     @note You must supply the ViewController containing the handleURL function.
    */
    
    func application(_ app: UIApplication, open url: URL, options: [String : AnyObject] = [:]) -> Bool {
        let vc: ViewController = self.window!.rootViewController as! ViewController
        vc.handleURL(url: url)
        return true
    }
    
    /**
     Tells the delegate that the data for continuing an activity is available.
     
     @param application A shared app object.
     @param userActivity The activity data associated with the task.
     @param restorationHandler A block to execute if your app creates objects to perform the task. (optional)
     
     @note You must supply the ViewController containing the handleURL function.
    */
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        var didHandle = false
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            self.viewController?.handleURL(url: userActivity.webpageURL!)
            didHandle = true
        }
        return didHandle
    }
    
    /**
     Tells the delegate that the launch process is almost done and loads up the ViewController to display.
     
     @param application A singleton app object.
     @param launchoptions A dictionary containing the reason the app was launched.
    */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewController = storyboard.instantiateInitialViewController() as! ViewController
        self.window?.rootViewController = self.viewController
        self.window?.makeKeyAndVisible()
        self.window?.makeKeyAndVisible()
        return true
    }

}

