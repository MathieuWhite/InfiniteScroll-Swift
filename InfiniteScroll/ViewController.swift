//
//  ViewController.swift
//  InfiniteScroll
//
//  Created by Mathieu White on 2016-05-14.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 3.0)

        let screenWidth = CGRectGetWidth(self.view.bounds)

        let first = UIView(frame: viewFrame)
        first.backgroundColor = UIColor.redColor()

        viewFrame.origin.x = screenWidth

        let second = UIView(frame: viewFrame)
        second.backgroundColor = UIColor.greenColor()

        viewFrame.origin.x = screenWidth * 2

        let third = UIView(frame: viewFrame)
        third.backgroundColor = UIColor.blueColor()
        
        
        let scrollView = InfiniteScrollView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 3.0))
        
        self.view.addSubview(scrollView)
        
        
        
        //second.frame.origin.x = CGRectGetWidth(self.view.bounds)
        //third.frame.origin.x = CGRectGetWidth(self.view.bounds) * 2.0
        
        
        scrollView.setItems([first, second, third])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

