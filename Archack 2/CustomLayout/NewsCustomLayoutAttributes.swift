//
//  NewsCustomLayoutAttributes.swift
//  Archack 2
//
//  Created by Fedor on 05/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class NewsCustomLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // MARK: - Properties
    var initialOrigin: CGPoint = .zero
    
    // MARK: - Life Cycle
    override func copy(with zone: NSZone?) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? NewsCustomLayoutAttributes else {
            return super.copy(with: zone)
        }
        
        copiedAttributes.initialOrigin = initialOrigin
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? NewsCustomLayoutAttributes else {
            return false
        }
        
        if otherAttributes.initialOrigin != initialOrigin {
            return false
        }
        
        return super.isEqual(object)
    }
}
