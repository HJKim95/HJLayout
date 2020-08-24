//
//  PinterestLayout.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/07/31.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit

public protocol PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat
}

public class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    
    public var imageHeight: CGFloat = 0
    var headerDeltaY: CGFloat = 0
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.imageHeight = imageHeight
        copy.headerDeltaY = headerDeltaY
        return copy
    }

    public override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.imageHeight == imageHeight && attributes.headerDeltaY == headerDeltaY {
                return super.isEqual(object)
            }
        }
        return false
    }
}

public class PinterestLayout: UICollectionViewLayout {
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public var cellPadding: CGFloat = 0
    public var headerReferenceSizeHeight: CGFloat = 0
    public var delegate: PinterestLayoutDelegate!
    public var numberOfColumns = 1
    
    private var cache = [PinterestLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    private var width: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return collectionView!.bounds.width - (insets.left + insets.right)
        }
    }
    
    public override class var layoutAttributesClass: AnyClass {
        return PinterestLayoutAttributes.self
    }
    
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    public override func prepare() {
        if cache.isEmpty {
            let columnWidth = width / CGFloat(numberOfColumns)
            var xOffsets = [CGFloat]()
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * columnWidth)
            }
            var yOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
            
            var column = 0
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = NSIndexPath(item: item, section: 0)
//                let height = delegate.collectionView(collectionView: collectionView!, heightForItemAtIndexPath: indexPath)
                let width = columnWidth - (cellPadding * 2)
                let imageHeight = delegate.collectionView(collectionView: collectionView!, heightForImageAtIndexPath: indexPath, withWidth: width)
                let annotationHeight = delegate.collectionView(collectionView: collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding + imageHeight + annotationHeight + cellPadding
                // headerSize를 더해주어야 header 와 밑에 cell들이 겹치지 않는다.
                
                let attributes = PinterestLayoutAttributes(forCellWith: indexPath as IndexPath)
                let frame = CGRect(x: xOffsets[column], y: yOffsets[column] + headerReferenceSizeHeight, width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                attributes.frame = insetFrame
                attributes.imageHeight = imageHeight
                cache.append(attributes)
                // stretchy header
                let headerAttributes = PinterestLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath as IndexPath)
                headerAttributes.frame = CGRect(x: 0, y: 0, width: self.collectionView!.bounds.size.width, height: headerReferenceSizeHeight)
                cache.append(headerAttributes)
                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[column] = yOffsets[column] + height
                if column >= numberOfColumns - 1 {
                    // 위에(가로)를 먼저 채우고 밑으로
                    column = 0
                }
                else {
                    column += 1
                }
            }
        }
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if rect.intersects(attributes.frame) {
                layoutAttributes.append(attributes)
            }
            
            // stretchy header
            let offset = collectionView!.contentOffset
//            if #available(iOS 13.0, *) {
//                let statusBarHeight = collectionView!.window?.windowScene?.statusBarManager?.statusBarFrame.height
//            } else {
//                collectionView!.window?.
//                // Fallback on earlier versions
//            }
//            let minY: CGFloat = -(statusBarHeight ?? 44.0)
//            print(minY, offset.y)
            let deltaY = offset.y
            if offset.y < 0 && headerReferenceSizeHeight > 0 {
                if let elementKind = attributes.representedElementKind {
                    if elementKind == UICollectionView.elementKindSectionHeader {
                        var frame = attributes.frame
                        frame.size.height = max(0, headerReferenceSizeHeight - deltaY)
                        // origin.y 와 offset 개념이 다르기 때문에 origin.y에는 delta만 더해준다
                        frame.origin.y = CGFloat(deltaY)
                        attributes.frame = frame
                        attributes.headerDeltaY = CGFloat(deltaY)
                        layoutAttributes.append(attributes)
                    }
                }
            }
            
        }
        return layoutAttributes
    }
    
}
