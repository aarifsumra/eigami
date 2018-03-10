//
//  MovieSpec.swift
//  eigamiTests
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import Quick
import Nimble

@testable import eigami

class MovieSpec: QuickSpec {
    override func spec() {
        describe("A Movie") {
            var sut: Movie!
            
            // Sample Data
            let testId = 123456789
            let testTitle = "Test Title"
            let testOverview = "Lorem ipsum dolor sit amet"
            let testPosterPath = "test_poster_path"
            let testReleaseDate = "2020-01-01"
            let testStatus = "test status"
            
            it("must have id and a title") {
                sut = Movie(id: testId, title: testTitle)
                expect(sut.id) == testId
                expect(sut.title) == testTitle
            }
            
            it("should have a overview, poster, release date and status") {
                sut = Movie(
                    id: testId,
                    title: testTitle,
                    overview: testOverview,
                    posterPath: testPosterPath,
                    releaseDate: testReleaseDate,
                    status: testStatus
                )
                expect(sut.id) == testId
                expect(sut.title) == testTitle
                expect(sut.overview) == testOverview
                expect(sut.posterPath) == testPosterPath
                expect(sut.releaseDate) == testReleaseDate
                expect(sut.status) == testStatus
            }
            
            it("converts from valid json (confirming codable protocol)") {
                let jsonString =
                """
                
                {
                    "id": \(testId),
                    "title": "\(testTitle)",
                    "overview": "\(testOverview)",
                    "release_date": "\(testReleaseDate)",
                    "status": "\(testStatus)"
                }
                """
                guard let jsonData = jsonString.data(using: .utf8) else {
                    fatalError("Invalid JSON")
                }
                let decoder = JSONDecoder()
                sut = try! decoder.decode(Movie.self, from: jsonData)
                expect(sut.id) == testId
                expect(sut.title) == testTitle
                expect(sut.overview) == testOverview
                expect(sut.posterPath).to(beNil())
                expect(sut.releaseDate) == testReleaseDate
                expect(sut.status) == testStatus
            }
        }
    }
}
