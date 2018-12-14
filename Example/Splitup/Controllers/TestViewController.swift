//
//  TestViewController.swift
//  Splitup_Example
//
//  Created by Alex Bozhko on 12/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    var testView: TestView! { return view as? TestView }
    
    // MARK: Life cycle

    override func loadView() {
        view = TestView(for: self)
    }
    
    // MARK: UI actions
    
    @objc func testPressed(_ sender: UIButton) {
        guard let rollView = testView.rollView else { return }
        switch rollView.state {
        case .line: rollView.setState(.arrow, animated: true)
        case .arrow: rollView.setState(.line, animated: true)
        }
    }

}
