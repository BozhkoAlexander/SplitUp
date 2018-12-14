//
//  SplitBackView.swift
//  Split Back
//
//  Created by Alex Bozhko on 06/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

class SplitBackView: UIView {
    
    // MARK: Properties
    
    var transitionController: SplitUpTransitionController? = nil
    
    weak var backgroundView: UIView? = nil
    
    weak var foregroundView: UIView? = nil
    
    private weak var containerView: UIView? = nil
    
    private func setupContainerView(for foregroundView: UIView) {
        let view = SplitUpContainerView(for: foregroundView)
        
        transitionController = SplitUpTransitionController(for: view)

        addSubview(view)
        containerView = view
    }
    
    // MARK: Life cycle
    
    init(background: UIViewController?, foreground: UIViewController?) {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        if let backgroundView = background?.view {
            addSubview(backgroundView)
            self.backgroundView = backgroundView
        }
        if let foregroundView = foreground?.view {
            setupContainerView(for: foregroundView)
            self.foregroundView = foregroundView
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let view = backgroundView {
            view.frame = bounds
        }
        if let view = containerView {
            view.frame.size = bounds.size
            view.frame.origin = CGPoint(x: 0, y: bounds.maxY - 120)
            if let fView = foregroundView {
                fView.frame.size = view.bounds.size
                fView.frame.origin = .zero
            }
        }
    }
    
}
