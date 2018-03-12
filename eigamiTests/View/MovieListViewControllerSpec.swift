//
//  MovieListViewControllerSpec.swift
//  eigamiTests
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import Quick
import Nimble
import Moya
import RxSwift
import RxTest
import RxCocoa

@testable import eigami

class MovieListViewControllerSpec: QuickSpec {
    override func spec() {
        describe("List of Movie") {
            var sut: MovieListViewController!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                SharingScheduler.mock(scheduler: scheduler) {
                    sut = UIStoryboard.main.movieListViewController
                    let stubProvider = MoyaProvider<TMDB>(stubClosure: MoyaProvider.immediatelyStub)
                    sut.viewModel = MovieListViewModel(provider: stubProvider)
                    _ = sut.view
                }
                disposeBag = DisposeBag()
            }
            
            afterEach {
                scheduler = nil
                sut = nil
                disposeBag = nil
            }
            
            context("after view did load") {
                describe("Layout") {
                    it("has a search bar in navigation item to search for movies") {
                        expect(sut.navigationItem.titleView).to(beAnInstanceOf(UISearchBar.self))
                    }
                    it("has a collection view") {
                        expect(sut.collectionView).notTo(beNil())
                    }
                    it("collection view has a refresh control") {
                        expect(sut.collectionView.refreshControl).notTo(beNil())
                    }
                    it("collection view has a no results found view as background view and is hidden") {
                        if let label = sut.collectionView.backgroundView as? UILabel {
                            expect(label).notTo(beNil())
                            expect(label.isHidden).to(beTrue())
                        } else {
                            fail("Collection view background view not set to show 'no results' message")
                        }
                    }
                }
                describe("Behaviour") {
                    it("has a view model") {
                        expect(sut.viewModel).notTo(beNil())
                    }
                    context("When entered or changed text in searchbar") {
                        beforeEach {
                            scheduler.scheduleAt(200) {
                                let searchBar = sut.searchBar
                                searchBar.text = "Test"
                                searchBar.delegate!.searchBar!(searchBar, textDidChange: "Test")
                            }
                        }
                        it("sends event to viewmodel when entered text on search bar") {
                            let observer = scheduler.createObserver(String.self)
                            
                            scheduler.scheduleAt(100) {
                                sut.viewModel.search.asObservable()
                                    .subscribe(observer)
                                    .disposed(by: disposeBag)
                            }
                            
                            scheduler.start()
                            
                            XCTAssertEqual(observer.events, [next(200, "Test")])
                            
                        }
                        it("show collection view with 20 rows") {
                            scheduler.start()
                            
                            let count = sut.collectionView.numberOfItems(inSection: 0)
                            print(count)
                            expect(count) == 20
                        }
                        it("sends load more command to viewmodel when reached bottom of collection view") {
                            let observer = scheduler.createObserver(Void.self)
                            
                            scheduler.scheduleAt(100) {
                                sut.viewModel.loadMore
                                    .subscribe(observer)
                                    .disposed(by: disposeBag)
                            }
                            
                            scheduler.scheduleAt(300) {
                                let ip = IndexPath(item: 19, section: 0)
                                sut.collectionView.scrollToItem(at: ip, at: UICollectionViewScrollPosition.bottom, animated: false)
                            }
                            
                            scheduler.start()
                            
                            let result = observer.events.count
                            expect(result) == 1
                            expect(sut.collectionView.numberOfItems(inSection: 0)) == 40
                        }
                        
                    }
                }
            }
        }
    }
}
