//
//  PinterestController.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/08/05.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit
import HJLayout

class PinterestController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate {
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    lazy var pintCollectionView: UICollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        layout.numberOfColumns = 2
        layout.cellPadding = 10
        layout.headerReferenceSizeHeight = 180
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    var backImageViewConstraint: NSLayoutConstraint?
    var pintCollectionViewConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(pintCollectionView)
        view.addSubview(backImageView)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30).first
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30).first
        }
        
        pintCollectionViewConstraint = pintCollectionView.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 7, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
  
        pintCollectionView.register(pintCell.self, forCellWithReuseIdentifier: "cellid")
        pintCollectionView.register(pintHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerid")
    }
    
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat {
        let random = arc4random_uniform(4) + 1
        return CGFloat((random * 100))
    }

    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat {
        return 60
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    let colors: [UIColor] = [.red,.black,.blue,.brown,.cyan,.darkGray,.systemPink,.green,.red,.yellow,.red,.black,.blue,.brown,.cyan,.darkGray,.systemPink,.green,.red,.yellow]

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! pintCell
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerid", for: indexPath) as! pintHeaderCell
        return cell
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

class pintCell: UICollectionViewCell {
    
    let pintImage: UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    let pintAnnotation: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayouts() {
        addSubview(pintImage)
        addSubview(pintAnnotation)
        
    }
    
    var pintImageConstraint: NSLayoutConstraint?
    var pintAnnotationConstraint: NSLayoutConstraint?
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        pintImageConstraint = pintImage.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        pintAnnotationConstraint = pintAnnotation.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60).first
    }
}

class pintHeaderCell: UICollectionViewCell {
    
    let pintHeaderImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .cyan
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayouts() {
        backgroundColor = .lightGray
        addSubview(pintHeaderImage)
        
    }
    
    var pintHeaderImageConstraint: NSLayoutConstraint?
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
//        let attributes = layoutAttributes as! PinterestLayoutAttributes
//        let imageHeight = attributes.imageHeight
//        attributes.headerDeltaY
        pintHeaderImageConstraint = pintHeaderImage.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
}

