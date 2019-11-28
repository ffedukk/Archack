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
    
    private var libraries : [Library] = [Trees(),People(),Trees(),People(),Trees(),People()]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.black
        
        
        setupNavBar()
        setupCollectionViewLayout()
        setupRefreshControl()
    }
}
    
private extension LibrariesViewController {
    
    //MARK: - CollectionView Layout
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
        customLayout.settings.topInset = 6
        
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset.top = -UIApplication.shared.statusBarFrame.height
        collectionView.contentInset.left = customLayout.settings.leftInset
        collectionView.contentInset.right = customLayout.settings.rightInset
        collectionView.contentInset.top = customLayout.settings.topInset
        
        collectionView.showsVerticalScrollIndicator = false
    }
    //MARK: - Navigation Bar
    private func setupNavBar(){
        guard let navBar = navigationController?.navigationBar,
              let navController = navigationController
        else { return }
        
        let headerBlack = UIImage(named: "headerBlack")
        let headerWhite = UIImage(named: "headerWhite")
        
        navBar.barStyle = .black
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        navController.view.backgroundColor = .clear
        
        let headerBlackView = UIImageView(image: headerBlack)
        let headerWhiteView = UIImageView(image: headerWhite)
        
        headerBlackView.contentMode = .scaleAspectFill
        headerWhiteView.contentMode = .scaleAspectFill
        
        headerBlackView.frame.size = navBar.frame.size
        headerBlackView.frame.size.height -= 64
        headerWhiteView.frame.size = navBar.frame.size
        headerWhiteView.frame.size.height -= 64
        
        navBar.addSubview(headerBlackView)
        navBar.addSubview(headerWhiteView)
    }
    
    //MARK: RefreshControl
    func setupRefreshControl () {
        guard let collectionView = collectionView
        else { return }
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshStream), for: .valueChanged)
    }
    
    @objc func refreshStream() {
        collectionView?.refreshControl?.beginRefreshing()
        print("refresh")
        libraries.insert(People(), at: 0)
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
        
        
        collectionView?.refreshControl?.endRefreshing()
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
            
            
            for view in libraryCell.scrollView.subviews {
                if let view = view as? UIImageView {
                    view.removeFromSuperview()
                }
            }
            
            
            for (index,photo) in libraries[indexPath.item].photos.enumerated() {
                let imageView = UIImageView()
                imageView.image = UIImage(named: photo)
                imageView.contentMode = .scaleAspectFit
                libraryCell.scrollView.addSubview(imageView)
                imageView.frame.size.width = libraryCell.bounds.width / CGFloat(5)
                imageView.frame.size.height = libraryCell.scrollView.contentSize.height
                imageView.frame.origin.x = CGFloat(index) * imageView.frame.width
                
                switch index {
                case 0,1,2:
                    imageView.alpha = libraryCell.imageAlpha[0]
                case 3:
                    imageView.alpha = libraryCell.imageAlpha[1]
                default:
                    imageView.alpha = libraryCell.imageAlpha[2]
                }
            }
            libraryCell.scrollView.contentOffset.x = 0
        }
        return cell
    }
    
}


//MARK: - Delegate Methods

extension LibrariesViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let navBar = navigationController?.navigationBar {
            let currentOffset = scrollView.contentOffset.y + UIApplication.shared.statusBarFrame.height + navBar.frame.height + scrollView.contentInset.top
            let maxOffset: CGFloat = 50
            if currentOffset < maxOffset {
                navBar.subviews.last?.alpha = (maxOffset-currentOffset)/maxOffset
            }
            else {
                navBar.subviews.last?.alpha = 0
            }
            
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            
            if deltaOffset <= 0 {
                loadMore()
            }
        }
    }
    
    func loadMore() {
        libraries.append(People())
    }
}
