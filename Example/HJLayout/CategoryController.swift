//
//  ViewController.swift
//  HJLayout-CollectionView
//
//  Created by 김희중 on 2020/07/31.
//  Copyright © 2020 HJ. All rights reserved.
//

import UIKit

class CategoryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellid = "cellid"
    
    let bigCategories = ["Collectionview layouts", "Collectionview transforming layouts"]
    let layoutCategories = ["Pinterest", "Sticky Header", "Ultra visual", "Timbre"]
    let transformingCategories = ["Transforming"]
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "HJLayout"
        return label
    }()
    
    lazy var totalCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .collectionviewBackColor
        return cv
    }()
    
    var titleLabelConstraint: NSLayoutConstraint?
    var totalCategoryCollectionViewConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(titleLabel)
        view.addSubview(totalCategoryCollectionView)
        
        if #available(iOS 11.0, *) {
            titleLabelConstraint = titleLabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40).first
        }
        else {
            titleLabelConstraint = titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40).first
        }
        
        totalCategoryCollectionViewConstraint = totalCategoryCollectionView.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        totalCategoryCollectionView.register(bigCategoryCell.self, forCellWithReuseIdentifier: cellid)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! bigCategoryCell
        cell.categoryLabel.text = bigCategories[indexPath.item]
        if indexPath.item == 0 {
            cell.categories = layoutCategories
        }
        else if indexPath.item == 1 {
            cell.categories = transformingCategories
        }
        cell.delegate = self
        cell.tag = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bigCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var counts = 0
        if indexPath.item == 0 {
            counts = layoutCategories.count
        }
        else if indexPath.item == 1 {
            counts = transformingCategories.count
        }
        return CGSize(width: collectionView.frame.width, height: CGFloat(counts * 40) + 38)
    }
    
    var cellTag = 0 // section (big Category index)
    var cellIndex = 0 // inner index (inner Category Cell index)
    
    
    fileprivate func pushController(controller: String, tag: Int, index: Int) {
        var controll = UIViewController()
        cellTag = tag
        cellIndex = index
        switch controller {
        case "Pinterest":
            controll = PinterestController()
        case "Sticky Header":
            controll = StickyHeaderController()
        case "Ultra visual":
            controll = UltraVisualController()
        case "Timbre":
            controll = TimbreController()
        case "Transforming":
            controll = TransformingController()
        default:
            print("none of controller matched")
        }
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    // deselect cell in categoryCell
    override func viewWillAppear(_ animated: Bool) {
        let indexPath = IndexPath(item: cellTag, section: 0)
        let bigCell = totalCategoryCollectionView.cellForItem(at: indexPath) as? bigCategoryCell
        let innerIndexPath = IndexPath(item: cellIndex, section: 0)
        bigCell?.innerCategoryCollectionView.deselectItem(at: innerIndexPath, animated: false)
    }
    
}

class bigCategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellid = "cellid"
    
    var delegate: CategoryController?
    
    var categories = [String]()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .darkGray
        return label
    }()
    
    lazy var innerCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categoryLabelConstraint: NSLayoutConstraint?
    var innerCategoryCollectionViewConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .collectionviewBackColor
        addSubview(categoryLabel)
        addSubview(innerCategoryCollectionView)
        
        categoryLabelConstraint = categoryLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 10, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20).first
        innerCategoryCollectionViewConstraint = innerCategoryCollectionView.anchor(categoryLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        
        innerCategoryCollectionView.register(innerCategoryCell.self, forCellWithReuseIdentifier: cellid)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! innerCategoryCell
        cell.categoryLabel.text = categories[indexPath.item]
        if indexPath.item == categories.count - 1 {
            cell.dividerLine.alpha = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controllerName = categories[indexPath.item]
        delegate?.pushController(controller: controllerName, tag: self.tag, index: indexPath.item)
    }
    
}


class innerCategoryCell: UICollectionViewCell {
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var categoryLabelConstraint: NSLayoutConstraint?
    var dividerLineConstraint: NSLayoutConstraint?
    
    fileprivate func setupLayouts() {
        backgroundColor = .white
        addSubview(categoryLabel)
        addSubview(dividerLine)
        
        categoryLabelConstraint = categoryLabel.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0).first
        dividerLineConstraint = dividerLine.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0.5, rightConstant: 10, widthConstant: 0, heightConstant: 0.5).first
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? UIColor.rgb(red: 209, green: 209, blue: 214) : .white
            categoryLabel.backgroundColor = isHighlighted ? UIColor.rgb(red: 209, green: 209, blue: 214) : .white
        }
    }

    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? UIColor.rgb(red: 209, green: 209, blue: 214) : .white
            categoryLabel.backgroundColor = isSelected ? UIColor.rgb(red: 209, green: 209, blue: 214) : .white
        }
    }
}




