//
//  ViewController.swift
//  InfiniteScroll
//
//  Created by Mathieu White on 2016-05-14.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

class ViewController: UIViewController, InfiniteScrollViewDelegate {

    weak var scrollView: InfiniteScrollView?
    weak var pageControl: UIPageControl?
    var timer: NSTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) / 3.0)

        
        // Example views
        
        let first = UIView(frame: viewFrame)
        first.backgroundColor = UIColor.redColor()

        let second = UIView(frame: viewFrame)
        second.backgroundColor = UIColor.greenColor()

        let third = UIView(frame: viewFrame)
        third.backgroundColor = UIColor.blueColor()
        
        let fourth = UIView(frame: viewFrame)
        fourth.backgroundColor = UIColor.yellowColor()
        
        let items = [first, second, third, fourth]
        
        
        
        // Scroll view setup
        
        let scrollView = InfiniteScrollView(frame: viewFrame)
        scrollView.center = self.view.center
        scrollView.pagingDelegate = self
        scrollView.setItems(items)

        self.view.addSubview(scrollView)
        
        self.scrollView = scrollView
        
        
        
        // Page control setup
        let pageControl = UIPageControl(frame: CGRectZero)
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageControl.pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.6)
        pageControl.numberOfPages = items.count
        pageControl.hidesForSinglePage = true
        pageControl.sizeForNumberOfPages(items.count)
        pageControl.center = self.view.center
        pageControl.center.y = scrollView.center.y + (CGRectGetHeight(viewFrame)) / 2.0 - 20.0
        
        self.view.addSubview(pageControl)
        
        self.pageControl = pageControl
        
        
        // Auto scroll example
        self.setupTimer()
    }

    
    func setupTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(5.0,
                                                            target: self,
                                                            selector: #selector(self.autoScrollExample),
                                                            userInfo: nil,
                                                            repeats: true)
    }
    
    func autoScrollExample() {
        self.scrollView?.scrollToNextPage(animated: true)
    }

    
    // MARK: - InfiniteScrollViewDelegate Methods
    
    func scrollView(scrollView: UIScrollView, didUpdateCurrentPage pageIndex: Int) {
        self.pageControl?.currentPage = pageIndex
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.timer?.invalidate()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.setupTimer()
    }

}

