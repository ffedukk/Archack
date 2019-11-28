//
//  LibrariesCell.swift
//  Archack 2
//
//  Created by Fedor on 12/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class LibrariesCell: UICollectionViewCell, UIScrollViewDelegate {

    let imageAlpha: [CGFloat] = [1,0.6,0.3]

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
        //scrollView.frame.size.height = 150
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        progressBar.setProgress(0, animated: false)
        progressBar.alpha = 1
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let progressBarValue = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
        progressBar.setProgress(Float(progressBarValue), animated: true)
        
        
        let itemWidth = scrollView.bounds.width / CGFloat(5)
        let maxIndex = round(scrollView.contentSize.width / itemWidth - 1)
        let targetX = scrollView.contentOffset.x
        var targetIndex: CGFloat = 0
        
        targetIndex = round(targetX/itemWidth)
        
        if targetIndex + 4 <= maxIndex && targetIndex >= 0{
            UIView.animate(withDuration: 0.5) {
                if targetIndex == 0 {
                    scrollView.subviews[Int(targetIndex)].alpha = self.imageAlpha[0]
                    scrollView.subviews[Int(targetIndex) + 1].alpha = self.imageAlpha[0]
                    scrollView.subviews[Int(targetIndex) + 2].alpha = self.imageAlpha[0]
                    scrollView.subviews[Int(targetIndex) + 3].alpha = self.imageAlpha[1]
                    scrollView.subviews[Int(targetIndex) + 4].alpha = self.imageAlpha[2]
                } else if targetIndex == maxIndex - 4 {
                    scrollView.subviews[Int(targetIndex)].alpha = self.imageAlpha[2]
                    scrollView.subviews[Int(targetIndex) + 1].alpha = self.imageAlpha[1]
                    scrollView.subviews[Int(targetIndex) + 2].alpha = self.imageAlpha[0]
                    scrollView.subviews[Int(targetIndex) + 3].alpha = self.imageAlpha[0]
                    scrollView.subviews[Int(targetIndex) + 4].alpha = self.imageAlpha[0]
                } else {
                    scrollView.subviews[Int(targetIndex)].alpha = self.imageAlpha[2]
                    scrollView.subviews[Int(targetIndex) + 1].alpha = self.imageAlpha[1]
                    scrollView.subviews[Int(targetIndex) + 2].alpha = self.imageAlpha[0]
                    scrollView.subviews[Int(targetIndex) + 3].alpha = self.imageAlpha[1]
                    scrollView.subviews[Int(targetIndex) + 4].alpha = self.imageAlpha[2]
                }
            }
        }
        print(targetIndex,maxIndex)
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
        if targetIndex < 0 {
            targetIndex = 0
        }
        if targetIndex > maxIndex {
            targetIndex = maxIndex
        }
        targetContentOffset.pointee.x = targetIndex * itemWidth
    }
}
