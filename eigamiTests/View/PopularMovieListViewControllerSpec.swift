//
//  PopularMovieListViewControllerSpec.swift
//  eigamiTests
//
//  Created by Aarif Sumra on 2018/03/18.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import Quick
import Nimble
import Moya
import RxSwift
import RxTest
import RxCocoa

@testable import eigami

class PopularMovieListViewControllerSpec: QuickSpec {
    override func spec() {
        var sut: PopularMovieListViewController!
        
        
        
        context("after view did load") {
            beforeEach {
                sut = UIStoryboard.main.popularMovieListViewController
                let stubProvider = MoyaProvider<TMDB>(stubClosure: MoyaProvider.immediatelyStub)
                sut.viewModel = PopularMovieListViewModel(provider: stubProvider)
                _ = sut.view

            }
            
            it("has a view model") {
                expect(sut.viewModel).notTo(beNil())
            }
            
            it("should have a collection view") {
                expect(sut.collectionView).notTo(beNil())
            }
            
            it("has a refresh control in collection view") {
                expect(sut.collectionView.refreshControl).notTo(beNil())
            }
            
            it("has a no results found view as background view and is hidden") {
                let label = sut.collectionView.backgroundView as? UILabel
                expect(label).notTo(beNil())
                expect(label?.isHidden).to(beTrue())
            }
        }
        
        context("Behaviour") {
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                SharingScheduler.mock(scheduler: scheduler) {
                    sut = UIStoryboard.main.popularMovieListViewController
                    let stubProvider = MoyaProvider<TMDB>(stubClosure: MoyaProvider.immediatelyStub)
                    sut.viewModel = PopularMovieListViewModel(provider: stubProvider)
                    _ = sut.view
                }
                disposeBag = DisposeBag()
            }
            
            afterEach {
                scheduler = nil
                sut = nil
                disposeBag = nil
            }
            
            context("first load or refresh") {
                it("refreshes data when pulled down to refresh") {
                    let observer = scheduler.createObserver(Void.self)
                    scheduler.scheduleAt(100) {
                        sut.viewModel.refresher
                            .subscribe(observer)
                            .disposed(by: disposeBag)
                    }
                    
                    scheduler.scheduleAt(200) {
                        sut.collectionView.refreshControl?.sendActions(for: .valueChanged)
                    }
                    
                    scheduler.start()
                    
                    let results = observer.events.map {
                        $0.value
                    }
                    expect(results.count) == 1
                }
            }
            
            context("When user scrolls") {
                it("hides keyboard") {
                    expect(sut.collectionView.keyboardDismissMode) == UIScrollViewKeyboardDismissMode.onDrag
                }
                it("loads more items when reached bottom") {
                    let observer = scheduler.createObserver(Void.self)
                    let lastIndexPath = IndexPath(item: 19, section: 0)
                    
                    scheduler.scheduleAt(100) {
                        sut.viewModel.loadMore
                            .subscribe(observer)
                            .disposed(by: disposeBag)
                    }
                    
                    scheduler.scheduleAt(200) {
                        sut.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: false)
                    }
                    
                    scheduler.start()
                    
                    let result = observer.events.count
                    expect(result) == 1
                }
            }
        }
    }
}
