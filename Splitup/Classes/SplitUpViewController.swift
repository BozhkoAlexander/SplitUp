//
//  SplitUpViewController.swift
//  Split Back
//
//  Created by Alex Bozhko on 07/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

open class SplitUpViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public enum State {
        
        case down
        
        case rollUp
        
        case up
        
        case rollDown
        
    }
    
    public struct Config {
        
        public var topOffset: CGFloat
        
        public var bottomOffset: CGFloat
        
        public init(topOffset: CGFloat, bottomOffset: CGFloat) {
            self.topOffset = topOffset
            self.bottomOffset = bottomOffset
        }
        
    }
    
    // MARK: Public properties
    
    public var state: State {
        get { return splitUpView.state }
        set { splitUpView.state = newValue }
    }
    
    public var rollIndicator: RollIndicatorView? {
        return splitUpView.frontContainer.rollIndicator
    }
    
    public var rearViewController: SplitUpContainerViewController?
    
    public let frontViewController: SplitUpContainerViewController
    
    public var config: Config {
        get { return splitUpView.config }
        set { splitUpView.config = newValue }
    }
    
    private var transition: SplitUpTransition? = nil
    
    // MARK: Properties
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return rearViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }
    
    var splitUpView: SplitUpView! { return view as? SplitUpView }
    
    var startConfig: SplitUpViewController.Config
    
    // MARK: Life cycle
    
    public init(config: Config, rear rvc: SplitUpContainerViewController?, front fvc: SplitUpContainerViewController) {
        self.startConfig = config
        self.rearViewController = rvc
        self.frontViewController = fvc
        super.init(nibName: nil, bundle: nil)

        if let rvc = rvc {
            addChild(rvc)
        }
        addChild(fvc)
        
        if rvc == nil {
            // needs custom presentation animation
            transition = SplitUpTransition()
            modalPresentationStyle = .custom
            transitioningDelegate = transition
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    open override func loadView() {
        view = SplitUpView(for: self)
    }
    
    @objc func didChangeState() {
        splitUpDidChangeState(state)
        if state == .down && rearViewController == nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Interactive dismissal
    
    open func splitUpDidChangeState(_ state: State) {
        print("INFO: Override splitUpDidChangeState(:_) without super call")
    }
    
    open func prepareInteractiveDismiss(with pan: UIPanGestureRecognizer) {
        print("INFO: Override prepareInteractiveDismiss(with:_) without super call")
    }
    
    open func updateInteractiveDismiss(with pan: UIPanGestureRecognizer) {
        print("INFO: Override updateInteractiveDismiss(with:_) without super call")
    }
    
    open func finishInteractiveDismiss(with pan: UIPanGestureRecognizer) {
        print("INFO: Override finishInteractiveDismiss(with:_) without super call")
    }
    
    // MARK: UI actions
    
    @objc func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Gesture handlers
    
    @objc func handlePan(_ pan: UIPanGestureRecognizer) {
        switch state {
        case .down where pan.state == .began:
            let velocity = pan.velocity(in: view)
            guard abs(velocity.y) > abs(velocity.x) else { break }
            if velocity.y < 0 {
                state = .rollUp
                splitUpView.updateTransitionProgress(pan: pan)
            } else {
                prepareInteractiveDismiss(with: pan)
            }
        case .down:
            updateInteractiveDismiss(with: pan)
            if pan.state == .cancelled || pan.state == .ended {
                splitUpView.finishDismiss(pan)
                finishInteractiveDismiss(with: pan)
            }
        case .rollUp:
            let progress = splitUpView.updateTransitionProgress(pan: pan)
            if pan.state == .cancelled || pan.state == .ended {
                let complete = progress > 0.20
                splitUpView.finishTransition(complete, pan: pan)
            }
        case .up where pan.state == .began:
            let velocity = pan.velocity(in: view).y
            if velocity > 0 {
                state = .rollDown
                splitUpView.updateTransitionProgress(pan: pan)
            }
        case .rollDown:
            let progress = splitUpView.updateTransitionProgress(pan: pan)
            if pan.state == .cancelled || pan.state == .ended {
                let complete = progress > 0.20
                splitUpView.finishTransition(complete, pan: pan)
            }
        default: break
        }
    }
    
    // MARK: Gesture recognizer delegate
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        return splitUpView.shouldStartTransition(pan: pan)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scrollView = (gestureRecognizer.view as? SplitUpContainer)?.scrollView, let otherView = otherGestureRecognizer.view else { return true }
        return scrollView == otherView || otherView.isDescendant(of: scrollView)
    }

}
