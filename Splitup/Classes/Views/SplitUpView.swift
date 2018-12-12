//
//  SplitUpView.swift
//  Split Back
//
//  Created by Alex Bozhko on 07/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

class SplitUpView: UIView {
    
    // MARK: Config
    
    var state: SplitUpViewController.State = .down
    
    private let config: SplitUpViewController.Config
    
    // MARK: Subviews

    weak var rearContainer: SplitUpContainer! = nil
    
    weak var frontContainer: SplitUpContainer! = nil
    
    private func setupContainer(_ container: inout SplitUpContainer?, for vc: SplitUpContainerViewController) {
        let view = SplitUpContainer(with: vc.view, config: vc.containerConfig)
        view.scrollView = vc.scrollViewForSplit
        switch view.config.position {
        case .rear:
            view.insets = UIEdgeInsets(top: 0, left: 0, bottom: config.bottomOffset, right: 0)
        case .front:
            let top: CGFloat = view.config.rollType == .line ? 20 : 0
            view.insets = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        }
        
        addSubview(view)
        container = view
    }
    
    private func setupPan(for vc: SplitUpViewController) {
        let rear = UIPanGestureRecognizer(target: vc, action: #selector(vc.handlePan(_:)))
        rear.delegate = vc
        rearContainer.addGestureRecognizer(rear)
        
        let front = UIPanGestureRecognizer(target: vc, action: #selector(vc.handlePan(_:)))
        front.delegate = vc
        frontContainer.addGestureRecognizer(front)
    }
    
    // MARK: Life cycle
    
    init(for vc: SplitUpViewController) {
        self.config = vc.config
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        setupContainer(&rearContainer, for: vc.rearViewController)
        setupContainer(&frontContainer, for: vc.frontViewController)
        
        setupPan(for: vc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rearContainer.frame = bounds
        
        frontContainer.frame.origin.x = 0
        var y: CGFloat = 0
        switch state {
        case .down:
            y = bounds.height - config.bottomOffset
            if #available(iOS 11.0, *) {
                y -= safeAreaInsets.bottom
            }
        case .up:
            y = config.topOffset
            if #available(iOS 11.0, *) {
                y += safeAreaInsets.top
            }
        default: break
        }
        var h = bounds.height - config.topOffset
        if #available(iOS 11.0, *) {
            h -= safeAreaInsets.top
        }
        if frontContainer.config.rollType == .arrow {
            let dY = RollIndicatorView.heightForType(.arrow)
            y -= dY
            h += dY
        }
        frontContainer.frame.origin.y = y
        frontContainer.frame.size.width = bounds.size.width
        frontContainer.frame.size.height = h
    }
    
    // MARK: Animations & transition
    
    @discardableResult
    func updateTransitionProgress(pan: UIPanGestureRecognizer) -> CGFloat {
        var minY = config.topOffset
        var maxY = bounds.height - config.bottomOffset
        if #available(iOS 11.0, *) {
            minY += safeAreaInsets.top
            maxY -= safeAreaInsets.bottom
        }
        let dY = pan.translation(in: self).y
        
        switch state {
        case .rollUp:
            frontContainer.frame.origin.y = min(max(minY, maxY + dY), maxY)
            let progress = max(0, min(1, abs(dY / (maxY - minY))))
            frontContainer.rollIndicator?.progress = progress
            rearContainer.shadeView?.alpha = progress * 0.8
            return progress
        case .rollDown:
            frontContainer.frame.origin.y = min(max(minY, minY + dY), maxY)
            let progress = max(0, min(1, abs(dY / (maxY - minY))))
            frontContainer.rollIndicator?.progress = progress
            rearContainer.shadeView?.alpha = 0.8 - progress * 0.8
            return progress
        default:
            return 0
        }
    }
    
    func finishTransition(_ complete: Bool, pan: UIPanGestureRecognizer) {
        var y: CGFloat = 0
        var alpha: CGFloat = 0
        var rollProgress: CGFloat = 0
        
        switch state {
        case .rollUp where complete,
             .rollDown where !complete:
            y = config.topOffset
            if #available(iOS 11.0, *) {
                y += safeAreaInsets.top
            }
            alpha = 0.8
            rollProgress = 1
            state = .up
        case .rollUp where !complete,
             .rollDown where complete:
            y = bounds.height - config.bottomOffset
            if #available(iOS 11.0, *) {
                y -= safeAreaInsets.bottom
            }
            state = .down
        default: break
        }
        if frontContainer.config.rollType == .arrow {
            y -= RollIndicatorView.heightForType(.arrow)
        }
        let velocity = abs(pan.velocity(in: self).y)
        let options: UIView.AnimationOptions = velocity < 1 ? .curveEaseInOut : .curveEaseOut
        let view = frontContainer
        let shadeView = rearContainer.shadeView
        UIView.animate(withDuration: 0.25, delay: 0, options: options, animations: {
            view?.frame.origin.y = y
            shadeView?.alpha = alpha
        }, completion: nil)
        frontContainer.rollIndicator?.setProgressAnimated(rollProgress)
        rearContainer.scrollView?.isScrollEnabled = true
        frontContainer.scrollView?.isScrollEnabled = true
    }
    
    func shouldStartTransition(pan: UIPanGestureRecognizer) -> Bool {
        if pan.view == frontContainer {
            switch state {
            case .down:
                frontContainer.scrollView?.isScrollEnabled = false
                return true
            case .up:
                guard let scrollView = frontContainer.scrollView else { return true }
                let velocity = pan.velocity(in: self).y
                let shouldStart = scrollView.contentOffset.y <= 0 && velocity > 0
                if shouldStart {
                    scrollView.isScrollEnabled = false
                }
                return shouldStart
            default:
                return false
            }
        } else if pan.view == rearContainer {
            switch state {
            case .down:
                guard let scrollView = rearContainer.scrollView else { return true }
                let velocity = pan.velocity(in: self).y
                let contentY = scrollView.contentOffset.y + scrollView.bounds.height
                let shouldStart = contentY >= scrollView.contentSize.height && velocity < 0
                if shouldStart {
                    scrollView.isScrollEnabled = false
                }
                return shouldStart
            default:
                return false
            }
        }
        return false
    }
    
}
