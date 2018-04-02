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
                    sut = UIStoryboard.main.movieListViewController(scheduler)
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

                        it("sends throttled text API and gets back the results") {
                            let searchBar = sut.searchBar
                            let observer = scheduler.createObserver(String.self)
                            
                            scheduler.scheduleAt(100) {
                                sut.viewModel.search
                                    .subscribe(observer)
                                    .disposed(by: disposeBag)
                            }
                            
                            let time = [150, 210, 250, 310, 350, 410, 450, 900]
                            let texts = ["a", "ab", "abc", "abcd", "abcde", "abcdef", "abcdefg", "zzzz"]
                            for i in 0..<texts.count {
                                scheduler.scheduleAt(time[i]) {
                                    searchBar.text = texts[i]
                                    searchBar.delegate!.searchBar!(searchBar, textDidChange: texts[i])
                                }
                            }
                            
                            scheduler.start()
                            
                            let correct = Recorded.events(
                                .next(500, "abcdefg"),
                                .next(1000, "zzzz")
                            )
                            
                            XCTAssertEqual(observer.events, correct)
                            expect(sut.collectionView!.numberOfItems(inSection: 0)) == 20

                        }
                        it("sends load more command to viewmodel when reached bottom of collection view") {
                            let searchBar = sut.searchBar
                            let observer = scheduler.createObserver(Void.self)
                            
                            scheduler.scheduleAt(400) {
                                searchBar.text = "test"
                                searchBar.delegate!.searchBar!(searchBar, textDidChange: "test")
                            }
                            scheduler.scheduleAt(600) {
                                let ip = IndexPath(item: 19, section: 0)
                                sut.collectionView.scrollToItem(at: ip, at: UICollectionViewScrollPosition.bottom, animated: false)
                            }
                            
                            scheduler.start()
                            
                            print(observer.events)
                            let result = observer.events.count
                            expect(result) == 1
                        }
                        
                    }
                
                    context("When user scrolls") {
                        it("hides keyboard") {
                            expect(sut.collectionView.keyboardDismissMode) == UIScrollViewKeyboardDismissMode.onDrag
                        }
                    }
                }
            }
        }
    }
}
