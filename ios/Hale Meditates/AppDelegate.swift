//
//  AppDelegate.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/8/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit
import AVFoundation
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let audioPlayer = AVPlayer();


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupParseAPI(launchOptions);
        setViewController();
        UITabBar.appearance().tintColor = UIColor.whiteColor();
        return true
    }
    
    private func setViewController() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        if let vc = UIUtil.getViewControllerFromStoryboard("MainTabBarController") as? UITabBarController {
            self.window?.rootViewController = vc;
        }
        
        self.window?.makeKeyAndVisible()
    }
    
    private func setupParseAPI(launchOptions: [NSObject: AnyObject]?) {
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("xffaG4Dm0LciMVY6xDMaJr8aqkpddEdyEF4UyQyN",
            clientKey: "5gHHQLuxSAxrU90aSpMQvoeOknUohzsb7EMF5i8X")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions);
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

