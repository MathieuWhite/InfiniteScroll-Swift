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
        
        
        let first = UIView(frame: self.view.bounds)
        first.backgroundColor = UIColor.redColor()
        
        let second = UIView(frame: self.view.bounds)
        second.backgroundColor = UIColor.greenColor()
        
        let third = UIView(frame: self.view.bounds)
        third.backgroundColor = UIColor.blueColor()
        
        
        let scrollView = InfiniteScrollView(frame: self.view.bounds)
        
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

