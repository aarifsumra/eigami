//
//  MovieListCell.swift
//  eigami
//
//  Created by aarif on 2018/03/10.
//  Copyright © 2018 Aarif Sumra. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListCell: UICollectionViewCell {
    static let identifier = "MovieListCellIdentifier"
    @IBOutlet weak var posterImageView: UIImageView!
    
    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearAll()
    }
    
    func configure(forItem item: Movie) {
        if let path = item.posterPath, let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500" + path) {
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: posterUrl)
            posterImageView.kf.setImage(with: posterUrl, placeholder: #imageLiteral(resourceName: "No_image_poster"), completionHandler: {
                (image, error, cacheType, imageUrl) in
                if image == nil {
                    self.posterImageView.image = #imageLiteral(resourceName: "No_image_poster")
                }
            })
        }
    }
    
}

fileprivate extension MovieListCell {
    func clearAll() {
        posterImageView.image = #imageLiteral(resourceName: "No_image_poster")
    }
}

