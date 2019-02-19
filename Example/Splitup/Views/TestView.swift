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
    
    weak var detailsButton: UIButton! = nil
    
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
    
    private func setupDetailsButton(target: Any?, action: Selector) {
        let button = UIButton(type: .custom)
        button.setTitleColor(.blue, for: .normal)
        button.setTitle("Details", for: .normal)
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
        addSubview(button)
        detailsButton = button
    }
    
    // MARK: Life cycle
    
    init(for vc: TestViewController) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        backgroundColor = UIColor.groupTableViewBackground
        
        setupTestButton(target: vc, action: #selector(vc.testPressed(_:)))
        setupRollView()
        setupDetailsButton(target: vc, action: #selector(vc.detailsPressed(_:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        testButton.frame.size.width = testButton.title(for: .normal)!.boundingSize(with: .zero, font: testButton.titleLabel!.font).width + 36
        testButton.frame.size.height = 44
        detailsButton.frame.size.width = detailsButton.title(for: .normal)!.boundingSize(with: .zero, font: detailsButton.titleLabel!.font).width + 36
        detailsButton.frame.size.height = 44
        
        testButton.center = CGPoint(x: bounds.midX, y: bounds.midY)
        detailsButton.center.x = bounds.midX
        detailsButton.frame.origin.y = testButton.frame.maxY + 18
        
        rollView.frame.origin.y = 64
        rollView.center.x = bounds.midX
    }
    
}
