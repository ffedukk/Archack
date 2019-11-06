//
//  NewsCellCollectionViewCell.swift
//  Archack 2
//
//  Created by Fedor on 05/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var container: UIView!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let _ = layoutAttributes as? NewsCustomLayoutAttributes else {
            return
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.cornerRadius = 6
        container.layer.masksToBounds = true
    }
}
