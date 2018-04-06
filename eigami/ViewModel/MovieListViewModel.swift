//
//  MovieListViewModel.swift
//  eigami
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa

class MovieListViewModel {
   
    // Inputs
    var search = PublishSubject<String>()
    var loadMore = PublishSubject<Void>()
    
    // Outputs
    let results: Driver<[Movie]>
    let currentPage: Driver<Int>
    
    // Private
    private let query: Variable<String>
    private let pageNo: Variable<Int>
    private let totalPages: Variable<Int>
    private let movies: Variable<[Movie]>
    private let provider: MoyaProvider<TMDB>
    
    init(provider: MoyaProvider<TMDB>) {
        self.provider = provider
        
        let query = Variable("")
        self.query = Variable("")
        
        let pageNo = Variable(0)
        self.pageNo = pageNo
        self.currentPage = pageNo.asObservable()
            .share()
            .asDriver(onErrorJustReturn: -1)
        
        let totalPages = Variable(100)
        self.totalPages = totalPages
        
        let movies = Variable<[Movie]>([])
        self.movies = movies
        
        let keyword = search.asDriver(onErrorJustReturn: "")
            .do(onNext: {
                query.value = $0
                pageNo.value = 0
            })
            .map { _ in () }
        
        let loadNext = loadMore.asObservable()
            .filter { _ in pageNo.value < totalPages.value }
            .do(onNext: { _ in
                pageNo.value += 1
            })
        
        let request = Observable.of(keyword.asObservable(),loadNext)
            .merge()
            .share()
            .asDriver(onErrorDriveWith: Driver.empty())
        
        results = request
            .flatMap { _ in
                return provider.rx
                    .request(.searchMovie(query: query.value, page: pageNo.value + 1))
                    .retry(3)
                    .do(onSuccess: { resp in
                        if pageNo.value > 0 { return }
                        do {
                            let decoder = JSONDecoder()
                            let data = try decoder.decode(ListAPIResponse.self, from: resp.data)
                            totalPages.value = data.totalPages
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                    .map([Movie].self, atKeyPath: "results")
                    .asDriver(onErrorJustReturn: [])
            }.do(onNext: {
                if pageNo.value == 0 {
                    movies.value = $0
                }
                else {
                    movies.value += $0
                }
            })
            .flatMap { _ in movies.asDriver() }
    }
    
}

fileprivate extension MovieListViewModel {

    struct ListAPIResponse: Codable {
        let totalPages: Int
        let results: [Movie]

        enum CodingKeys : String, CodingKey {
            case totalPages = "total_pages"
            case results
        }
    }
}
