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
        
        //scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame.size.height = 150
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
        progressBar.setProgress(0, animated: false)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let progressBarValue = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)
        progressBar.setProgress(Float(progressBarValue), animated: true)
        

        let itemWidth = scrollView.bounds.width / CGFloat(5)
        let delta = scrollView.contentOffset.x.truncatingRemainder(dividingBy: itemWidth)
        //print(delta,scrollView.contentSize.width,scrollView.contentOffset.x)
        if scrollView.contentOffset.x > 0 && scrollView.contentOffset.x + scrollView.bounds.width < scrollView.contentSize.width && delta > 2 && delta < itemWidth - 2 && !scrollView.isDecelerating {
            if delta >= itemWidth / CGFloat(2) {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + delta, y: 0), animated: true)
            } else {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - delta, y: 0), animated: true)
            }
        }

    }



}
