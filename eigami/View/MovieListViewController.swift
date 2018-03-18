//
//  MovieListViewController.swift
//  eigami
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

final class MovieListViewController: UIViewController {
    // Statics
    static var identifier = "MovieListViewController"
    
    // Private
    private let disposeBag = DisposeBag()
    private var searchController: UISearchController!
    private weak var refreshControl: UIRefreshControl!
    private weak var noResultsLabel: UILabel!
    private let dataSource = MovieListDataProvider()
    // Public
    var viewModel: MovieListViewModel!
    var searchBar: UISearchBar { return searchController.searchBar }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: "MovieListCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: MovieListCell.identifier)
            collectionView.keyboardDismissMode = .onDrag
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupRefreshControl()
        setupNoResults()
        bindRx()
    }
    
}
// MARK:- Layout Configuration
fileprivate extension MovieListViewController {
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Movies"
        
        self.navigationItem.titleView = searchBar
    }
    
    func setupRefreshControl() {
        let rc = UIRefreshControl()
        rc.backgroundColor = .clear
        rc.tintColor = .lightGray
        collectionView.refreshControl = rc
        refreshControl = rc
    }
    
    func setupNoResults() {
        let label = UILabel()
        label.text = "No Movies Found!\n Please try different name again..."
        label.sizeToFit()
        label.isHidden = true
        collectionView.backgroundView = label
        noResultsLabel = label
    }
}

fileprivate extension MovieListViewController {
    
    class MovieListDataProvider: RxCollectionViewSectionedReloadDataSource<Group<Movie>> {
        convenience init() {
            self.init(
                configureCell: { (ds, cv, ip, item) -> UICollectionViewCell  in
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: MovieListCell.identifier, for: ip) as! MovieListCell
                    cell.configure(forItem: item)
                    return cell
            })
        }
    }
    
    func bindRx() {
        if viewModel == nil { return }
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.search)
            .disposed(by: disposeBag)
        collectionView.rx.reachedBottom
            .bind(to:viewModel.loadMore)
            .disposed(by: disposeBag)
        viewModel.results.asObservable()
            .map { [Group<Movie>(header: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension UIStoryboard {
    var movieListViewController: MovieListViewController {
        let identifier = MovieListViewController.identifier
        guard let vc = self.instantiateViewController(withIdentifier: identifier) as? MovieListViewController else {
            fatalError("MovieListViewController couldn't be found in Storyboard file")
        }
        return vc
    }
}
