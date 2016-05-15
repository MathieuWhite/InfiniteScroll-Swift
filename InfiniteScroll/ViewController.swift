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

        let viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 3.0)


        let first = UIView(frame: viewFrame)
        first.backgroundColor = UIColor.redColor()

        let second = UIView(frame: viewFrame)
        second.backgroundColor = UIColor.greenColor()


        let third = UIView(frame: viewFrame)
        third.backgroundColor = UIColor.blueColor()
        
        let fourth = UIView(frame: viewFrame)
        fourth.backgroundColor = UIColor.yellowColor()
        
        let fifth = UIView(frame: viewFrame)
        fifth.backgroundColor = UIColor.purpleColor()
        
        
        let scrollView = InfiniteScrollView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 3.0))
        
        self.view.addSubview(scrollView)
        
        scrollView.setItems([first, second, third, fourth, fifth])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

