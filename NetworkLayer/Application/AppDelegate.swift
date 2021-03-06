//
//  AppDelegate.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let appStartVC = MainViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appStartVC
        window?.makeKeyAndVisible()
        return true
    }
}
