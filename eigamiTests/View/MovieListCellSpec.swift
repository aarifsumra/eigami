//
//  MovieListCellSpec.swift
//  eigamiTests
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxCocoa
import Kingfisher

@testable import eigami

class MovieListCellSpec: QuickSpec {
    override func spec() {
        var sut: MovieListCell!
        
        describe("Movie List Cell") {
            context("Layout") {
                beforeEach {
                    let cv = MockCollectionView()
                    sut = cv.dequeueReusableCell(withReuseIdentifier: MovieListCell.identifier, for: IndexPath(row: 0, section: 0)) as! MovieListCell
                }
                it("has an reuse identifier") {
                    expect(MovieListCell.identifier).notTo(beNil())
                }
                
                it("has a imageview to show movie poster") {
                    expect(sut.posterImageView).notTo(beNil())
                }
            }
            context("Behaviour") {
                var cv: MockCollectionView!
                beforeEach {
                    cv = MockCollectionView()
                    sut = cv.dequeueReusableCell(withReuseIdentifier: MovieListCell.identifier, for: IndexPath(row: 0, section: 0)) as! MovieListCell
                }
                it("can be configured with movie item") {
                    let movie = Movie(id: 1, title: "test", posterPath: "/test")
                    sut.configure(forItem: movie)
                    let posterURLString = sut.posterImageView.kf.webURL!.absoluteString
                    expect(posterURLString) == "https://image.tmdb.org/t/p/w500" + "/test"
                }
                it("cancels image download task when reused") {
                    ImageCache.default.clearDiskCache()
                    waitUntil(timeout: 1.0) { done in
                        sut.posterImageView.kf.setImage(with: self.largeImageURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (_, err, _, url) in
                            expect(err!.code) == KingfisherError.downloadCancelledBeforeStarting.rawValue
                            expect(url!) == self.largeImageURL
                            done()
                        })
                        sut.prepareForReuse()
                    }
                    
                }
            }
            
        }
    }
}

fileprivate extension MovieListCellSpec {
    
    var largeImageURL: URL {
        return URL(string: "https://upload.wikimedia.org/wikipedia/commons/7/72/%27Calypso%27_Panorama_of_Spirit%27s_View_from_%27Troy%27_%28Stereo%29.jpg")!
    }
    
    class MockCollectionView: UICollectionView {
        private let fakeDataSource = FakeDataSource()
        convenience init() {
            self.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
            self.dataSource = self.fakeDataSource
            self.register(UINib(nibName: "MovieListCell", bundle: nil), forCellWithReuseIdentifier: MovieListCell.identifier)
        }
    }
    
    class FakeDataSource: NSObject, UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell()
        }
    }
}
