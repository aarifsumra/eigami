//
//  LoginViewModelSpec.swift
//  eigamiTests
//
//  Created by aarif on 2018/03/11.
//

import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import Moya

@testable import eigami

class LoginViewModelSpec: QuickSpec {
    override func spec() {
        var sut: LoginViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            SharingScheduler.mock(scheduler: scheduler) {
                let stubProvider = MoyaProvider<TMDB>(stubClosure: MoyaProvider.immediatelyStub)
                sut = LoginViewModel(provider: stubProvider)
            }
            disposeBag = DisposeBag()
        }
        
        afterEach {
            sut = nil
            scheduler = nil
            disposeBag = nil
        }
        
        it("sends login done when login tap valid credentials entered") {
            let observer = scheduler.createObserver(Bool.self)
            scheduler.scheduleAt(100) {
                sut.loginDone
                    .drive(observer)
                    .disposed(by: disposeBag)
            }
            // Wrong user
            scheduler.scheduleAt(200) {
                sut.email.value = "wronguser@example.com"
                sut.password.value = "wrongpassword"
            }
            scheduler.scheduleAt(300) {
                sut.loginTap.onNext(())
            }
            // Correct User
            scheduler.scheduleAt(400) {
                sut.email.value = "user@example.com"
                sut.password.value = "password"
            }
            scheduler.scheduleAt(500) {
                sut.loginTap.onNext(())
            }
            scheduler.start()
            
            let results = observer.events
                .map { event in
                    event.value.element!
            }
            
            expect(results) == [false, true]
        }
        
        it("enables ui element when credentials are entered") {
            let observer = scheduler.createObserver(Bool.self)
            
            scheduler.scheduleAt(100) {
                sut.enableLogin
                    .drive(observer)
                    .disposed(by: disposeBag)
            }
            
            scheduler.scheduleAt(200) {
                sut.email.value = "a@b"
            }
            
            scheduler.scheduleAt(300) {
                sut.email.value = "a@b.c"
            }
            
            scheduler.scheduleAt(400) {
                sut.password.value = "aaaaa"
            }
            
            scheduler.scheduleAt(500) {
                sut.password.value = "aaaaaaaaaa"
            }
            
            scheduler.start()
            
            let results = observer.events
                .map { event in
                    event.value.element!
            }
            
            expect(results) == [false, false, false, false, true]
        }
    }
}
