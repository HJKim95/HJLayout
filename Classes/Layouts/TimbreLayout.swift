//
//  TimbreLayout.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/08/07.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit

func degreesToRadians(degrees: Double) -> CGFloat {
    return CGFloat(.pi * (degrees) / 180.0)
}

public class TimbreLayout: UICollectionViewFlowLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)! as [UICollectionViewLayoutAttributes]
        for attributes in layoutAttributes {
            attributes.frame = attributes.frame.insetBy(dx: 12, dy: 0)
            attributes.transform = CGAffineTransform.init(rotationAngle: degreesToRadians(degrees: -14))
        }
        return layoutAttributes
    }
}
