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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let movieListVC = storyboard.instantiateViewController(withIdentifier: MovieListViewController.identifier) as! MovieListViewController
        movieListVC.viewModel = MovieListViewModel(provider: TMDBprovider)
        let nvc = UINavigationController(rootViewController: movieListVC)
        window.rootViewController = nvc
        window.makeKeyAndVisible()
        self.window = window
        ImageCache.default.maxMemoryCost = 1
    }
}

