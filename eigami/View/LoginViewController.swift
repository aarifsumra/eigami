//
//  LoginViewController.swift
//  eigami
//
//  Created by aarif on 2018/03/11.
//

import UIKit
import RxSwift
import RxCocoa

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
        if viewModel == nil { return }
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        loginButton.rx.tap
            .bind(to: viewModel.loginTap)
            .disposed(by: disposeBag)
        
        viewModel.enableLogin
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.loginDone.asObservable()
            .subscribe(onNext: { loginDone in
                if loginDone {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}
