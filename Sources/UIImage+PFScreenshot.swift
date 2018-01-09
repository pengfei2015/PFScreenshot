//
//  UIImage+PFScreenshot.swift
//  PFScreenshot
//
//  Created by 飞流 on 2018/1/8.
//  Copyright © 2018年 飞流. All rights reserved.
//

import UIKit

extension PFSceenshot where Base: UIImage {
    
    public class func verticalImage(from imageArray: [UIImage]) -> UIImage? {
        let totalImageSize = verticalAppendToTalImageSize(from: imageArray)
        UIGraphicsBeginImageContextWithOptions(totalImageSize, false, 0)
        var imageOffsetFactor: CGFloat = 0
        imageArray.forEach {
            $0.draw(at: CGPoint(x: 0, y: imageOffsetFactor))
            imageOffsetFactor += $0.size.height
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public class func verticalAppendToTalImageSize(from imageArray: [UIImage]) -> CGSize {
        return imageArray.map { $0.size }.reduce(CGSize.zero) {
            var size = $0
            size.height += $1.height
            size.width = max(size.width, $1.width)
            return size
        }
    }
}
