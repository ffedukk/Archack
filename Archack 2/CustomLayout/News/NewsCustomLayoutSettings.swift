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
    
    //Columns
    var numberOfColumns: Int
    
    // Spacing
    var minimumInteritemSpacing: CGFloat
    var minimumLineSpacing: CGFloat
    var cellPadding : CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
}

extension NewsCustomLayoutSettings {
    init() {
        self.headerSize = nil
        self.isHeaderSticky = false
        self.numberOfColumns = 0
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.cellPadding = 0
        self.leftInset = 0
        self.rightInset = 0
    }
}
