//
//  UIScrollView+PFScreenshot.swift
//  PFScreenshot
//
//  Created by 飞流 on 2018/1/8.
//  Copyright © 2018年 飞流. All rights reserved.
//

import UIKit

extension PFSceenshot where Base: UIScrollView {

    var screenshotOfVisibleContent: UIImage? {
        var croppingRect = base.bounds
        croppingRect.origin = base.contentOffset
        return base.pf.screenshot(for: croppingRect)
    }
}
