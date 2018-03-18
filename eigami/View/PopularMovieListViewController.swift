//
//  PopularMovieListViewController.swift
//  eigami
//
//  Created by Aarif Sumra on 2018/03/18.
//

import UIKit

class PopularMovieListViewController: UIViewController {
    static let identifier = "PopularMovieListViewController"
}

extension UIStoryboard {
    var popularMovieListViewController: PopularMovieListViewController {
        let identifier = PopularMovieListViewController.identifier
        guard let vc = self.instantiateViewController(withIdentifier: identifier) as? PopularMovieListViewController else {
            fatalError("PopularMovieListViewController couldn't be found in Storyboard file")
        }
        return vc
    }
}
