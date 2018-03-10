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
        
        let movies = Variable<[Movie]>([])
        self.movies = movies
        
        let keyword = search.asDriver(onErrorJustReturn: "")
            .throttle(0.5)
            .distinctUntilChanged()
            .do(onNext: {
                query.value = $0
                pageNo.value = 0
            })
            .map { _ in () }
        
        let loadNext = loadMore.asObservable()
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
