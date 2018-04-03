//
//  MovieListDataProvider.swift
//  eigami
//
//  Created by Aarif Sumra on 2018/04/03.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import RxDataSources

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
