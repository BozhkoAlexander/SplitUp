//
//  UIView.swift
//  Split Back
//
//  Created by Alex Bozhko on 07/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

public extension UIView {
    
    var splitUp: SplitUpContainer? {
        return superview?.superview as? SplitUpContainer
    }
    
}
