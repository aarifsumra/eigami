//
//  AppDelegate.swift
//  eigami
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let window = UIWindow()
        window.rootViewController = windowRootViewController
        window.makeKeyAndVisible()
        window.tintColor = AppTintColor
        self.window = window
        ImageCache.default.maxMemoryCost = 1
    }
    
}

fileprivate extension AppDelegate {
    
    var windowRootViewController: UIViewController {
        // Tab 1
        let movieListVC = UIStoryboard.main.movieListViewController
        movieListVC.viewModel = MovieListViewModel(provider: TMDBprovider)
        let tab1 = UINavigationController(rootViewController: movieListVC)
        // Tab 2
        let tab2 = UIViewController()
        tab2.title = "Tab 2"
        // Tab 3
        let tab3 = UIViewController()
        tab3.title = "Tab 3"
        // Tab 4
        let tab4 = UIViewController()
        tab4.title = "Tab 4"
        
        // Prepare TabbarContoller
        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers([tab1, tab2, tab3, tab4], animated: false)
        return tabBarVC
    }
    
}

