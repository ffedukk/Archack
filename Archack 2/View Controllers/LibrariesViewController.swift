//
//  LibrariesViewController.swift
//  Archack 2
//
//  Created by Fedor on 12/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class LibrariesViewController: UICollectionViewController {
    
    private let libraries : [Library] = [Trees(),People()]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.black
        
        setupCollectionViewLayout()
    }
}
    
private extension LibrariesViewController {
    private func setupCollectionViewLayout() {
        guard let collectionView = collectionView
            else {
                return
        }
        
        collectionView.register(UINib(nibName: "NewsHeader",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        collectionView.register(UINib(nibName: "LibrariesCell", bundle: nil), forCellWithReuseIdentifier: "librariesCell")
        
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
            libraryCell.scrollView.contentSize = CGSize(width: CGFloat(libraries[indexPath.item].photos.count) * collectionView.bounds.width, height: 250)
            
            libraryCell.pageControl.numberOfPages = libraries[indexPath.item].photos.count
            
            for (index,photo) in libraries[indexPath.item].photos.enumerated() {
                let imageView = UIImageView()
                imageView.image = UIImage(named: photo)
                imageView.contentMode = .scaleAspectFit
                libraryCell.scrollView.addSubview(imageView)
                imageView.frame.size.width = libraryCell.bounds.width
                imageView.frame.size.height = libraryCell.scrollView.contentSize.height
                imageView.frame.origin.x = CGFloat(index) * libraryCell.bounds.width
                print(imageView.frame.origin,imageView.frame,libraryCell.bounds.width)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case NewsCustomLayout.Element.header.kind:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NewsCustomLayout.Element.header.id, for: indexPath)
            return headerView
        default:
            fatalError("Expected Element Kind")
        }
    }
    
}

extension LibrariesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / CGFloat(2) - 44)
        return frame
    }
}

