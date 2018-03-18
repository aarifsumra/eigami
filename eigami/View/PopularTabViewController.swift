//
//  PopularTabViewController.swift
//  eigami
//
//  Created by Aarif Sumra on 2018/03/17.
//

import UIKit

class PopularTabViewController: UIViewController, Container {
    static let identifier = "PopularTabViewController"
    
    private lazy var popularMovieListVC = {
       return UIStoryboard.main.popularMovieListViewController
    }()
    private lazy var popularTVListVC = {
        return UIStoryboard.main.popularTVListViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add(contentViewController: popularTVListVC)
        add(contentViewController: popularMovieListVC)
    }
}

extension UIStoryboard {
    var popularTabViewController: PopularTabViewController {
        let identifier = PopularTabViewController.identifier
        guard let vc = self.instantiateViewController(withIdentifier: identifier) as? PopularTabViewController else {
            fatalError("PopularTabViewController couldn't be found in Storyboard file")
        }
        return vc
    }
}