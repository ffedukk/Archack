//
//  LibrariesCell.swift
//  Archack 2
//
//  Created by Fedor on 12/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class LibrariesCell: UICollectionViewCell, UIScrollViewDelegate {


    @IBOutlet weak var libraryName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        scrollView.delegate = self
        
        scrollView.backgroundColor = UIColor.white
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.cornerRadius = 6
        scrollView.layer.masksToBounds = true
        layer.cornerRadius = 6
        layer.masksToBounds = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(page)
    }

}
