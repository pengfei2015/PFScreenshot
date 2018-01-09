//
//  ImageViewController.swift
//  PFScreenshot
//
//  Created by 飞流 on 2018/1/9.
//  Copyright © 2018年 飞流. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet private var scrollView: UIScrollView!
    private var screenshotImageView: UIImageView!
    
    var screenshot: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenshotImageView = UIImageView(image: screenshot)
        screenshotImageView.backgroundColor = .white
        scrollView.addSubview(screenshotImageView)
        scrollView.contentSize = screenshotImageView.frame.size
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
    }

}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return screenshotImageView
    }
}
