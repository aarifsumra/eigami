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

@testable import eigami

class MovieListCellSpec: QuickSpec {
    override func spec() {
        var sut: MovieListCell!
        
        beforeEach {
            let fakeDataSource = FakeDataSource()
            let frame = CGRect(x: 0, y: 0, width: 320, height: 565)
            let layout = UICollectionViewLayout()
            let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
            cv.dataSource = fakeDataSource
            cv.register(UINib(nibName: "MovieListCell", bundle: nil), forCellWithReuseIdentifier: MovieListCell.identifier)
            cv.reloadData()
            sut = cv.dequeueReusableCell(withReuseIdentifier: MovieListCell.identifier, for: IndexPath(row: 0, section: 0)) as! MovieListCell
        }
        
        describe("Movie List Cell") {
            context("properties") {
                it("has an reuse identifier") {
                    expect(MovieListCell.identifier).notTo(beNil())
                }
                
                it("has a imageview to show movie poster") {
                    expect(sut.posterImageView).notTo(beNil())
                }
            }
        }
    }
}

fileprivate extension MovieListCellSpec {
    class FakeDataSource: NSObject, UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return UICollectionViewCell()
        }
    }
}
