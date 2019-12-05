//
//  LoadingCell.swift
//  Archack 2
//
//  Created by Fedor on 05/12/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let _ = layoutAttributes as? NewsCustomLayoutAttributes else {
            return
        }
    }
    
}
