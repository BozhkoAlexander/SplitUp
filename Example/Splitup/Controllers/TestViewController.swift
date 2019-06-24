//
//  TestViewController.swift
//  Splitup_Example
//
//  Created by Alex Bozhko on 12/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Splitup

class TestViewController: UIViewController {
    
    var testView: TestView! { return view as? TestView }
    
    // MARK: Life cycle

    override func loadView() {
        view = TestView(for: self)
    }
    
    // MARK: UI actions
    
    @objc func testPressed(_ sender: UIButton) {
        guard let rollView = testView.rollView else { return }
        switch rollView.form {
        case .line: rollView.setForm(.arrow, animated: true)
        case .arrow: rollView.setForm(.line, animated: true)
        }
    }
    
    @objc func detailsPressed(_ sender: UIButton) {
        let front = DetailsViewController()
        let vc = SplitUpViewController(
            config: SplitUpViewController.Config(topOffset: 64, bottomOffset: 200),
            rear: PosterViewController(),
            front: front
        )
        vc.rollIndicator?.addTarget(front, action: #selector(front.closePressed), for: .touchUpInside)
        present(vc, animated: true)
    }

}
