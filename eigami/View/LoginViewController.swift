//
//  LoginViewController.swift
//  eigami
//
//  Created by aarif on 2018/03/11.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel {
    
    
    let email = PublishSubject<String>()
    let password = PublishSubject<String>()
    let loginTap = PublishSubject<Void>()
}

class LoginViewController: UIViewController {
    static let identifier = "LoginViewControllerIdentifier"
    
    
    // Publics
    var viewModel: LoginViewModel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // Privates
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingRx()
    }
    
}

fileprivate extension LoginViewController {
    func bindingRx() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        loginButton.rx.tap
            .bind(to: viewModel.loginTap)
            .disposed(by: disposeBag)
    }
}
