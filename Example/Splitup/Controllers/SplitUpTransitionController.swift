//
//  SplitUpTransitionController.swift
//  Split Back
//
//  Created by Alex Bozhko on 06/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

protocol SplitUpTransitionDelegate {
    
    func splitTransitionDidFinished(_ controller: SplitUpTransitionController)
    
}

class SplitUpTransitionController: NSObject {
    
    var delegate: SplitUpTransitionDelegate? = nil
    
    var isForegroundOpened: Bool  = false
    
    // MARK: Properties
    
    private weak var superview: UIView? = nil
    
    private var topOffset: CGFloat = 64
    
    private var bottomOffset: CGFloat = 120
    
    private var isStarted: Bool = false
    
    private var isReversed: Bool = false
    
    private var startY: CGFloat = 0
    
    private var finishY: CGFloat = 0
    
    init(for view: UIView) {
        super.init()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        view.addGestureRecognizer(pan)
        self.superview = view.superview
    }
    
    // MARK: Behavior
    
    private func start(for view: UIView?) {
        guard let view = view else { return }
        let bounds = superview?.bounds ?? UIScreen.main.bounds
        isReversed = view.frame.minY < bounds.midY
        startY = isReversed ? topOffset : bounds.height - bottomOffset
        finishY = isReversed ? bounds.height - bottomOffset : topOffset
        isStarted = true
    }
    
    private func progress(for view: UIView?, translation: CGFloat) -> CGFloat {
        guard isStarted else { return 0 }
        let distance = abs(finishY - startY)
        guard distance != 0 else { return 0 }
        if isReversed {
            return max(0, min(1, translation / distance))
        } else {
            return max(0, min(1, -translation / distance))
        }
    }
    
    private func update(for view: UIView?, progress: CGFloat) {
        guard isStarted else { return }
        let distance = finishY - startY
        let delta = progress * distance
        view?.frame.origin.y = startY + delta
    }
    
    private func finish(for view: UIView?, with progress: CGFloat, velocity: CGFloat) {
        guard isStarted else { return }
        var y: CGFloat = startY
        if (velocity == 0 && progress > 0.5) || (velocity > 0 && isReversed) || (velocity < 0 && !isReversed) {
            y = finishY
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            view?.frame.origin.y = y
        }, completion: nil)
        isStarted = false
        isForegroundOpened = y == topOffset
        delegate?.splitTransitionDidFinished(self)
    }
    
    // MARK: UI actions
    
    @objc func handlePan(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            start(for: pan.view)
        }
        guard isStarted else { return }
        
        let velocity = pan.velocity(in: superview).y
        let translation = pan.translation(in: superview).y
        let progress = self.progress(for: pan.view, translation: translation)
        if pan.state == .began || pan.state == .changed {
            update(for: pan.view, progress: progress)
        } else {
            finish(for: pan.view, with: progress, velocity: velocity)
        }
    }

}
