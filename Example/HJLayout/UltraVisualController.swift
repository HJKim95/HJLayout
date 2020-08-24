//
//  UltraVisualController.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/08/05.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit
import HJLayout

class UltraVisualController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var backImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "back")
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        return iv
    }()
    
    lazy var UltraVisualCollectionView: UICollectionView = {
        let layout = UltraVisualLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        // for smooth snapping
        cv.decelerationRate = .fast
        return cv
    }()
    
    var backImageViewConstraint: NSLayoutConstraint?
    var UltraVisualCollectionViewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(UltraVisualCollectionView)
        view.addSubview(backImageView)
        
        if #available(iOS 11.0, *) {
            backImageViewConstraint = backImageView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30).first
        }
        else {
            backImageViewConstraint = backImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30).first
        }
        
        UltraVisualCollectionViewConstraint = UltraVisualCollectionView.anchor(backImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 7, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        UltraVisualCollectionView.register(UltraVisualCell.self, forCellWithReuseIdentifier: "cellid")
    }
    
    let colors: [UIColor] = [.red,.black,.blue,.brown,.cyan,.darkGray,.systemPink,.green,.red,.yellow,.red,.black,.blue,.brown,.cyan,.darkGray,.systemPink,.green,.red,.yellow]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! UltraVisualCell
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
    @objc fileprivate func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

}


class UltraVisualCell: UICollectionViewCell {
    
    let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var coverViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        addSubview(coverView)
        
        coverViewConstraint = coverView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let featuredHeight = UltravisualLayoutConstants.Cell.featuredHeight
        let standardHeight = UltravisualLayoutConstants.Cell.standardHeight
        
        // featured --> delta: 1 --> minAlpha
        // standard --> delta: 0 --> maxAlpha
        let delta = 1 - ((featuredHeight - frame.height) / (featuredHeight - standardHeight))

        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.75
        // alpha가 1에 가까울수록 어두운것..
        coverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
    }
}
