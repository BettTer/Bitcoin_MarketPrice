//
//  AppDelegate.swift
//  CurrentBitcoinPrice
//
//  Created by X Young. on 2019/10/24.
//  Copyright © 2019 X Young. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: CGRect.screen())
        window!.makeKeyAndVisible()
        
        
        let homePageVC = HomePageVC.init(nibName: "HomePageVC", bundle: .main)
        let rootNavigationC = UINavigationController.init(rootViewController: homePageVC)
        
        window!.rootViewController = rootNavigationC
        
        
        
        return true
    }

}

