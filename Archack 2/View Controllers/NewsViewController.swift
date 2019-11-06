//
//  ViewController.swift
//  Archack 2
//
//  Created by Fedor on 05/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class NewsViewController: UICollectionViewController {

    var customLayout : NewsCustomLayout? {
        return collectionView?.collectionViewLayout as? NewsCustomLayout
    }
    
    //MARK: - Properties
    
    private let libraries : [Library] = [Trees(),People()]
    private var allPhotos : [String] {
        var photos = [String]()
        for library in libraries{
            photos += library.photos
        }
        
        return photos
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - View LIfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.black
        
        if let layout = collectionView?.collectionViewLayout as? NewsCustomLayout {
            layout.delegate = self
        }
        setupCollectionViewLayout()
    }

}

private extension NewsViewController {
    private func setupCollectionViewLayout() {
        guard let collectionView = collectionView,
            let customLayout = customLayout else {
                return
        }
        
        collectionView.register(UINib(nibName: "NewsHeader",bundle: nil), forSupplementaryViewOfKind: NewsCustomLayout.Element.header.kind, withReuseIdentifier: NewsCustomLayout.Element.header.id)
        
        collectionView.register(UINib(nibName: "NewsCell", bundle: nil), forCellWithReuseIdentifier: NewsCustomLayout.Element.cell.id)
        
        customLayout.settings.headerSize = CGSize(width: collectionView.frame.width, height: 70)
        customLayout.settings.isHeaderSticky = true
        customLayout.settings.minimumInteritemSpacing = 0
        customLayout.settings.minimumLineSpacing = 0
    }
}

//MARK: - CollectionViewDataSourse

extension NewsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCustomLayout.Element.cell.id, for: indexPath)
        if let photoCell = cell as? NewsCell {
            photoCell.imageView.image = UIImage(named: allPhotos[indexPath.item] )
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

extension NewsViewController : NewsCustomLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if let image = UIImage(named: allPhotos[indexPath.item]){
            var height = image.size.height
            let width = image.size.width
            height *= ( collectionView.frame.width / CGFloat(2) ) / width
            return height
        } else {
            return 0
        }
    }
}






