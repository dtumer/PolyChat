//
//  ProgressHUD.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/14/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import JGProgressHUD

public class ProgressHUD {
    
    var overlayView = UIView()
    var activityIndicator: JGProgressHUD! = JGProgressHUD(style: .dark)
    
    class var shared: ProgressHUD {
        struct Static {
            static let instance: ProgressHUD = ProgressHUD()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView!) {
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.white
        
        activityIndicator.textLabel.text = "Loading"
        activityIndicator.center = overlayView.center
        
        activityIndicator.show(in: overlayView)
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        activityIndicator.dismiss()
        overlayView.removeFromSuperview()
    }
}
