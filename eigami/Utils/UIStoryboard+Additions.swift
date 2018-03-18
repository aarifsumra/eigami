//
//  UIStoryboard+Additions.swift
//  eigami
//
//  Created by aarif on 2018/03/12.
//

import UIKit.UIStoryboard

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    var movieListViewController: MovieListViewController {
        let identifier = MovieListViewController.identifier
        guard let vc = self.instantiateViewController(withIdentifier: identifier) as? MovieListViewController else {
            fatalError("MovieListViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
    var popularTabViewController: PopularTabViewController {
        let identifier = PopularTabViewController.identifier
        guard let vc = self.instantiateViewController(withIdentifier: identifier) as? PopularTabViewController else {
            fatalError("PopularTabViewController couldn't be found in Storyboard file")
        }
        return vc
    }
}
