//
//  ListCell.swift
//  Splitup_Example
//
//  Created by Alexander Bozhko on 26/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Helpers
    
    static let cellId = "ListCell"
    
    class func cellSize(for collectionView: UICollectionView) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }
    
    // MARK: Subviews
    
    weak var collectionView: UICollectionView! = nil
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .groupTableViewBackground
        
        view.register(ListItemCell.self, forCellWithReuseIdentifier: ListItemCell.cellId)
        
        view.delegate = self
        view.dataSource = self
        
        contentView.addSubview(view)
        collectionView = view
    }
    
    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: Collection view delegate & data source
    
    private var items = ["Today", "Tomorrow", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday"]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ListItemCell.cellSize(for: items[indexPath.item], collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ListItemCell.cellId, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ListItemCell else { return }
        cell.textLabel.text = items[indexPath.item]
    }
    
}
