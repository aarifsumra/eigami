//
//  PopularMovieListViewControllerSpec.swift
//  eigamiTests
//
//  Created by Aarif Sumra on 2018/03/18.
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
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var sut: PopularMovieListViewController!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            SharingScheduler.mock(scheduler: scheduler) {
                sut = UIStoryboard.main.popularMovieListViewController
                let stubProvider = MoyaProvider<TMDB>(stubClosure: MoyaProvider.immediatelyStub)
                sut.viewModel = PopularMovieListViewModel(provider: stubProvider)
            }
            disposeBag = DisposeBag()
        }
        
        afterEach {
            scheduler = nil
            sut = nil
            disposeBag = nil
        }
        
        context("after view did load") {
            beforeEach {
                _ = sut.view
            }
            
            it("should have a collection view") {
                expect(sut.collectionView).notTo(beNil())
            }
            
            it("has a view model") {
                expect(sut.viewModel).notTo(beNil())
            }
            
            it("has a refresh control in collection view") {
                expect(sut.collectionView.refreshControl).notTo(beNil())
            }
            
            it("has a no results found view as background view and is hidden") {
                if let label = sut.collectionView.backgroundView as? UILabel {
                    expect(label).notTo(beNil())
                    expect(label.isHidden).to(beTrue())
                } else {
                    fail("Collection view background view not set to show 'no results' message")
                }
            }
        }
        
    }
}
