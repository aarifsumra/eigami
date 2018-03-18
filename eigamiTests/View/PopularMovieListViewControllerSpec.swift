//
//  PopularMovieListViewControllerSpec.swift
//  eigamiTests
//
//  Created by Aarif Sumra on 2018/03/18.
//

import Quick
import Nimble

@testable import eigami

class PopularMovieListViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Popular Movie List") {
            var sut: PopularMovieListViewController!
            
            beforeEach {
                sut = UIStoryboard.main.popularMovieListViewController
                _ = sut.view
            }
            
            afterEach {
                sut = nil
            }
            
            context("Layout") {
                
            }

        }
    }
}
