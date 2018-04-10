//
//  TMDBApi.swift
//  eigami
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import Moya

// MARK: Privates
fileprivate let apiURLString = "https://api.themoviedb.org/3"
fileprivate let defaultParams: [String : Any] = [
    "api_key": "TMDB_API_KEY",
    "language": "en-US",
    "include_adult": false
]

// MARK: Globals
var showActivity = false
let TMDBprovider = MoyaProvider<TMDB>(
    plugins: [
//        NetworkLoggerPlugin(verbose: true),
        NetworkActivityPlugin(networkActivityClosure: { changeType, targetType in
            switch changeType {
            case .began:
                showActivity = true
                break
            case .ended:
                showActivity = false
                break
            }
        })
    ]
)

// MARK: API Enum
public enum TMDB {
    case movie(id: Int)
    case searchMovie(query: String, page: Int)
    case popularMovie(page: Int)
}

// MARK: Conform Target Type
extension TMDB: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: apiURLString) else {
            fatalError("Invalid API URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .movie(let id):
            return "/movie/\(id)"
        case .searchMovie:
            return "/search/movie"
        case .popularMovie:
            return "/movie/popular"
        }
    }
    
    public var method: Method {
        return .get
    }
    
    public var sampleData: Data {
        switch self {
        case .searchMovie:
            return Stubber.jsonDataFromFile("SearchMovie")
        case .popularMovie:
            return Stubber.jsonDataFromFile("PopularMovie")
        default:
            break
        }
        return Data()
    }
    
    public var task: Task {
        var params = defaultParams
        switch self {
        case .movie:
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .searchMovie(let query, let page):
            params["query"] = query
            params["page"] = page
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        case .popularMovie(let page):
            params["page"] = page
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.default
            )
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
