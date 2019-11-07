//
//  Extensions.swift
//  Archack 2
//
//  Created by Fedor on 07/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import Foundation

func shufflePhotos(in photos: [String]) -> ([String]) {
    var newPhotos = [String]()
    var oldPhotos = photos
    
    while !oldPhotos.isEmpty {
        let index = arc4random_uniform(UInt32(oldPhotos.count))
        newPhotos.append(oldPhotos.remove(at: Int(index)))
    }
    
    
    return newPhotos
}
