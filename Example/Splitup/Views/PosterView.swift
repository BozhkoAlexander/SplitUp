//
//  PosterView.swift
//  Split Back
//
//  Created by Alex Bozhko on 06/12/2018.
//  Copyright © 2018 Filmgrail AS. All rights reserved.
//

import UIKit

class PosterView: UIView {
    
    // MARK: Properties
    
    weak var imageView: UIImageView! = nil
    
    private func setupImageView() {
        let view = UIImageView()
        view.backgroundColor = UIColor.groupTableViewBackground
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        addSubview(view)
        imageView = view
    }
    
    // MARK: Life cycle
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let size = imageView.image?.size {
            let w = size.height > size.width ? bounds.width - 72 : bounds.width
            let k = w / size.width
            let h = round(size.height * k)
            imageView.frame.size = CGSize(width: w, height: h)
        } else {
            imageView.frame.size = .zero
        }
        var h = bounds.height
        var y: CGFloat = 0
        if #available(iOS 11.0, *) {
            h -= safeAreaInsets.top + safeAreaInsets.bottom
            y += safeAreaInsets.top
        }
        if let insets = splitUp?.insets {
            h -= insets.top + insets.bottom
            y += insets.top
        }
        y += round(h / 2)
        imageView.center = CGPoint(x: bounds.midX, y: y)
    }

}
