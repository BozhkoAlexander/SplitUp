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
    
    private func setupContainer(_ container: inout SplitUpContainer?, for vc: SplitUpContainerViewController, animateRollIndicator: Bool) {
        let view = SplitUpContainer(with: vc.view, config: vc.containerConfig)
        view.scrollView = vc.scrollViewForSplit
        switch view.config.position {
        case .rear:
            var bottom = config.bottomOffset
            if !animateRollIndicator {
                bottom += RollIndicatorView.size.height
            }
            view.insets = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
        case .front:
            let top: CGFloat = view.config.animateRollIndicator ? 0 : RollIndicatorView.size.height
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
        
        let animate = vc.frontViewController.containerConfig.animateRollIndicator
        setupContainer(&rearContainer, for: vc.rearViewController, animateRollIndicator: animate)
        setupContainer(&frontContainer, for: vc.frontViewController, animateRollIndicator: animate)
        
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
            y = bounds.height - config.bottomOffset - RollIndicatorView.size.height
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
        frontContainer.frame.origin.y = y
        frontContainer.frame.size.width = bounds.size.width
        frontContainer.frame.size.height = h
    }
    
    // MARK: Animations & transition
    
    private func setRollStateAnimated(_ state: RollIndicatorView.State) {
        guard frontContainer.config.animateRollIndicator else { return }
        frontContainer.rollIndicator?.setState(state, animated: true)
    }
    
    @discardableResult
    func updateTransitionProgress(pan: UIPanGestureRecognizer) -> CGFloat {
        var minY = config.topOffset
        var maxY = bounds.height - config.bottomOffset - RollIndicatorView.size.height
        if #available(iOS 11.0, *) {
            minY += safeAreaInsets.top
            maxY -= safeAreaInsets.bottom
        }
        let dY = pan.translation(in: self).y
        
        switch state {
        case .rollUp:
            frontContainer.frame.origin.y = min(max(minY, maxY + dY), maxY)
            let progress = max(0, min(1, -dY / (maxY - minY)))
            rearContainer.shadeView?.alpha = progress * 0.8
            setRollStateAnimated(progress > 0 ? .line : .arrow)
            return progress
        case .rollDown:
            frontContainer.frame.origin.y = min(max(minY, minY + dY), maxY)
            let progress = max(0, min(1, dY / (maxY - minY)))
            rearContainer.shadeView?.alpha = 0.8 - progress * 0.8
            setRollStateAnimated(progress > 0 ? .arrow : .line)
            return progress
        default:
            return 0
        }
    }
    
    func finishTransition(_ complete: Bool, pan: UIPanGestureRecognizer) {
        var y: CGFloat = 0
        var alpha: CGFloat = 0
        var rollState: RollIndicatorView.State = .line
        
        switch state {
        case .rollUp where complete,
             .rollDown where !complete:
            y = config.topOffset
            if #available(iOS 11.0, *) {
                y += safeAreaInsets.top
            }
            alpha = 0.8
            if frontContainer.config.animateRollIndicator {
                rollState = .line
            }
            state = .up
        case .rollUp where !complete,
             .rollDown where complete:
            y = bounds.height - config.bottomOffset - RollIndicatorView.size.height
            if #available(iOS 11.0, *) {
                y -= safeAreaInsets.bottom
            }
            if frontContainer.config.animateRollIndicator {
                rollState = .arrow
            }
            state = .down
        default: break
        }
        let velocity = abs(pan.velocity(in: self).y)
        let options: UIView.AnimationOptions = velocity < 1 ? .curveEaseInOut : .curveEaseOut
        let view = frontContainer
        let shadeView = rearContainer.shadeView
        UIView.animate(withDuration: 0.25, delay: 0, options: options, animations: {
            view?.frame.origin.y = y
            shadeView?.alpha = alpha
        }, completion: nil)
        rearContainer.scrollView?.isScrollEnabled = true
        frontContainer.scrollView?.isScrollEnabled = true
        
        frontContainer.rollIndicator?.setState(rollState, animated: true)
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
                let shoouldRollUp = contentY >= scrollView.contentSize.height && velocity < 0
                let shouldDismiss = scrollView.contentOffset.y <= 0 && velocity > 0
                if shoouldRollUp || shouldDismiss {
                    scrollView.isScrollEnabled = false
                }
                return shoouldRollUp || shouldDismiss
            default:
                return false
            }
        }
        return false
    }
    
    func finishDismiss(_ pan: UIPanGestureRecognizer) {
        rearContainer.scrollView?.isScrollEnabled = true
    }
    
}
