//
//  DesignImage.swift
//  Social
//
//  Created by Ievgen Keba on 11/5/16.
//  Copyright © 2016 Harman Inc. All rights reserved.
//

import UIKit

class DesignImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowRadius = 5.0
        layer.cornerRadius = 2.0
    }

}
