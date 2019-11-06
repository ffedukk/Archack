//
//  NewsCustomLayoutSettings.swift
//  Archack 2
//
//  Created by Fedor on 05/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

struct NewsCustomLayoutSettings {
    //Sizes
    var headerSize : CGSize?
    
    //Behaviour
    var isHeaderSticky : Bool
    
    // Spacing
    var minimumInteritemSpacing: CGFloat
    var minimumLineSpacing: CGFloat
}

extension NewsCustomLayoutSettings {
    init() {
        self.headerSize = nil
        self.isHeaderSticky = false
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
    }
}
