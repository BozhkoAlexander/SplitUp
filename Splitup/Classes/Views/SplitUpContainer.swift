//
//  SplitUpContainer.swift
//  Split Back
//
//  Created by Alex Bozhko on 07/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

public class SplitUpContainer: UIView {
    
    public enum Position: UInt {
        
        case rear = 0
        
        case front = 1
        
    }
    
    public struct Config {
        
        public let position: Position
        
        public var animateRollIndicator: Bool
                
        public var closeButtonImage: UIImage?
        
        public init(position: Position, animateRollIndicator: Bool = false, closeButtonImage: UIImage?) {
            self.position = position
            self.animateRollIndicator = animateRollIndicator
            self.closeButtonImage = closeButtonImage
        }
        
    }
    
    // MARK: Public properties
    
    public var config: Config
    
    public weak var view: UIView! = nil
    
    public var insets: UIEdgeInsets = .zero
    
    public weak var shadeView: UIView? = nil
    
    public weak var scrollView: UIScrollView? = nil
    
    public weak var rollIndicator: RollIndicatorView? = nil
    
    public weak var closeButton: UIButton? = nil
    
    // MARK: Private properties
    
    private weak var contentView: UIView! = nil
    
    // MARK: Life cycle
    
    public init(with view: UIView, config: Config) {
        self.config = config
        super.init(frame: .zero)
        
        setupContentView()
        
        contentView.addSubview(view)
        self.view = view
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Setup
    
    private func setupContentView() {
        let view = UIView()
        view.clipsToBounds = true
        if config.position == .front {
            view.layer.cornerRadius = 10
            if #available(iOS 11.0, *) {
                view.layer.maskedCorners = [
                    .layerMinXMinYCorner,
                    .layerMaxXMinYCorner
                ]
            }
            setupShadow()
        }
        
        addSubview(view)
        contentView = view
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
    }
    
    private func setupShadeView() {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        
        contentView.insertSubview(view, aboveSubview: self.view)
        shadeView = view
    }
    
    private func setupRollIndicator() {
        let view = RollIndicatorView()
        view.tintColor = UIColor.lightGray
        
        if config.animateRollIndicator {
            view.setState(.arrow, animated: false)
        }
        
        addSubview(view)
        rollIndicator = view
    }
    
    private func setupCloseButton() {
        guard let image = config.closeButtonImage else { return }
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        
        contentView.addSubview(button)
        closeButton = button
    }
    
    private func setup() {
        switch config.position {
        case .rear:
            setupShadeView()
        case .front:
            setupRollIndicator()
            setupCloseButton()
        }
    }
    
    // MARK: Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        rollIndicator?.center.x = bounds.midX
        rollIndicator?.frame.origin.y = 0
        
        if config.position == .front {
            if config.animateRollIndicator, let roll = rollIndicator {
                contentView.frame = CGRect(x: 0, y: roll.frame.maxY, width: bounds.width, height: bounds.height - roll.frame.maxY)
            } else {
                contentView.frame = bounds
            }

            layer.shadowPath = UIBezierPath(roundedRect: contentView.frame, cornerRadius: contentView.layer.cornerRadius).cgPath
            
            closeButton?.frame.size = CGSize(width: 64, height: 64)
            closeButton?.frame.origin = CGPoint(x: bounds.width - 64, y: 0)
        } else {
            contentView.frame = bounds
            shadeView?.frame = view.frame
        }
        
        view.frame = contentView.bounds
    }
    
}
