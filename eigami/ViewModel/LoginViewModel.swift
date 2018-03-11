//
//  LoginViewModel.swift
//  eigami
//
//  Created by aarif on 2018/03/11.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa

fileprivate let demoEmail = "user@example.com"
fileprivate let demoPassword = "password"

class LoginViewModel {
    
    // Inputs
    let email = Variable("")
    let password = Variable("")
    let loginTap = PublishSubject<Void>()
    
    // Outputs
    let enableLogin: Driver<Bool>
    let loginDone: Driver<Bool>
    
    private let provider: MoyaProvider<TMDB>

    init(provider: MoyaProvider<TMDB>) {
        self.provider = provider
        
        let emailObservable = email.asObservable()
        let passwordObservable = password.asObservable()
        
        enableLogin = Observable
            .combineLatest(
                emailObservable,
                passwordObservable
            )
            { $0.isEmailValid() && $1.count > 6 }
            .asDriver(onErrorJustReturn: false)
        
        loginDone = Observable
            .combineLatest(
                emailObservable,
                passwordObservable
            )
            .sample(loginTap)
            // TMDB dont support direct username password authentication
            // hence faking API call
            // To see the sample of api please see MovieListViewModel
            .map { $0.0 == demoEmail && $0.1 == demoPassword }
            .asDriver(onErrorJustReturn: false)
    }
}

fileprivate extension String {
    
    private var emailPredicate: NSPredicate {
        let userid = "[A-Z0-9a-z._%+-]{1,}"
        let domain = "([A-Z0-9a-z._%+-]{1,}\\.){1,}"
        let regex = userid + "@" + domain + "[A-Za-z]{1,}"
        return NSPredicate(format: "SELF MATCHES %@", regex)
    }
    
    func isEmailValid() -> Bool {
        return emailPredicate.evaluate(with: self)
    }
    
}
