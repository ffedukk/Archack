//
//  LibrariesCustomLayoutAttributes.swift
//  Archack 2
//
//  Created by Fedor on 15/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class LibrariesCustomLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // MARK: - Properties
    var initialOrigin: CGPoint = .zero
    
    // MARK: - Life Cycle
    override func copy(with zone: NSZone?) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? LibrariesCustomLayoutAttributes else {
            return super.copy(with: zone)
        }
        
        copiedAttributes.initialOrigin = initialOrigin
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? LibrariesCustomLayoutAttributes else {
            return false
        }
        
        if otherAttributes.initialOrigin != initialOrigin {
            return false
        }
        
        return super.isEqual(object)
    }
}
