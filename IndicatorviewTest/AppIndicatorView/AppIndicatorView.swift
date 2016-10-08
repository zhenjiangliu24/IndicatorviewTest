//
//  AppIndicatorView.swift
//  AppIndicatorView
//
//  Created by Zhenjiang Liu on 2016-10-07.
//  Copyright © 2016 Zhenjiang Liu. All rights reserved.
//

import UIKit

public class AppIndicatorView: UIView {
    /// Default Indicator view color.
    public static var DEFAULT_COLOR = UIColor.init(red: 48.0/255.0, green: 206.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    /// Defualt Container view color. Default value is white.
    public static var DEFAULT_CONTAINER_COLOR = UIColor.white
    
    /// Default padding. Default value is 0.
    public static var DEFAULT_PADDING: CGFloat = 0.0
    
    /// Default message. Default is "Loading..."
    public static var DEFAULT_MESSAGE: String = "Loading..."
    
    /// Default container corner radius.
    public static var DEFAULT_CORNER_RADIUS: CGFloat = 5.0
    
    /// Default width percentage of screen.
    public static var DEFAULT_CONTAINER_WIDTH_PERCENT: CGFloat = 0.5333
    
    /// Default height percentage of screen.
    public static var DEFAULT_CONTAINER_HEIGHT_PERCENT: CGFloat = 0.3
    
    /// Default size of activity indicator view in UI blocker. Default value is 60x60.
    public static var DEFAULT_BLOCKER_SIZE = CGSize(width: 75, height: 75)
    
    /// Default display time threshold to actually display UI blocker. Default value is 0 ms.
    public static var DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0
    
    /// Default minimum display time of UI blocker. Default value is 0 ms.
    public static var DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0
    
    /// Indicator color.
    @IBInspectable public var color: UIColor = AppIndicatorView.DEFAULT_COLOR
    
    /// Container color.
    @IBInspectable public var containerColor: UIColor = AppIndicatorView.DEFAULT_CONTAINER_COLOR
    
    /// Padding to edges.
    @IBInspectable public var padding: CGFloat = AppIndicatorView.DEFAULT_PADDING
    
    /// Loading message.
    @IBInspectable public var message: String = AppIndicatorView.DEFAULT_MESSAGE
    
    /// Container corner radius.
    @IBInspectable public var containerCornerRadius: CGFloat = AppIndicatorView.DEFAULT_CORNER_RADIUS
    
    /// Container width percentage of screen.
    @IBInspectable public var containerWidth: CGFloat = AppIndicatorView.DEFAULT_CONTAINER_WIDTH_PERCENT
    
    /// Container height percentage of screen.
    @IBInspectable public var containerHeight: CGFloat = AppIndicatorView.DEFAULT_CONTAINER_HEIGHT_PERCENT
    
    /// Dismiss on tap flag. Default value is true.
    @IBInspectable public var dismissOnTap: Bool = true
    
    /// Animataing Flag. Read only.
    public private(set) var isAnimating: Bool = false
    
    var containerFrame: CGRect = CGRect.zero
    
    /**
     Returns an object initialized from data in a given unarchiver.
     self, initialized using the data in decoder.
     
     - parameter decoder: an unarchiver object.
     
     - returns: self, initialized using the data in decoder.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        self.isHidden = true
    }
    
    public init(frame: CGRect, color: UIColor? = nil, containerColor: UIColor? = nil, padding: CGFloat? = nil, message: String? = nil, containerCornerRadius: CGFloat? = nil, dismissOnTap: Bool? = nil) {
        self.containerFrame = frame
        self.color = color ?? AppIndicatorView.DEFAULT_COLOR
        self.containerColor = containerColor ?? AppIndicatorView.DEFAULT_CONTAINER_COLOR
        self.padding = padding ?? AppIndicatorView.DEFAULT_PADDING
        self.message = message ?? AppIndicatorView.DEFAULT_MESSAGE
        self.containerCornerRadius = containerCornerRadius ?? AppIndicatorView.DEFAULT_CORNER_RADIUS
        self.dismissOnTap = dismissOnTap ?? true
        super.init(frame: frame)
        self.isHidden = true
    }
    
    /**
     Returns the natural size for the receiving view, considering only properties of the view itself.
     
     A size indicating the natural size for the receiving view based on its intrinsic properties.
     
     - returns: A size indicating the natural size for the receiving view based on its intrinsic properties.
     */
    public override var intrinsicContentSize : CGSize {
        return CGSize(width: self.bounds.width, height: self.bounds.height)
    }
    
    /**
     Start animating.
     */
    public func startAnimating() {
        self.isHidden = false
        self.isAnimating = true
        self.layer.speed = 1
        setupAnimation()
    }
    
    /**
     Stop animating.
     */
    public func stopAnimating() {
        self.isHidden = true
        self.isAnimating = false
        self.layer.sublayers?.removeAll()
    }
    
    private func setupAnimation() {
        let animation = AppIndicatorRotate()
        var animationRect = UIEdgeInsetsInsetRect(self.frame, UIEdgeInsetsMake(padding, padding, padding, padding))
        let minEdge = min(animationRect.width, animationRect.height)
        
        self.layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: self.layer, size: animationRect.size, color: self.color)
    }
}
