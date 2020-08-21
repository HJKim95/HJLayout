//
//  StickyHeaderLayout.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/08/05.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit

public class StickyHeaderLayout: UICollectionViewFlowLayout {
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)! as [UICollectionViewLayoutAttributes]
        
        // collectionview에 보여지는 모든 cell들의 indexpath를 item갯수만큼 section만 가져온다
        let headerNeedingLayout = NSMutableIndexSet()
        for attributes in layoutAttributes {
            if attributes.representedElementCategory == .cell {
                headerNeedingLayout.add(attributes.indexPath.section)
            }
        }
        for attributes in layoutAttributes {
            if let elementKind = attributes.representedElementKind {
                if elementKind == UICollectionView.elementKindSectionHeader {
                    headerNeedingLayout.remove(attributes.indexPath.section)
                }
            }
        }
        // 현재 보이는 화면(rect)에  header가 없어도 해당 header를 가져올수있게 함.
        headerNeedingLayout.enumerate { (index, stop) in
            let indexPath = NSIndexPath(item: 0, section: index)
            let attributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath as IndexPath)
            layoutAttributes.append(attributes!)
        }
        
        for attributes in layoutAttributes {
            if let elementKind = attributes.representedElementKind {
                // header의 경우
                if elementKind == UICollectionView.elementKindSectionHeader {
                    let section = attributes.indexPath.section
                    // 해당 section에서 첫번째 item위치로 가져오기.
                    let attributesForFirstItemInSection = layoutAttributesForItem(at: NSIndexPath(item: 0, section: section) as IndexPath)
                    // 해당 section에서 마지막 item위치까지 가져오기.
                    let attributesForLastItemInSection = layoutAttributesForItem(at: NSIndexPath(item: collectionView!.numberOfItems(inSection: section) - 1, section: section) as IndexPath)
                    var frame = attributes.frame // header의 frame(즉 header 크기) *headerReferenceSize
                    let offset = collectionView!.contentOffset.y
                    let minY = (attributesForFirstItemInSection?.frame.minY)! - frame.height
                    let maxY = (attributesForLastItemInSection?.frame.maxY)! - frame.height
                    let y = min(max(offset, minY), maxY) // minY(제일 첫번쨰 위) -> offset(중간 구간) -> maxY(마지막 item까지) 순으로 이동하게됨.
                    frame.origin.y = y
                    attributes.frame = frame
                    attributes.zIndex = 99 // 제일 앞으로 올 수 있게
                }
            }
        }
        return layoutAttributes
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
