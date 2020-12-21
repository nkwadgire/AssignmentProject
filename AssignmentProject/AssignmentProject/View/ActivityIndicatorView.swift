/**
 *  * *****************************************************************************
 *  * Filename: ActivityIndicatorView.swift
 *  * Author  : Nagraj Wadgire
 *  * Creation Date: 21/12/20
 *  * *
 *  * *****************************************************************************
 *  * Description:
 *  * This view will show and hide the loading indicator view
 *  *                                                                             *
 *  * *****************************************************************************
 */

import UIKit

class ActivityIndicatorView {
    var activityView: UIActivityIndicatorView?
    static let shared = ActivityIndicatorView()
    
    /**
     This method will add loading indicator view as subview to the main view
     */
    func showActivityIndicator(inView: UIView) {
        for view in inView.subviews where view is UIActivityIndicatorView {
            view.removeFromSuperview()
        }
        
        if #available(iOS 12.0, *) {
            activityView = UIActivityIndicatorView(style: .gray)
        } else {
            activityView = UIActivityIndicatorView(style: .large)
        }
        activityView?.center = inView.center
        inView.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    /**
     This method will remove loading indicator view from main view
     */
    func hideActivityIndicator() {
        if activityView != nil {
            activityView?.stopAnimating()
        }
    }
}
