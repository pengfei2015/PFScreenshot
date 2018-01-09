//
//  UIColor+PFScreenshot.swift
//  PFScreenshot
//
//  Created by 飞流 on 2018/1/8.
//  Copyright © 2018年 飞流. All rights reserved.
//

import UIKit

extension PFSceenshot where Base: UIColor {
    func toImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        base.set()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
