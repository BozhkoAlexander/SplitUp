//
//  RollIndicatorView.swift
//  Split Back
//
//  Created by Alex Bozhko on 10/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

public class RollIndicatorView: UIView {
    
    public enum RollType {
        
        case line
        
        case arrow
        
    }
    
    // MARK: Public properties
    
    public class func heightForType(_ rollType: RollType) -> CGFloat {
        switch rollType {
        case .line: return 18
        case .arrow: return 36
            
        }
    }
    
    public var rollType: RollType
    
    public var progress: CGFloat = 0 {
        didSet {
            guard oldValue != progress else { return }
            setNeedsDisplay()
        }
    }
    
    // MARK: Life cycle
    
    public init(rollType: RollType) {
        self.rollType = rollType
        super.init(frame: .zero)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Draw
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let pr = rollType == .arrow ? progress : 1
        let w: CGFloat = 48
        let h: CGFloat = 4
        
        let x1 = round(0.5 * (rect.width - w))
        let x2 = x1 + round(0.5 * w)
        let x3 = x1 + w
        let y1 = round(rect.height * 1/3)
        let y2 = round(rect.height * 0.5)
        let y3 = round(rect.height * 2/3)
        
        var p1 = CGPoint(x: x1, y: y3)
        var p2 = CGPoint(x: x2, y: y1)
        var p3 = CGPoint(x: x3, y: y3)
        
        p1.y -= round((y3 - y2) * pr)
        p2.y += round((y2 - y1) * pr)
        p3.y -= round((y3 - y2) * pr)
        
        let figure = UIBezierPath()
        figure.lineWidth = h
        figure.lineCapStyle = .round
        figure.move(to: p1)
        figure.addLine(to: p2)
        figure.addLine(to: p3)
        
        tintColor?.setStroke()
        figure.stroke()
    }
    
    public func setProgressAnimated(_ progress: CGFloat) {
        let anim = CABasicAnimation(keyPath: "progress")
        anim.fromValue = self.progress
        anim.toValue = progress
        anim.duration = 0.25
        layer.add(anim, forKey: "progress")
    }

}
