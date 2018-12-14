//
//  PosterViewController.swift
//  Split Back
//
//  Created by Alex Bozhko on 06/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit
import Splitup

class PosterViewController: UIViewController, SplitUpContainerConfig {
    
    var containerConfig: SplitUpContainer.Config {
        return SplitUpContainer.Config(
            position: .rear,
            closeButtonImage: nil
        )
    }
    
    var scrollViewForSplit: UIScrollView? {
        return nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Properties
    
    var posterView: PosterView! { return view as? PosterView }
    
    // MARK: Life cycle
    
    override func loadView() {
        view = PosterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "poster1", ofType: "jpg") {
            posterView.imageView.image = UIImage(contentsOfFile: path)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
