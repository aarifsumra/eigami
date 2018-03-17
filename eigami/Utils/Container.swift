//
//  Container.swift
//  eigami
//
//  Created by Aarif Sumra on 2018/03/17.
//
import UIKit.UIView

protocol Container: class {
    var view: UIView! { get }
}

extension Container where Self: UIViewController {
    func add(contentViewController content: UIViewController) {
        addChildViewController(content)
        content.view.frame = view.bounds
        view.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    func remove(contentViewController content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
}
