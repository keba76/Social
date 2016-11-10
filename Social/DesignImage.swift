//
//  DesignImage.swift
//  Social
//
//  Created by Ievgen Keba on 11/5/16.
//  Copyright © 2016 Harman Inc. All rights reserved.
//

import UIKit

class DesignImage: UIImageView {
    
    override func layoutSubviews() {
        
        
        
        layer.cornerRadius = 3.0
        self.clipsToBounds = true
        
        let borderView = UIView()
        borderView.frame = CGRect(origin: self.frame.origin, size: self.bounds.size)
        
        superview?.addSubview(borderView)
        borderView.layer.cornerRadius = 3.0
        borderView.layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        borderView.layer.shadowOpacity = 0.8
        borderView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        borderView.layer.shadowRadius = 5.0
        borderView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        superview?.bringSubview(toFront: self)
    }
}
