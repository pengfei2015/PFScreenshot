//
//  UIView+PFScreenshot.swift
//  PFScreenshot
//
//  Created by 飞流 on 2018/1/8.
//  Copyright © 2018年 飞流. All rights reserved.
//

import UIKit
import WebKit

extension PFSceenshot where Base: UIView {
    
    var screenshot: UIImage? {
        return base.pf.screenshot(for: base.bounds)
    }
    
    func screenshot(for croppingRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(croppingRect.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: -croppingRect.origin.x, y: -croppingRect.origin.y)
        base.layoutIfNeeded()
        if isContainsWKWebView {
            base.drawHierarchy(in: croppingRect, afterScreenUpdates: false)
        } else {
            base.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var isContainsWKWebView: Bool {
        if base is WKWebView {
            return true
        }
        for subview in base.subviews {
            if subview.pf.isContainsWKWebView {
                return true
            }
        }
        return false
    }
}
