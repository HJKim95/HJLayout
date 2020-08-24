//
//  CrossFadingController.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/08/10.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit
import HJLayout

class TransformingController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    lazy var transformCollectionView: UICollectionView = {
        let layout = TransformingLayout()
        layout.transformer_type = .crossFading
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        // for smooth snapping (custom layout에서 targetContentOffset 쓰려면 필수인듯.)
        cv.decelerationRate = .fast
        return cv
    }()
    
    lazy var selectLayoutCollectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    var backImageViewConstraint: NSLayoutConstraint?
    var transformCollectionViewConstraint: NSLayoutConstraint?
    var selectLayoutCollectionviewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(transformCollectionView)
        view.addSubview(selectLayoutCollectionview)
        view.addSubview(backImageView)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30).first
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30).first
        }
        
        transformCollectionViewConstraint = transformCollectionView.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 7, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 300).first
        selectLayoutCollectionviewConstraint = selectLayoutCollectionview.anchor(transformCollectionView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        transformCollectionView.register(transformingCell.self, forCellWithReuseIdentifier: "cellid")
        selectLayoutCollectionview.register(selectLayoutCell.self, forCellWithReuseIdentifier: "layout")
        
        selectLayoutCollectionview.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
    }

    
    let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
    let images = ["1", "2", "3"]
    let transforms = HJTransformerType.allTypes
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == transformCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! transformingCell
    //        cell.backgroundColor = colors[indexPath.item]
            cell.imsiImage.image = UIImage(named: images[indexPath.item])
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "layout", for: indexPath) as! selectLayoutCell
            cell.imsiLabel.text = transforms[indexPath.item].convertName()
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == transformCollectionView {
            return images.count
        }
        else {
            return transforms.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == transformCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else {
            return CGSize(width: collectionView.frame.width, height: 45)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectLayoutCollectionview {
            let selectedtransforms = transforms[indexPath.item]
            let layout = TransformingLayout()
            layout.transformer_type = selectedtransforms
            transformCollectionView.collectionViewLayout = layout
        }
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

}

class transformingCell: UICollectionViewCell {
    let imsiImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
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
        addSubview(imsiImage)
        imsiImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
}

class selectLayoutCell: UICollectionViewCell {
    let imsiLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    let checkImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "check")
        iv.alpha = 0
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
        addSubview(imsiLabel)
        addSubview(dividerLine)
        addSubview(checkImage)
        
        imsiLabel.frame = CGRect(x: 12, y: 0, width: frame.width - 12, height: frame.height - 10)
        dividerLine.frame = CGRect(x: 20, y: frame.height - 1, width: frame.width - 40, height: 0.5)
        checkImage.frame = CGRect(x: frame.width - 42, y: 0, width: 30, height: 30)
    }
    
    override var isHighlighted: Bool {
        didSet {
            checkImage.alpha = isHighlighted ? 1 : 0
        }
    }
    
    override var isSelected: Bool {
        didSet {
            checkImage.alpha = isSelected ? 1 : 0
        }
    }
}
