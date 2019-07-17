//
//  UIApplication+TopUINavigationController.swift
//  GSiOSKit
//
//  Created by kismet adler on 2019/7/17.
//

import UIKit

extension UIApplication {
    public func getTopUINavigationController() -> UINavigationController? {
        let rootVC = self.keyWindow?.rootViewController
        var topVC = rootVC!
        while let top = topVC.presentedViewController {
            topVC = top
        }
        let presentedViewController = topVC
        if let navVC = presentedViewController as? UINavigationController {
            return navVC
        }else if let tabVC = presentedViewController as? UITabBarController,
            let navTopVC = tabVC.selectedViewController as? UINavigationController {
            return navTopVC
        }
        return nil
    }
}
