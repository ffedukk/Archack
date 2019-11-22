//
//  LibrariesCustomLayout.swift
//  Archack 2
//
//  Created by Fedor on 15/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

class LibrariesCustomLayout: UICollectionViewLayout {
    
    enum Element: String {
        case header
        case cell
        
        var id: String {
            return self.rawValue
        }
        
        var kind: String {
            return "Kind\(self.rawValue.capitalized)"
        }
    }
    
    override public class var layoutAttributesClass: AnyClass {
        return LibrariesCustomLayoutAttributes.self
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: contentHeight)
    }
    
    var settings = LibrariesCustomLayoutSettings()
    
    private var oldBounds = CGRect.zero
    private var contentHeight = CGFloat()
    private var cache = [Element: [IndexPath: LibrariesCustomLayoutAttributes]]()
    private var visibleLayoutAttributes = [LibrariesCustomLayoutAttributes]()
    private var zIndex = 0
    
    private var collectionViewHeight: CGFloat {
        return collectionView!.frame.height
    }
    
    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width - ( settings.leftInset + settings.rightInset )
    }
    
    private var headerSize: CGSize {
        guard let headerSize = settings.headerSize else {
            return .zero
        }
        
        return headerSize
    }
    
    private var contentOffset: CGPoint {
        return collectionView!.contentOffset
    }

    private var columnWidth: CGFloat {
        return collectionViewWidth / CGFloat(settings.numberOfColumns)
    }
}

//MARK: - Layout Core Prosses

extension LibrariesCustomLayout {
    override func prepare() {
        guard let collectionView = collectionView,
            cache.isEmpty else {
                return
        }
        prepareCache()
        contentHeight = 0
        oldBounds = collectionView.bounds
        zIndex = 0
        
        var yOffset: CGFloat = 0
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let cellIndexPath = IndexPath(item: item, section: 0)
            let attributes = LibrariesCustomLayoutAttributes(forCellWith: cellIndexPath)
            
            let height: CGFloat = settings.scrollViewHeight
            
            let frame = CGRect(
                x: 0,
                y: yOffset,
                width:  columnWidth,
                height: height
            )
    
            yOffset += height + settings.minimumLineSpacing
            
            let insetFrame = frame.insetBy(dx: settings.cellPadding, dy: settings.cellPadding)
            attributes.frame = insetFrame
            
            attributes.zIndex = zIndex
            
            contentHeight = max(contentHeight,attributes.frame.maxY)
            cache[.cell]?[cellIndexPath] = attributes
            
            zIndex += 1
        }
        updateZIndexes()
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if oldBounds.size != newBounds.size {
            cache.removeAll(keepingCapacity: true)
        }
        return true
    }
    
    private func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.header] = [IndexPath: LibrariesCustomLayoutAttributes]()
        cache[.cell] = [IndexPath: LibrariesCustomLayoutAttributes]()
    }
    
    private func prepareElement(size: CGSize, type: Element, attributes: LibrariesCustomLayoutAttributes) {
        
        guard size != .zero else {
            return
        }
        if type == .header {
            attributes.initialOrigin = CGPoint(x: -settings.leftInset, y: contentHeight)
        } else {
            attributes.initialOrigin = CGPoint(x:0, y: contentHeight)
        }
        attributes.frame = CGRect(origin: attributes.initialOrigin, size: size)
        attributes.zIndex = zIndex
        zIndex += 1
        contentHeight = attributes.frame.maxY
        cache[type]?[attributes.indexPath] = attributes
    }
    
    private func updateZIndexes(){
        guard let headers = cache[.header] else {
            return
        }
        var sectionHeadersZIndex = zIndex
        for (_, attributes) in headers {
            attributes.zIndex = sectionHeadersZIndex
            sectionHeadersZIndex += 1
        }
    }
}

//MARK: - PROVIDING ATTRIBUTES TO THE COLLECTIONVIEW

extension LibrariesCustomLayout {
    public override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        switch elementKind {
        case Element.header.kind:
            return cache[.header]?[indexPath]
        default:
            return cache[.header]?[indexPath]
        }
    }
    
    override public func layoutAttributesForItem(
        at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[.cell]?[indexPath]
    }
    
    override public func layoutAttributesForElements(
        in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let collectionView = collectionView else {
            return nil
        }
        visibleLayoutAttributes.removeAll(keepingCapacity: true)
        
        for (type, elementInfos) in cache {
            for (indexPath, attributes) in elementInfos {
                
                //attributes.transform = .identity
                
                updateSupplementaryViews(
                    type,
                    attributes: attributes,
                    collectionView: collectionView,
                    indexPath: indexPath)
                
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        //print(contentOffset,oldBounds)
        return visibleLayoutAttributes
    }
    
    private func updateSupplementaryViews(_ type: Element,
                                          attributes: LibrariesCustomLayoutAttributes,
                                          collectionView: UICollectionView,
                                          indexPath: IndexPath) {
        
        if type == .header,
            settings.isHeaderSticky {
            //let upperLimit = contentHeight
            attributes.transform =  CGAffineTransform(
                translationX: 0,
                y: contentOffset.y /*min(upperLimit, max(0, contentOffset.y - attributes.initialOrigin.y))*/)
        }
    }
}
