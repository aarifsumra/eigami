//
//  PopularMovieListViewModel.swift
//  eigamiTests
//
//  Created by Aarif Sumra on 2018/03/18.
//

import Quick
import Nimble
import RxSwift
import RxTest
import RxCocoa
import Moya

@testable
import eigami

class PopularMovieListViewModelSpec: QuickSpec {
    
    struct SearchMovieResponse: Codable {
        let results: [Movie]
    }
    
    override func spec() {
        describe("Movie List ViewModel") {
            var sut: PopularMovieListViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                SharingScheduler.mock(scheduler: scheduler) {
                    let stubProvider = MoyaProvider<TMDB>(stubClosure: MoyaProvider.immediatelyStub)
                    sut = PopularMovieListViewModel(provider: stubProvider)
                }
                disposeBag = DisposeBag()
            }
            
            afterEach {
                scheduler = nil
                sut = nil
                disposeBag = nil
            }
            
            it("should get 20 movie list from api when loaded") {
                let observer = scheduler.createObserver([Movie].self)
                
                scheduler.scheduleAt(100) {
                    sut.results
                        .drive(observer)
                        .disposed(by: disposeBag)
                }
                
                scheduler.scheduleAt(200) {
                    sut.loadMore.onNext(())
                }
                
                scheduler.start()
                
                let firstEvent = observer.events.first!
                let count = firstEvent.value.element!.count
                expect(count) == 20
            }
            
            it("should clear the existing movie list and set the page no to 0 ") {
                let observer = scheduler.createObserver(Int.self)
                
                scheduler.scheduleAt(100) {
                    sut.currentPage
                        .drive(observer)
                        .disposed(by: disposeBag)
                    sut.results
                        .drive()
                        .disposed(by: disposeBag)
                }
                
                scheduler.scheduleAt(200) {
                    sut.refresher.onNext(())
                }
                
                scheduler.scheduleAt(300) {
                    sut.loadMore.onNext(())
                }
                
                scheduler.scheduleAt(400) {
                    sut.refresher.onNext(())
                }
                
                scheduler.start()
                
                XCTAssertEqual(observer.events, [
                    next(101, 0),
                    next(102, 0),
                    next(201, 0),
                    next(301, 1),
                    next(401, 0)
                    ])
            }
            
            it("should call api with increamented page no. when load more signal received") {
                let observer = scheduler.createObserver(Int.self)
                
                scheduler.scheduleAt(100) {
                    sut.currentPage
                        .drive(observer)
                        .disposed(by: disposeBag)
                    sut.results
                        .drive()
                        .disposed(by: disposeBag)
                }
                
                scheduler.scheduleAt(200) {
                    sut.loadMore.onNext(())
                }
                
                scheduler.scheduleAt(300) {
                    sut.loadMore.onNext(())
                }
                
                scheduler.start()
                
                let expected = [
                    next(101, 0),
                    next(102, 0),
                    next(201, 1),
                    next(301, 2),
                ]
                XCTAssertEqual(observer.events, expected)
            }
            
        }
    }
}

