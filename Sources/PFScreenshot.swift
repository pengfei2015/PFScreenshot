//
//  PFScreenshot.swift
//  PFScreenshot
//
//  Created by 飞流 on 2018/1/8.
//  Copyright © 2018年 飞流. All rights reserved.
//

import UIKit

public final class PFSceenshot<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol PFScreenshotCompatible {
    associatedtype CompatibleType
    var pf: CompatibleType { get }
}

public extension PFScreenshotCompatible {
    public var pf: PFSceenshot<Self> {
        return PFSceenshot(self)
    }
    public static var pf: PFSceenshot<Self>.Type {
        return PFSceenshot<Self>.self
    }
}

extension UIView: PFScreenshotCompatible { }
extension UIImage: PFScreenshotCompatible { }
extension UIColor: PFScreenshotCompatible { }
