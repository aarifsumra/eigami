//
//  PopularMovieListViewController.swift
//  eigami
//
//  Created by Aarif Sumra on 2018/03/18.
//

import UIKit
import RxSwift
import RxDataSources

final class PopularMovieListViewController: UIViewController {
    // Statics
    static let identifier = "PopularMovieListViewController"
    
    // Public
    var viewModel: PopularMovieListViewModel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: "MovieListCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: MovieListCell.identifier)
            collectionView.keyboardDismissMode = .onDrag
        }
    }
    
    // Private
    private let disposeBag = DisposeBag()
    private weak var refreshControl: UIRefreshControl!
    private weak var noResultsLabel: UILabel!
    private let dataSource = MovieListDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupNoResults()
        bindRx()
    }
    
}

// MARK:- Layout Configuration
fileprivate extension PopularMovieListViewController {
    
    func setupRefreshControl() {
        let rc = UIRefreshControl()
        rc.backgroundColor = .clear
        rc.tintColor = .lightGray
        collectionView.refreshControl = rc
        refreshControl = rc
    }
    
    func setupNoResults() {
        let label = UILabel()
        label.text = "No Movies Found!"
        label.sizeToFit()
        label.isHidden = true
        collectionView.backgroundView = label
        noResultsLabel = label
    }
}

fileprivate extension PopularMovieListViewController {
    
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
        collectionView.rx.reachedBottom
            .bind(to:viewModel.loadMore)
            .disposed(by: disposeBag)
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refresher)
            .disposed(by: disposeBag)
        viewModel.results.asObservable()
            .map { [Group<Movie>(header: "", items: $0)] }
            .do(onNext: { [unowned self] _ in
                self.refreshControl.endRefreshing()
            })
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension UIStoryboard {
    var popularMovieListViewController: PopularMovieListViewController {
        let identifier = PopularMovieListViewController.identifier
        guard let vc = self.instantiateViewController(withIdentifier: identifier) as? PopularMovieListViewController else {
            fatalError("PopularMovieListViewController couldn't be found in Storyboard file")
        }
        return vc
    }
}
