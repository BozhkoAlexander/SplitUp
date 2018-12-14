//
//  CollectionViewCell.swift
//  Split Back
//
//  Created by Alex Bozhko on 06/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let cellId = "CollectionViewCell"
    
    class func cellSize(for collectionView: UICollectionView) -> CGSize {
        let w = collectionView.bounds.width - 36
        let textHeight = "TEXT".boundingSize(with: .zero, font: textFont).height
        let detailsHeight = "Text0\nText1\nText2\nText3".boundingSize(with: .zero, font: detailsFont).height
        let h = 18 + textHeight + detailsHeight + 18
        return CGSize(width: w, height: h)
    }
    
    private static let textFont = UIFont.systemFont(ofSize: 24, weight: .medium)
    
    private static let detailsFont = UIFont.systemFont(ofSize: 17)
    
    // MARK: Subviews
    
    weak var textLabel: UILabel! = nil
    
    weak var detailsLabel: UILabel! = nil
    
    private func setupTextLabel() {
        let label = UILabel()
        label.textColor = .black
        label.font = CollectionViewCell.textFont
        label.numberOfLines = 1
        
        contentView.addSubview(label)
        textLabel = label
    }
    
    private func setupDetailsLabel() {
        let label = UILabel()
        label.textColor = .gray
        label.font = CollectionViewCell.detailsFont
        label.numberOfLines = 4
        
        contentView.addSubview(label)
        detailsLabel = label
    }
    
    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextLabel()
        setupDetailsLabel()
        
        textLabel.text = "Movie title"
        detailsLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentWidth = contentView.bounds.width - 36
        textLabel.frame.origin = CGPoint(x: 18, y: 18)
        if let text = textLabel.text {
            textLabel.frame.size.width = contentWidth
            textLabel.frame.size.height = text.boundingSize(with: .zero, font: textLabel.font).height
        } else {
            textLabel.frame.size = .zero
        }
        detailsLabel.frame = CGRect(x: 18, y: textLabel.frame.maxY, width: contentWidth, height: contentView.bounds.height - 18 - textLabel.frame.maxY)
    }
    
}
