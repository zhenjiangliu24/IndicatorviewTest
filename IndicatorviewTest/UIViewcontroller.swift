//
//  UIViewcontroller.swift
//  IndicatorviewTest
//
//  Created by ZhongZhongzhong on 2016-10-07.
//  Copyright © 2016 ZhongZhongzhong. All rights reserved.
//

import UIKit

extension UIViewController: AppIndicatorViewable {
    func startActivityAnimating(message: String = "", dismissOnTap: Bool = false) {
        // Validate if activity exists animating
        
        startAnimating(CGSize(width: 90, height: 90), message: message)
        
    }
    
    func hideActivityIndicator() {
        stopAnimating()
    }
}
