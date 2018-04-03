//
//  PopularMovieListViewModel.swift
//  eigami
//
//  Created by Aarif Sumra on 2018/03/18.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa

final class PopularMovieListViewModel {
    
    // Inputs
    var refresher = PublishSubject<Void>()
    var loadMore = PublishSubject<Void>()
    
    // Outputs
    let results: Driver<[Movie]>
    let currentPage: Driver<Int>
    
    // Private
    private let pageNo: Variable<Int>
    private let movies: Variable<[Movie]>
    private let provider: MoyaProvider<TMDB>
    
    init(provider: MoyaProvider<TMDB>) {
        self.provider = provider
        
        let pageNo = Variable(0)
        self.pageNo = pageNo
        self.currentPage = pageNo.asObservable()
            .share()
            .asDriver(onErrorJustReturn: -1)
        
        let movies = Variable<[Movie]>([])
        self.movies = movies
        
        let refresh = refresher.asObservable()
            .startWith(())
            .do(onNext: {
                pageNo.value = 0
            })
        
        let loadNext = loadMore.asObservable()
            .do(onNext: { _ in
                pageNo.value += 1
            })
        
        let request = Observable.of(refresh,loadNext)
            .merge()
            .share()
            .asDriver(onErrorDriveWith: Driver.empty())
        
        results = request
            .flatMap { _ in
                return provider.rx
                    .request(.popularMovie(page: pageNo.value + 1))
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

