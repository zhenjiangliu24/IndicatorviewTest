//
//  AppIndicatorPresenter.swift
//  ActivityData
//
//  Created by Zhenjiang Liu on 2016-10-07.
//  Copyright © 2016 Zhenjiang Liu. All rights reserved.
//

import UIKit
/// Class packages information used to display UI blocker.
public class ActivityData {
    /// Size of activity indicator view.
    let size: CGSize
    
    /// Message displayed under activity indicator view.
    let message: String?
    
    /// Color of activity indicator view.
    let color: UIColor
    
    /// Color of Container view.
    let containerColor: UIColor
    
    /// Padding of activity indicator view.
    let padding: CGFloat
    
    /// Container corner radius
    let containerCornerRadius: CGFloat
    
    /// Container width
    let containerWidth: CGFloat
    
    /// Container height
    let containerHeight: CGFloat
    
    /// dismiss on tap gesture
    let dismissOnTap: Bool
    
    /// Display time threshold to actually display UI blocker.
    let displayTimeThreshold: Int
    
    /// Minimum display time of UI blocker.
    let minimumDisplayTime: Int
    
    /**
     Create information package used to display UI blocker.
     
     Appropriate NVActivityIndicatorView.DEFAULT_* values are used for omitted params.
     
     - parameter size:                 size of activity indicator view.
     - parameter message:              message displayed under activity indicator view.
     - parameter type:                 animation type.
     - parameter color:                color of activity indicator view.
     - parameter padding:              padding of activity indicator view.
     - parameter displayTimeThreshold: display time threshold to actually display UI blocker.
     - parameter minimumDisplayTime:   minimum display time of UI blocker.
     
     - returns: The information package used to display UI blocker.
     */
    public init(size: CGSize? = nil,
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
        self.size = size ?? AppIndicatorView.DEFAULT_BLOCKER_SIZE
        self.message = message
        self.color = color ?? AppIndicatorView.DEFAULT_COLOR
        self.containerColor = containerColor ?? AppIndicatorView.DEFAULT_CONTAINER_COLOR
        self.containerCornerRadius = containerCornerRadius ?? AppIndicatorView.DEFAULT_CORNER_RADIUS
        self.containerWidth = ActivityData.percentX(value: containerWidth ?? AppIndicatorView.DEFAULT_CONTAINER_WIDTH_PERCENT)
        self.containerHeight = ActivityData.percentY(value: containerHeight ?? AppIndicatorView.DEFAULT_CONTAINER_HEIGHT_PERCENT)
        self.dismissOnTap = dismissOnTap ?? true
        self.padding = padding ?? AppIndicatorView.DEFAULT_PADDING
        self.displayTimeThreshold = displayTimeThreshold ?? AppIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD
        self.minimumDisplayTime = minimumDisplayTime ?? AppIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME
    }
}
private extension ActivityData {
    static func percentX(value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.width * value
    }
    
    static func percentY(value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.height * value
    }
}
public class AppIndicatorPresenter {
    private var showTimer: Timer?
    private var hideTimer: Timer?
    private var isStopAnimatingCalled = false
    private let restorationIdentifier = "AppIndicatorViewContainer"
    
    /// public singleton instance
    public static let sharedInstance = AppIndicatorPresenter()
    
    /// Do not allow initialiazation
    private init() {}
    
    // MARK: - Public functions
    /**
     Display UI blocker.
     
     - parameter data: Information package used to display UI blocker.
     */
    public func startAnimating(_ data: ActivityData) {
        guard showTimer == nil else { return }
        isStopAnimatingCalled = false
        showTimer = scheduledTimer(data.displayTimeThreshold, selector: #selector(AppIndicatorPresenter.showTimerFired(_:)), data: data)
    }
    
    /**
     Remove UI blocker.
     */
    public func stopAnimating() {
        isStopAnimatingCalled = true
        guard hideTimer == nil else { return }
        hide()
    }
    
    // MARK: - Timer events
    
    @objc private func showTimerFired(_ timer: Timer) {
        guard let activityData = timer.userInfo as? ActivityData else { return }
        show(with: activityData)
    }
    
    @objc private func hideTimerFired(_ timer: Timer) {
        hideTimer?.invalidate()
        hideTimer = nil
        if isStopAnimatingCalled {
            hide()
        }
    }
    
    // MARK: - Helpers
    
    private func show(with activityData: ActivityData) {
        let activityContainer: UIView = UIView(frame: UIScreen.main.bounds)
        
        activityContainer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityContainer.restorationIdentifier = restorationIdentifier
        
        if activityData.dismissOnTap {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
            activityContainer.addGestureRecognizer(tap)
        }
        
        let actualSize = activityData.size
        let activityIndicatorView = AppIndicatorView(
            frame: CGRect(x: 0, y: 0, width: actualSize.width, height: actualSize.height),
            color: activityData.color,
            containerColor: activityData.containerColor,
            padding: activityData.padding,
            message: activityData.message,
            containerCornerRadius: activityData.containerCornerRadius,
            dismissOnTap: activityData.dismissOnTap)
        
        let indicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: activityData.containerWidth, height: activityData.containerHeight))
        indicatorContainer.center = activityContainer.center
        indicatorContainer.backgroundColor = activityData.containerColor
        indicatorContainer.layer.cornerRadius = activityData.containerCornerRadius
        activityContainer.addSubview(indicatorContainer)
        
        activityIndicatorView.center = CGPoint(x: indicatorContainer.center.x, y: indicatorContainer.center.y - 30)
        activityIndicatorView.startAnimating()
        activityContainer.addSubview(activityIndicatorView)
        
        let width = activityContainer.frame.size.width / 3
        if let message = activityData.message , !message.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 30))
            label.center = CGPoint(
                x: activityIndicatorView.center.x,
                y: activityIndicatorView.center.y + actualSize.height)
            label.textAlignment = .center
            label.text = message
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = UIColor.black
            activityContainer.addSubview(label)
        }
        
        hideTimer = scheduledTimer(activityData.minimumDisplayTime, selector: #selector(AppIndicatorPresenter.hideTimerFired(_:)), data: nil)
        UIApplication.shared.keyWindow!.addSubview(activityContainer)
    }
    
    private func hide() {
        for item in UIApplication.shared.keyWindow!.subviews
            where item.restorationIdentifier == restorationIdentifier {
                item.removeFromSuperview()
        }
        showTimer?.invalidate()
        showTimer = nil
    }
    
    @objc func tapDismiss(){
        stopAnimating()
    }
}

private extension AppIndicatorPresenter {
    
    
    func scheduledTimer(_ timeInterval: Int, selector: Selector, data: ActivityData?) -> Timer {
        return Timer.scheduledTimer(timeInterval: Double(timeInterval) / 1000,
                                    target: self,
                                    selector: selector,
                                    userInfo: data,
                                    repeats: false)
    }
}
