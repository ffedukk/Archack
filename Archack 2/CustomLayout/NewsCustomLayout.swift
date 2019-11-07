//
//  NewsCustomLayout.swift
//  Archack 2
//
//  Created by Fedor on 05/11/2019.
//  Copyright © 2019 Fedor Semenov. All rights reserved.
//

import UIKit

protocol NewsCustomLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class NewsCustomLayout: UICollectionViewLayout {
    
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
        return NewsCustomLayoutAttributes.self
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: contentHeight)
    }
    
    weak var delegate : NewsCustomLayoutDelegate?
    var settings = NewsCustomLayoutSettings()
    
    private var oldBounds = CGRect.zero
    private var contentHeight = CGFloat()
    private var cache = [Element: [IndexPath: NewsCustomLayoutAttributes]]()
    private var visibleLayoutAttributes = [NewsCustomLayoutAttributes]()
    private var zIndex = 0
    
    private var collectionViewHeight: CGFloat {
        return collectionView!.frame.height
    }
    
    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width
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
    
    private let cellPadding: CGFloat = 6
    private let numberOfColumns = 2
    private var columnWidth: CGFloat {
        return collectionViewWidth / CGFloat(2)
    }
}

//MARK: - Layout Core Prosses

extension NewsCustomLayout {
    override func prepare() {
        guard let collectionView = collectionView,
            cache.isEmpty else {
                return
        }
        prepareCache()
        contentHeight = 0
        oldBounds = collectionView.bounds
        zIndex = 0
        
        let headerAttributes = NewsCustomLayoutAttributes(
            forSupplementaryViewOfKind: Element.header.kind,
            with: IndexPath(item: 0, section: 0)
        )
        
        prepareElement(size: headerSize, type: .header, attributes: headerAttributes)
        
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: headerSize.height, count: numberOfColumns)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let cellIndexPath = IndexPath(item: item, section: 0)
            let attributes = NewsCustomLayoutAttributes(forCellWith: cellIndexPath)
            let lineInterSpace = settings.minimumLineSpacing
            
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: cellIndexPath) ?? 180
            
            let frame = CGRect(
                x: xOffset[column] + settings.minimumInteritemSpacing,
                y: yOffset[column] + lineInterSpace,
                width:  columnWidth,
                height: photoHeight
            )
            
            yOffset[column] += photoHeight
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            attributes.frame = insetFrame
            
            attributes.zIndex = zIndex
            
            contentHeight = max(contentHeight,attributes.frame.maxY)
            cache[.cell]?[cellIndexPath] = attributes
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
            
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
        cache[.header] = [IndexPath: NewsCustomLayoutAttributes]()
        cache[.cell] = [IndexPath: NewsCustomLayoutAttributes]()
    }
    
    private func prepareElement(size: CGSize, type: Element, attributes: NewsCustomLayoutAttributes) {

        guard size != .zero else {
            return
        }
        attributes.initialOrigin = CGPoint(x:0, y: contentHeight)
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

extension NewsCustomLayout {
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
                
                attributes.transform = .identity
                
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
        return visibleLayoutAttributes
    }
    
    private func updateSupplementaryViews(_ type: Element,
                                          attributes: NewsCustomLayoutAttributes,
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















