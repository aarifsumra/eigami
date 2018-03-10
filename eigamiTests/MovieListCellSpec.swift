//
//  MovieListCellSpec.swift
//  eigamiTests
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import Quick
import Nimble
@testable import eigami

class MovieListCellSpec: QuickSpec {
    override func spec() {
        var sut: MovieListCell!
        
        beforeEach {
            sut = MovieListCell()
        }
        
        describe("Movie List Cell") {
            context("properties") {
                it("has an reuse identifier") {
                    expect(MovieListCell.identifier).notTo(beNil())
                }
                
                it("has a imageview to show movie poster") {
                    expect(sut.posterImageView).notTo(beNil())
                }
                it("has a review label") {
                    expect(sut.reviewsLabel).notTo(beNil())
                }
            }
            
            
        }
    }
}
