//
//  AppDelegate.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/27/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Mixpanel


//Global variables
public var hasPopup = false

public var isPaused = true

public var currRow = -1

public var grayBackroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // Initialize Parse.
        Parse.setApplicationId("XJIzw2OrfHYRDaSfWh3mOE5mPzscDFvDJwTIRPR3",
            clientKey: "eaKbKG3Ud7vGUwF3lAEv9tlwTDqfjIPDtybXi6iF")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        Mixpanel.sharedInstanceWithToken("d540f867ee9a15b36cb49540ce3282ef")
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        mixpanel.track("App launched")
        
        return true
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

