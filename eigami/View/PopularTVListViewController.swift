//
//  PopularTVListViewController.swift
//  eigami
//
//  Created by Aarif Sumra on 2018/03/18.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import UIKit

class PopularTVListViewController: UIViewController {
    static let identifier = "PopularTVListViewController"
}

extension UIStoryboard {
    var popularTVListViewController: PopularTVListViewController {
        let identifier = PopularTVListViewController.identifier
        guard let vc = self.instantiateViewController(withIdentifier: identifier) as? PopularTVListViewController else {
            fatalError("PopularTVListViewController couldn't be found in Storyboard file")
        }
        return vc
    }
}
