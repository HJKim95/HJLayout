//
//  HJLayoutTransformer.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/08/14.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit

public enum HJTransformerType {
    case crossFading
    case zoomOut
    case depth
    case linear
    case ferrisWheel
    case invertedFerrisWheel
    case cubic
    case noType
    
    func convertName() -> String {
        switch self {
        case .crossFading:
            return "crossFading"
        case .zoomOut:
            return "zoomOut"
        case .depth:
            return "depth"
        case .linear:
            return "linear"
        case .ferrisWheel:
            return "ferrisWheel"
        case .invertedFerrisWheel:
            return "invertedFerrisWheel"
        case .cubic:
            return "cubic"
        default:
            return "layout error"
        }
    }
    
    static var allTypes: [HJTransformerType] {
        return [.crossFading,.zoomOut,.depth,.linear,.ferrisWheel,.invertedFerrisWheel,.cubic]
    }
}

public class HJLayoutTransformer: NSObject {
    
    let minimumScale: CGFloat = 0.8
    let minimumAlpha: CGFloat = 0.5
    
    var alpha: CGFloat = 1
    var zIndex: Int = 0
    var transform = CGAffineTransform.identity
    var transform3D = CATransform3DIdentity
    
    var plusCenterX: CGFloat = 0
    
    func applyTransform(to attributes: UICollectionViewLayoutAttributes, position: CGFloat, type: HJTransformerType) {
        let width = attributes.bounds.width
        if abs(position) < 1 { // [-1,1]
            // 1 - abs(position) ==> 오른쪽으로 slide 경우: 현재 cell이 중앙에 남아있는 정도 = 오른쪽 cell이 중앙쪽으로 옮겨진 정도
            //                   ==> 왼쪽으로 slide 경우: 현재 cell이 중앙에 남아있는 정도 = 왼쪽 cell이 중앙쪽으로 옮겨진 정도
            //                   ==> 현재 cell 기준 [1 -> 0]으로 값 축소 되는것.
            // print(position, attributes.indexPath.item) 이것으로 확인 가능.
            
            switch type {
            case .crossFading:
                crossFading(position: position, width: width)
            case .zoomOut:
                zoomOut(position: position)
            case .depth:
                depth(position: position, width: width)
            case .linear:
                linear(position: position)
            case .ferrisWheel:
                ferrisWheel(position: position, width: width, reverse: false)
            case .invertedFerrisWheel:
                ferrisWheel(position: position, width: width, reverse: true)
            case .cubic:
                cubic(position: position, width: width)
            default:
                print(type, "is not available")
            }
    
        }
        attributes.center.x += plusCenterX
        attributes.transform = transform
        attributes.alpha = alpha
        attributes.zIndex = zIndex
        if type == .cubic {
            attributes.transform3D = transform3D
        }
    }
    
    
    fileprivate func crossFading(position: CGFloat, width: CGFloat) {
        transform.tx = -position * width
        alpha = 1 - abs(position)
    }
    
    fileprivate func zoomOut(position: CGFloat) {
        let scaleFactor = max(minimumScale, 1 - abs(position))
        transform.a = scaleFactor
        transform.d = scaleFactor
        alpha = max(minimumAlpha, 1 - abs(position))
    }
    
    fileprivate func depth(position: CGFloat, width: CGFloat) {
        if position < 0 { // [0 -> -1]
            // 왼쪽으로 밀리는 cell
            alpha = 1
            transform.tx = 0
            transform.a = 1
            transform.d = 1
            zIndex = 1
        }
        else if position > 0 { // [1 -> 0]
            // 오른쪽에서 올라오는 cell
            alpha = 1 - position
            transform.tx = width * -position // 처음에는 왼쪽 cell의 위치와 같다가 점점 자기 원래 위치로 돌아가게 됨 [-width -> 0]
            let scaleFactor = 1.0 - abs(position) + (minimumScale * abs(position))
            transform.a = scaleFactor // ax
            transform.d = scaleFactor // dy
            zIndex = 0
        }
    }
    
    fileprivate func linear(position: CGFloat) {
        let scale = max(1.0 - abs(position) + (minimumScale * abs(position)), minimumScale)
        transform = CGAffineTransform(scaleX: scale, y: scale)
        alpha = 1.0 - abs(position) + (abs(position) * minimumAlpha)
        zIndex = Int((1-abs(position)) * 10)
    }
    
    fileprivate func ferrisWheel(position: CGFloat, width: CGFloat, reverse: Bool) {
        switch position {
        case -5 ... 5:
            let itemSpacing = width
            let count: CGFloat = 14
            let circle: CGFloat = .pi * 2.0
            let radius = itemSpacing * count / circle
            let ty = radius * (!reverse ? 1 : -1)
            let theta = circle / count
            let rotation = position * theta * (!reverse ? 1 : -1)
            transform = transform.translatedBy(x: -position*itemSpacing, y: ty)
            transform = transform.rotated(by: rotation)
            transform = transform.translatedBy(x: 0, y: -ty)
            zIndex = Int((4.0-abs(position)*10))
        default:
            break
        }
        alpha = abs(position) < 0.5 ? 1 : self.minimumAlpha
    }
    
    fileprivate func cubic(position: CGFloat, width: CGFloat) {
        alpha = 1
        zIndex = Int((1-position) * CGFloat(10))
        let direction: CGFloat = position < 0 ? 1 : -1
        let theta = position * .pi * 0.5
        let radius = width
        
        transform3D.m34 = -0.002
        plusCenterX = direction*radius*0.5 // ForwardX
        transform3D = CATransform3DRotate(transform3D, theta, 0, 1, 0) // RotateY
        transform3D = CATransform3DTranslate(transform3D,-direction*radius*0.5, 0, 0) // Backward
    }
}


