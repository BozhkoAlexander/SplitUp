//
//  SplitBackContainerView.swift
//  Split Back
//
//  Created by Alex Bozhko on 06/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

class SplitUpContainerView: UIView {
    
    // MARK: Subviews
    
    weak var lineView: UIView! = nil
    
    private weak var contentView: UIView! = nil
    
    private func setupLineView() {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        
        addSubview(view)
        lineView = view
    }
    
    func setupContentView(_ view: UIView) {
        insertSubview(view, at: 0)
        contentView = view
    }
    
    // MARK: Life cycle

    init(for view: UIView) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        layer.cornerRadius = 10
        
        setupContentView(view)
        setupLineView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        lineView.frame.size = CGSize(width: 72, height: 4)
        lineView.center = CGPoint(x: bounds.midX, y: 9)
    }
    
}
