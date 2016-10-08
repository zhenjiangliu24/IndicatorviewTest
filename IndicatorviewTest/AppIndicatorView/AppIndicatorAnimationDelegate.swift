//
//  AppIndicatorAnimationDelegate.swift
//  AppIndicatorAnimationDelegate
//
//  Created by Zhenjiang Liu on 2016-10-07.
//  Copyright © 2016 Zhenjiang Liu. All rights reserved.
//

import UIKit

protocol AppIndicatorAnimationDelegate {
    func setUpAnimation(in layer:CALayer, size: CGSize, color: UIColor)
}
