//
//  Movie.swift
//  eigami
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

struct Movie: Codable {
    // Required
    let id: Int
    let title: String
    
    // Optionals
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let status: String?
    
    init(id: Int, title: String, overview: String? = nil, posterPath: String? = nil, releaseDate: String? = nil, status: String? = nil) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.status = status
    }
    
    // MARK: Codable Protocol
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case status
        case posterPath = "poster_path"
        case overview
    }
}

extension Movie: Equatable {
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id // For now id comparision is enough
    }
}
