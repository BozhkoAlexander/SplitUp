//
//  TestView.swift
//  Splitup_Example
//
//  Created by Alex Bozhko on 12/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Splitup

class TestView: UIView {
    
    // MARK: Subviews

    weak var testButton: UIButton! = nil
    
    weak var rollView: RollIndicatorView! = nil
    
    private func setupTestButton(target: Any?, action: Selector) {
        let button = UIButton(type: .custom)
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Test", for: .normal)
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        addSubview(button)
        testButton = button
    }
    
    private func setupRollView() {
        let view = RollIndicatorView()
        view.tintColor = .gray
        
        addSubview(view)
        rollView = view
    }
    
    // MARK: Life cycle
    
    init(for vc: TestViewController) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        backgroundColor = UIColor.groupTableViewBackground
        
        setupTestButton(target: vc, action: #selector(vc.testPressed(_:)))
        setupRollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        testButton.frame.size.width = testButton.title(for: .normal)!.boundingSize(with: .zero, font: testButton.titleLabel!.font).width + 36
        testButton.frame.size.height = 44
        
        testButton.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        rollView.frame.origin.y = 64
        rollView.center.x = bounds.midX
    }
    
}
