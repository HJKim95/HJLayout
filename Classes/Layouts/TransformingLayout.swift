//
//  CrossFadingLayout.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/08/10.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit

public class TransformingLayout: UICollectionViewLayout {

    var cache = [UICollectionViewLayoutAttributes]()
    
    public var transformer_type = HJTransformerType.crossFading // default: crossFading
    
    var itemSize: CGSize = CGSize.zero
    
    var width: CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    var height: CGFloat {
        get {
            return collectionView!.bounds.height
        }
    }
    
    var numberOfItems: Int {
        get {
            return collectionView!.numberOfItems(inSection: 0)
        }
    }
    
    public override var collectionViewContentSize: CGSize {
        let contentWidth = (CGFloat(numberOfItems) * width)
        return CGSize(width: contentWidth, height: height)
    }
    
    public override func prepare() {
        cache.removeAll(keepingCapacity: true)
        var frame = CGRect.zero
        var x:CGFloat = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            x = width * CGFloat(indexPath.item)
            frame = CGRect(x: x, y: 0, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
        }
        
    }
    

    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if rect.intersects(attributes.frame) {
                let centerX = width / 2
                let offset = collectionView!.contentOffset.x
                let item_centerX = attributes.center.x - offset
                let position = (item_centerX - centerX) / width
                let transformer = HJLayoutTransformer()
                transformer.applyTransform(to: attributes, position: position, type: transformer_type)
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
//
    // snapping
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // transform을 통해 tx가 바뀌어도 contentOffset은 변하지 않는다!
        // tx를 변화시켜 해당 attribute을 옆으로 옮겨주는 것이므로..
        let itemIndex = round(proposedContentOffset.x / width)
        let xOffset = itemIndex * width
        return CGPoint(x: xOffset, y: 0)
    }
}
