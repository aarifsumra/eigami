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
        self.window = window
        ImageCache.default.maxMemoryCost = 1
    }
    
}

fileprivate extension AppDelegate {
    var windowRootViewController: UIViewController {
        let movieListVC = UIStoryboard.main.movieListViewController
        movieListVC.viewModel = MovieListViewModel(provider: TMDBprovider)
        return UINavigationController(rootViewController: movieListVC)
    }
}

