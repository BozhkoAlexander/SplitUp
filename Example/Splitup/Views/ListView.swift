//
//  ListView.swift
//  Split Back
//
//  Created by Alex Bozhko on 10/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

class ListView: UIView {
    
    // MARK: Subviews
    
    weak var collectionView: UICollectionView! = nil
    
    private func setupCollectionView(for vc: ListViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 18
        
        let view = UICollectionView(frame: bounds, collectionViewLayout: layout)
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellId)
        view.register(ListCell.self, forCellWithReuseIdentifier: ListCell.cellId)
        
        view.delegate = vc
        view.dataSource = vc
        
        addSubview(view)
        collectionView = view
    }
    
    // MARK: Life cycle
    
    init(for vc: ListViewController) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.groupTableViewBackground
        
        setupCollectionView(for: vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 11.0, *) {
            collectionView.frame = bounds.inset(by: safeAreaInsets)
        } else {
            collectionView.frame = bounds
        }
        if let insets = splitUp?.insets {
            collectionView.frame = collectionView.frame.inset(by: insets)
        }
    }
    
}
