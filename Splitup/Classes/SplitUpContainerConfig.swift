//
//  SplitUpContainerConfig.swift
//  Split Back
//
//  Created by Alex Bozhko on 07/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

public typealias SplitUpContainerViewController = UIViewController & SplitUpContainerConfig

public protocol SplitUpContainerConfig {
    
    var containerConfig: SplitUpContainer.Config { get }
    
    var scrollViewForSplit: UIScrollView? { get }
    
}
