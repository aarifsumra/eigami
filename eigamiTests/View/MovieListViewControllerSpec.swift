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
            
            context("after view did load") {
                describe("Layout") {
                    beforeEach {
                        sut = UIStoryboard.main.movieListViewController()
                        let stubProvider = MoyaProvider<TMDB>(stubClosure: MoyaProvider.immediatelyStub)
                        sut.viewModel = MovieListViewModel(provider: stubProvider)
                        _ = sut.view
                    }
                    afterEach {
                        sut = nil
                    }
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
                        let label = sut.collectionView.backgroundView as! UILabel
                        expect(label).notTo(beNil())
                        expect(label.isHidden).to(beTrue())
                    }
                }
                describe("Behaviour") {
                    context("When entered or changed text in searchbar") {
                        var scheduler: TestScheduler!
                        var disposeBag: DisposeBag!
                        beforeEach {
                            scheduler = TestScheduler(initialClock: 0, resolution: 1/1000)
                            SharingScheduler.mock(scheduler: scheduler) {
                                sut = UIStoryboard.main.movieListViewController(scheduler)
                                let stubProvider = MoyaProvider<TMDB>(stubClosure: MoyaProvider.immediatelyStub)
                                sut.viewModel = MovieListViewModel(provider: stubProvider)
                                _ = sut.view
                                disposeBag = DisposeBag()
                            }
                        }
                        afterEach {
                            scheduler = nil
                            sut = nil
                            disposeBag = nil
                        }
                        it("has a view model") {
                            expect(sut.viewModel).notTo(beNil())
                        }
                        it("hides keyboard when user scrolls") {
                            expect(sut.collectionView.keyboardDismissMode) == UIScrollViewKeyboardDismissMode.onDrag
                        }
                        
                        it("sends throttled text API and gets back the results") {
                            let time = [100, 200, 300, 400, 500, 600, 700, 800]
                            let texts = ["a", "ab", "abcd", "abcd", "abcd", "abcdef", "abcdefg"]
                            let searchBar = sut.searchBar
                            for i in 0..<texts.count {
                                scheduler.scheduleAt(time[i]) {
                                    searchBar.text = texts[i]
                                    searchBar.delegate!.searchBar!(searchBar, textDidChange: texts[i])
                                }
                            }
                            
                            let res = scheduler.start {
                                sut.viewModel.search.asObservable()
                            }
                            
                            let correct = Recorded.events(
                                .next(300, "abcd"),
                                .next(600, "abcdef"),
                                .next(900, "abcdefg")
                            )
                            
                            XCTAssertEqual(res.events, correct)
                            expect(sut.collectionView!.numberOfItems(inSection: 0)) == 20
                        }
                        it("sends load more command to viewmodel when reached bottom of collection view") {
                            scheduler.scheduleAt(210) {
                                let searchBar = sut.searchBar
                                searchBar.text = "test"
                                searchBar.delegate!.searchBar!(searchBar, textDidChange: "test")
                            }
                            scheduler.scheduleAt(500) {
                                let ip = IndexPath(item: 19, section: 0)
                                sut.collectionView.scrollToItem(at: ip, at: UICollectionViewScrollPosition.bottom, animated: false)
                            }
                            
                            let result = scheduler.start {
                                sut.viewModel.loadMore.asObservable()
                            }
                            
                            expect(result.events.count) == 1
                        }
                    }
                }
            }
        }
    }
}
