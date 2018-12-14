//
//  SplitBackViewController.swift
//  Split Back
//
//  Created by Alex Bozhko on 06/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

public class SplitBackViewController: UIViewController, SplitUpTransitionDelegate {
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if let backgroundViewController = backgroundViewController {
            return backgroundViewController.preferredStatusBarStyle
        } else {
            return .default
        }
    }
    
    // MARK: Public properties
    
    public var backgroundViewController: UIViewController?
    
    public var foregroundViewController: UIViewController?
    
    // MARK: Properties
    
    var splitBackView: SplitBackView! { return view as? SplitBackView }
    
    // MARK: Life cycle
    
    init(background: UIViewController?, foreground: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        
        self.backgroundViewController = background
        self.foregroundViewController = foreground
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    public override func loadView() {
        view = SplitBackView(background: backgroundViewController, foreground: foregroundViewController)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        splitBackView.transitionController?.delegate = self
        (foregroundViewController as? DetailsViewController)?.detailsView.collectionView.isScrollEnabled = false
    }
    
    // MARK: Transition delegate
    
    func splitTransitionDidFinished(_ controller: SplitUpTransitionController) {
        (foregroundViewController as? DetailsViewController)?.detailsView.collectionView.isScrollEnabled = controller.isForegroundOpened
    }

}

