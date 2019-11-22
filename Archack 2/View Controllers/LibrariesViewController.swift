//
//  LibrariesViewController.swift
//  Archack 2
//
//  Created by Fedor on 12/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class LibrariesViewController: UICollectionViewController {
    
    var customLayout : LibrariesCustomLayout? {
        return collectionView?.collectionViewLayout as? LibrariesCustomLayout
    }
    
    private let libraries : [Library] = [Trees(),People(),Trees(),People()]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "newsHeader")
        
        navigationController?.navigationBar.setBackgroundImage(image?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: UIImageResizingMode.stretch), for: .default)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        
        collectionView?.backgroundColor = UIColor.black
        
        setupCollectionViewLayout()
    }
}
    
private extension LibrariesViewController {
    private func setupCollectionViewLayout() {
        guard let collectionView = collectionView,
        let customLayout = customLayout
            else {
                return
        }
        
        collectionView.register(UINib(nibName: "LibrariesCell", bundle: nil), forCellWithReuseIdentifier: "librariesCell")
        
        customLayout.settings.headerSize = CGSize(width: collectionView.frame.width, height: 90)
        customLayout.settings.scrollViewHeight = 130
        customLayout.settings.isHeaderSticky = true
        customLayout.settings.numberOfColumns = 1
        customLayout.settings.minimumInteritemSpacing = 6
        customLayout.settings.minimumLineSpacing = 12
        customLayout.settings.cellPadding = 0
        customLayout.settings.leftInset = 12
        customLayout.settings.rightInset = 12
        
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset.top = -UIApplication.shared.statusBarFrame.height
        collectionView.contentInset.left = customLayout.settings.leftInset
        collectionView.contentInset.right = customLayout.settings.rightInset
        collectionView.contentInset.top = 6
        
        collectionView.showsVerticalScrollIndicator = false
    }
}


//MARK: - CollectionViewDataSourse

extension LibrariesViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraries.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "librariesCell", for: indexPath)
        if let libraryCell = cell as? LibrariesCell {
            
            libraryCell.libraryName.text = libraries[indexPath.item].libraryName
            libraryCell.authorName.text = libraries[indexPath.item].author
            
            if let customLayout = customLayout {
            libraryCell.scrollView.contentSize = CGSize(width: CGFloat(libraries[indexPath.item].photos.count) * libraryCell.bounds.width / CGFloat(5), height: customLayout.settings.scrollViewHeight)
            }
                
            libraryCell.pageControl.numberOfPages = libraries[indexPath.item].photos.count
            
            for (index,photo) in libraries[indexPath.item].photos.enumerated() {
                let imageView = UIImageView()
                imageView.image = UIImage(named: photo)
                imageView.contentMode = .scaleAspectFit
                libraryCell.scrollView.addSubview(imageView)
                imageView.frame.size.width = libraryCell.bounds.width / CGFloat(5)
                imageView.frame.size.height = libraryCell.scrollView.contentSize.height
                imageView.frame.origin.x = CGFloat(index) * imageView.frame.width
                
                
                //print(imageView.frame.origin,imageView.frame,libraryCell.bounds.width)
            }
        }
        return cell
    }
    
}


//MARK: - Delegate Methods

extension LibrariesViewController {
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(collectionView?.contentOffset)
//        let image: UIImage
//        if (collectionView?.contentOffset.y)! > CGFloat(-94) {
//            image = UIImage(named: "newsHeader")!
//        } else {
//            image = UIImage(named: "newsHeader2")!
//        }
//        navigationController?.navigationBar.setBackgroundImage(image.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: UIImageResizingMode.stretch), for: .default)
//    }
}
