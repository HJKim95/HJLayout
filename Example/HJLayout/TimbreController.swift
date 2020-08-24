//
//  TimbreController.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/08/07.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit
import HJLayout

class TimbreController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    lazy var TimbreCollectionView: UICollectionView = {
        let layout = TimbreLayout()
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        return cv
    }()
    
    var backImageViewConstraint: NSLayoutConstraint?
    var TimbreCollectionViewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(TimbreCollectionView)
        view.addSubview(backImageView)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30).first
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30).first
        }
        
        TimbreCollectionViewConstraint = TimbreCollectionView.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 7, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        TimbreCollectionView.register(TimbreCell.self, forCellWithReuseIdentifier: "cellid")
    }
    
    let imageArr = ["1","2","3","1","2","3","1","2","3"]
    
    
    let colors: [UIColor] = [.red,.black,.blue,.brown,.cyan,.darkGray,.systemPink,.green,.red,.yellow,.red,.black,.blue,.brown]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! TimbreCell
//        cell.backgroundColor = colors[indexPath.item]
        cell.imsiImageView.image = UIImage(named: imageArr[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cells = TimbreCollectionView.visibleCells as! [TimbreCell]
        let bounds = TimbreCollectionView.bounds
        for cell in cells {
            cell.updateParallaxOffset(collectionViewBounds: bounds)
        }
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

}


class TimbreCell: UICollectionViewCell {
    
    var imageViewCenterYConstraint: NSLayoutConstraint?
    
    var parallaxOffset: CGFloat = 0 {
        didSet {

        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let imsiImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imsiImageViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        addSubview(imsiImageView)
        
        imsiImageViewConstraint = imsiImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
    
    func updateParallaxOffset(collectionViewBounds bounds: CGRect) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let offsetFromCenter = CGPoint(x: center.x - self.center.x, y: center.y - self.center.y)
        let maxVerticalOffset = (bounds.height / 2) + (self.bounds.height / 2)
        let scaleFactor = 40 / maxVerticalOffset
        parallaxOffset = -offsetFromCenter.y * scaleFactor
    }
    
}

