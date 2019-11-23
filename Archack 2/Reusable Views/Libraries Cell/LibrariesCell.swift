//
//  LibrariesCell.swift
//  Archack 2
//
//  Created by Fedor on 12/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class LibrariesCell: UICollectionViewCell, UIScrollViewDelegate {


    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var libraryName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        scrollView.delegate = self
        
        scrollView.backgroundColor = UIColor.white
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame.size.height = 150
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        progressBar.setProgress(0, animated: false)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let progressBarValue = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
        progressBar.setProgress(Float(progressBarValue), animated: true)
        
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let itemWidth = scrollView.bounds.width / CGFloat(5)
        let maxIndex = scrollView.contentSize.width / itemWidth - 1
        let targetX = scrollView.contentOffset.x + velocity.x * 60
        var targetIndex: CGFloat = 0
        
        if velocity.x > 0 {
            targetIndex = ceil(targetX/itemWidth)
        } else if velocity.x < 0 {
            targetIndex = floor(targetX/itemWidth)
        } else if velocity.x == 0 {
            targetIndex = round(targetX/itemWidth)
        }
        print(itemWidth,maxIndex,targetX,targetIndex)
        if targetIndex < 0 {
            targetIndex = 0
        }
        if targetIndex > maxIndex {
            targetIndex = maxIndex
        }
        
        targetContentOffset.pointee.x = targetIndex * itemWidth
    }



}
