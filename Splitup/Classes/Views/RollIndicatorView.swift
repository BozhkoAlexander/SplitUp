//
//  RollIndicatorView.swift
//  Split Back
//
//  Created by Alex Bozhko on 10/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

open class RollIndicatorView: UIView {
    
    public enum State {
        
        case arrow
        
        case line
        
    }
    
    open override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    // MARK: Public properties
    
    public static let size = CGSize(width: 48, height: 24)
    
    public var state: State = .line
    
    open override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = CGRect(origin: newValue.origin, size: RollIndicatorView.size)
        }
    }
    
    open override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            super.tintColor = newValue
            shapeLayer.strokeColor = newValue.cgColor
        }
    }
    
    // MARK: Pirvate properties
    
    private var shapeLayer: CAShapeLayer! {
        return layer as? CAShapeLayer
    }
    
    private func setupShapeLayer() {
        shapeLayer.strokeColor = tintColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineCap = .round
        
        shapeLayer.path = currentPath.cgPath
    }
    
    // MARK: Life cycle
    
    public init() {
        super.init(frame: CGRect(origin: .zero, size: RollIndicatorView.size))
        
        backgroundColor = .clear
        setupShapeLayer()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Paths
    
    private var currentPath: UIBezierPath {
        return path(for: state)
    }
    
    private func path(for state: State) -> UIBezierPath {
        switch state {
        case .line: return linePath(for: bounds)
        case .arrow: return arrowPath(for: bounds)
        }
    }
    
    private func linePath(for rect: CGRect) -> UIBezierPath {
        let lineWidth = shapeLayer.lineWidth
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: lineWidth, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width - lineWidth, y: rect.midY))
        
        return path
    }
    
    private func arrowPath(for rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let res = calculate(for: rect)
        
        path.move(to: CGPoint(x: rect.midX - res.a, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY - res.dY))
        path.addLine(to: CGPoint(x: rect.midX + res.a, y: rect.midY))
        
        return path
    }
    
    // MARK: Calculation
    
    private typealias Calculation = (a: CGFloat, dY: CGFloat)
    
    private func calculate(for rect: CGRect) -> Calculation {
        let c = rect.midX - shapeLayer.lineWidth
        let angle = CGFloat.pi / 6
        let a = c * cos(angle)
        let b = c * sin(angle)
        
        return (a: a, dY: b)
    }
    
    // MARK: Public methods
    
    open func setState(_ state: State, animated: Bool) {
        guard state != self.state else { return }
        let startPath = currentPath
        let endPath = path(for: state)
        
        if animated {
            let anim = CABasicAnimation(keyPath: "path")
            anim.fromValue = startPath.cgPath
            anim.toValue = endPath.cgPath
            anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
            anim.duration = 0.25
            anim.fillMode = .forwards
            anim.isRemovedOnCompletion = false
            
            shapeLayer.add(anim, forKey: nil)
            self.state = state
        } else {
            self.state = state
            shapeLayer.path = endPath.cgPath
        }

    }

}
