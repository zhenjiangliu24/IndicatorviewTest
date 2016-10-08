//
//  AppIndicatorViewable.swift
//  NVActivityIndicatorView
//
//  Created by Zhenjiang Liu on 2016-10-07.
//  Copyright © 2016 Zhenjiang Liu. All rights reserved.
//

import UIKit

public protocol AppIndicatorViewable { }

public extension AppIndicatorViewable where Self: UIViewController {
    public func startAnimating(
        _ size: CGSize? = nil,
        message: String? = nil,
        color: UIColor? = nil,
        containerColor: UIColor? = nil,
        padding: CGFloat? = nil,
        containerCornerRadius: CGFloat? = nil,
        containerWidth: CGFloat? = nil,
        containerHeight: CGFloat? = nil,
        dismissOnTap: Bool? = nil,
        displayTimeThreshold: Int? = nil,
        minimumDisplayTime: Int? = nil) {
        let activityData = ActivityData(size: size,
                                        message: message,
                                        color: color,
                                        containerColor: containerColor,
                                        padding: padding,
                                        containerCornerRadius: containerCornerRadius,
                                        containerWidth: containerWidth,
                                        containerHeight: containerHeight,
                                        dismissOnTap: dismissOnTap,
                                        displayTimeThreshold: displayTimeThreshold,
                                        minimumDisplayTime: minimumDisplayTime)
        
        AppIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    /**
     Remove UI blocker.
     */
    public func stopAnimating() {
        AppIndicatorPresenter.sharedInstance.stopAnimating()
    }
}


