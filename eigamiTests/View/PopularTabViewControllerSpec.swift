//
//  PopularTabViewControllerSpec.swift
//  eigamiTests
//
//  Created by Aarif Sumra on 2018/03/17.
//

import Quick
import Nimble

@testable import eigami

class PopularTabViewControllerSpec: QuickSpec {
    override func spec() {
        describe("Popular Tab") {
            var sut: PopularTabViewController!
            
            beforeEach {
                sut = UIStoryboard.main.popularTabViewController
                _ = sut.view
            }
            
            afterEach {
                sut = nil
            }
            
            it("has a storyboard identifier") {
                expect(type(of: sut).identifier).notTo(beNil())
            }
            
            it("has a title name popular") {
                expect(sut.title) == "Popular"
            }
            
            it("has a popular movies list as a child") {
                var result = false
                for childVC in sut.childViewControllers {
                    if childVC is PopularMovieListViewController {
                        result = true
                    }
                }
                expect(result).to(beTrue())
            }
            
            it("has a popular tv list as a child") {
                var result = false
                for childVC in sut.childViewControllers {
                    if childVC is PopularTVListViewController {
                        result = true
                    }
                }
                expect(result).to(beTrue())
            }
        }
    }
}
