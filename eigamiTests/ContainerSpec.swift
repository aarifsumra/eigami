//
//  ContainerSpec.swift
//  eigamiTests
//
//  Created by Aarif Sumra on 2018/03/17.
//

import Quick
import Nimble

@testable import eigami

class ContainerSpec: QuickSpec {
    override func spec() {
        describe("Container Protocol") {
            var sut: Container!
            beforeEach {
                sut = MockViewController()
            }
            context("Requirements") {
                it("has a container view") {
                    expect(sut.view).notTo(beNil())
                }
            }
            context("Behaviour") {
                it("can add and remove another viewcontroller as a child") {
                    let childVC = UIViewController()
                    (sut as! MockViewController).add(contentViewController: childVC)
                    expect(childVC.view.superview!).to(be(sut.view))
                        expect(childVC.view.frame) == sut.view.frame
                        expect(childVC.parent).to(be(sut as! UIViewController))
                    (sut as! MockViewController).remove(contentViewController: childVC)
                    expect(childVC.view.superview).to(beNil())
                    expect(childVC.parent).to(beNil())
                }
            }
        }
    }
}

fileprivate extension ContainerSpec {
    
    class MockViewController: UIViewController, Container {
        
    }

}
