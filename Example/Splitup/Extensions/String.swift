//
//  String.swift
//  Split Back
//
//  Created by Alex Bozhko on 06/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

extension String {
    
    func boundingSize(with size: CGSize, font: UIFont) -> CGSize {
        let s = (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
        return CGSize(width: ceil(s.width), height: ceil(s.height))
    }
    
}
