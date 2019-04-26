//
//  ListItemCell.swift
//  Splitup_Example
//
//  Created by Alexander Bozhko on 26/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ListItemCell: UICollectionViewCell {
    
    // MARK: Helpers
    
    static let cellId = "ListItemCell"
    
    class func cellSize(for item: String, collectionView: UICollectionView) -> CGSize {
        let width = ceil((item as NSString).boundingRect(with: .zero, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).width)
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    private static let font = UIFont.boldSystemFont(ofSize: 24)
    
    // MARK: Subviews
    
    weak var textLabel: UILabel! = nil
    
    private func setupTextLabel() {
        let label = UILabel()
        label.font = ListItemCell.font
        label.textAlignment = .center
        label.textColor = .black
        
        contentView.addSubview(label)
        textLabel = label
    }
    
    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextLabel()
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    private func setupLayout() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
