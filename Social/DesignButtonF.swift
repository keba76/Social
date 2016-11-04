//
//  DesignButtonF.swift
//  Social
//
//  Created by Ievgen Keba on 11/4/16.
//  Copyright © 2016 Harman Inc. All rights reserved.
//

import UIKit

class DesignButtonF: UIButton {
    
    var shadowLayer: CAShapeLayer!

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
//        layer.shadowOpacity = 0.8
//        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        layer.shadowRadius = 5.0
//        imageView?.contentMode = .scaleAspectFit
//}
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = self.frame.width / 2
//        layer.masksToBounds = true
//    }
//    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let image = CALayer()
        image.frame = CGRect(origin: layer.bounds.origin, size: layer.bounds.size)
        image.contents = UIImage(named: "facebook")?.cgImage
        image.cornerRadius = frame.width / 2
        image.masksToBounds = true
        //layer.insertSublayer(image, at: 0)
        layer.addSublayer(image)
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: image.bounds, cornerRadius: image.bounds.width / 2).cgPath
            
            shadowLayer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 5.0
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
        
    }
    }

