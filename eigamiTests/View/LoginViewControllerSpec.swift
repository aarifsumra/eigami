//
//  LoginViewControllerSpec.swift
//  eigamiTests
//
//  Created by aarif on 2018/03/11.
//

import Quick
import Nimble
import Moya
import RxSwift
import RxCocoa
import RxTest

@testable import eigami

class LoginViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Login View") {
            var sut: LoginViewController!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                SharingScheduler.mock(scheduler: scheduler) {
                    sut = self.loadLoginViewController()
                    sut.viewModel = LoginViewModel()
                    _ = sut.view
                }
                disposeBag = DisposeBag()
            }
            
            afterEach {
                scheduler = nil
                sut = nil
                disposeBag = nil
            }
            
            context("After view did load") {
                describe("layout") {
                    it("has a email input") {
                        expect(sut.emailTextField).notTo(beNil())
                        
                    }
                    it("has a secured password input") {
                        expect(sut.passwordTextField).notTo(beNil())
                        expect(sut.passwordTextField.isSecureTextEntry).to(beTrue())
                        
                    }
                    it("has a login button") {
                        expect(sut.loginButton).notTo(beNil())
                    }
                }
                describe("behaviour") {
                    it("has a view model") {
                        expect(sut.viewModel).notTo(beNil())
                    }
                    it("sends event to viewmodel when user enters email") {
                        let observer = scheduler.createObserver(String.self)
                        
                        scheduler.scheduleAt(100) {
                            sut.viewModel.email
                                .asObservable()
                                .subscribe(observer)
                                .disposed(by: disposeBag)
                        }
                        
                        scheduler.scheduleAt(200) {
                            let textField = sut.emailTextField!
                            textField.text = "Test"
                            textField.sendActions(for: .valueChanged)
                        }
                        scheduler.start()
                        
                        XCTAssertEqual(observer.events, [next(200, "Test")])
                    }
                    
                    it("sends event to viewmodel when user enters password") {
                        let observer = scheduler.createObserver(String.self)
                        
                        scheduler.scheduleAt(100) {
                            sut.viewModel.password
                                .asObservable()
                                .subscribe(observer)
                                .disposed(by: disposeBag)
                        }
                        
                        scheduler.scheduleAt(200) {
                            let textField = sut.passwordTextField!
                            textField.text = "TestPassword"
                            textField.sendActions(for: .valueChanged)
                        }
                        scheduler.start()
                        
                        XCTAssertEqual(observer.events, [next(200, "TestPassword")])
                    }
                    it("sends tap event to viewmodel when user taps login button") {
                        let observer = scheduler.createObserver(Void.self)
                        
                        scheduler.scheduleAt(100) {
                            sut.viewModel.loginTap
                                .asObservable()
                                .subscribe(observer)
                                .disposed(by: disposeBag)
                        }
                        
                        scheduler.scheduleAt(200) {
                            sut.loginButton.sendActions(for: .touchUpInside)
                        }
                        scheduler.start()
                        
                        let tapCount = observer.events.count
                        expect(tapCount) == 1
                    }
                }
            }
        }
    }
    
    private func loadLoginViewController() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard
            .instantiateViewController(
                withIdentifier: LoginViewController.identifier
            ) as! LoginViewController
    }
}
