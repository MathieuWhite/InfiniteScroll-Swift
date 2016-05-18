//
//  InfiniteScrollView.swift
//  InfiniteScroll
//
//  Created by Mathieu White on 2016-05-14.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

protocol InfiniteScrollViewDelegate: UIScrollViewDelegate
{
    /**
     This method tells the delegate that current page on the
     scroll view has been updated.
     
     - parameter scrollView: the scroll view whose page changed
     - parameter pageIndex:  the new page of the scroll view
     */
    func scrollView(scrollView: UIScrollView, didUpdateCurrentPage pageIndex: Int)
}

// Optional InfiniteScrollViewDelegate methods
extension InfiniteScrollViewDelegate
{
    func scrollView(scrollView: UIScrollView, didUpdateCurrentPage pageIndex: Int) { }
}

/// InfiniteScrollView is a UIScrollView subclass that endlessly scrolls content,
/// never letting the user hit the edge of the content. The scrolling is horizontal only.
class InfiniteScrollView: UIScrollView, UIScrollViewDelegate
{
    // MARK: - Variables
    
    /// An array containing the visible items in the scroll view.
    var visibleItems: [UIView] = []
    
    /// The current page being displayed on the scroll view.
    var currentPage: Int = 0
    
    /// The animation duration for the auto scrolling.
    /// The default duration is 1.0.
    var animationDuration: NSTimeInterval = 1.0
    
    /// An array containing all of the items in the scroll view.
    private var internalItems: [UIView] = []
    
    /// The frame of the view on the previous page.
    private var previousViewFrame = CGRectZero
    
    /// The frame of the view on the current page.
    private var currentViewFrame = CGRectZero
    
    /// The frame of the view on the next page.
    private var nextViewFrame = CGRectZero
    
    /// The infinite scroll view delegate of the scroll view.
    weak var pagingDelegate: InfiniteScrollViewDelegate?
    
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setupInfiniteScrollView()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setupInfiniteScrollView()
    }
    
    init(items: [UIView])
    {
        super.init(frame: CGRectZero)
        self.setupInfiniteScrollView()
        self.setItems(items)
    }
    
    convenience init()
    {
        self.init(frame: CGRectZero)
    }
    
    private func setupInfiniteScrollView()
    {
        // Disable the scroll indicators
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        // Enable paging on the scroll view
        self.pagingEnabled = true
        
        // Disable bouncing on the scroll view
        self.bounces = false
        
        // Set the delegate of the scroll view
        self.delegate = self
    }
    
    
    // MARK: - Instance Methods
    
    /**
     This method sets the current items on the scroll view.
     
     - parameter items: the views to be placed in the scroll view
     */
    func setItems(items: [UIView])
    {
        // Mainly for auto layout, ask the scroll view to size itself
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        // Get the width of the scroll view
        let currentWidth: CGFloat = CGRectGetWidth(self.bounds)
        
        // Get the height of the scroll view
        let currentHeight: CGFloat = CGRectGetHeight(self.bounds)
        
        // Calculate our factor to multiply the content's width by
        let multiplier: CGFloat = (items.count > 1) ? 3.0 : 1.0
        
        // Reference the items
        self.internalItems = items
        
        // Reset the current page
        self.currentPage = 0
        
        // Center the content view on the middle page
        self.contentOffset = CGPointMake(currentWidth, self.contentOffset.y)
        
        // Set the new content size
        self.contentSize = CGSizeMake(currentWidth * multiplier, CGRectGetHeight(self.bounds))
        
        // Set the frames for the different pages in the scroll view
        self.previousViewFrame = CGRectMake(0.0, 0.0, currentWidth, currentHeight)
        self.currentViewFrame = CGRectMake(currentWidth, 0.0, currentWidth, currentHeight)
        self.nextViewFrame = CGRectMake(currentWidth * 2.0, 0.0, currentWidth, currentHeight)
        
        // Update the pages
        self.updatePagingIfNeeded()
    }
    
    /**
     This method moves the scroll view over to the next page.
     Set the `animationDuration` property to control the speed of the animation.
     
     - parameter animated: true to animate the change, false otherwise
     */
    func scrollToNextPage(animated animated: Bool)
    {
        // Don't animate if we have less than 2 items
        if (self.internalItems.count < 2) {
            return
        }
        
        // Disable the interaction until the animation is completed.
        self.userInteractionEnabled = false
        
        UIView.animateWithDuration(animated ? self.animationDuration : 0.0,
                                   animations: {
                                    self.setContentOffset(self.nextViewFrame.origin, animated: false)
            },
                                   completion: {(finished) -> Void in
                                    self.recenterIfNecessary()
                                    self.userInteractionEnabled = true
        })
    }
    
    
    /**
     This method moves the scroll view back to the previous page.
     Set the `animationDuration` property to control the speed of the animation.
     
     - parameter animated: true to animate the change, false otherwise
     */
    func scrollToPreviousPage(animated animated: Bool)
    {
        // Don't animate if we have less than 2 items
        if (self.internalItems.count < 2) {
            return
        }
        
        // Disable the interaction until the animation is completed.
        self.userInteractionEnabled = false
        
        UIView.animateWithDuration(animated ? self.animationDuration : 0.0,
                                   animations: {
                                    self.setContentOffset(self.previousViewFrame.origin, animated: false)
            },
                                   completion: {(finished) -> Void in
                                    self.recenterIfNecessary()
                                    self.userInteractionEnabled = true
        })
    }
    
    
    /**
     Makes an exact copy of a UIView
     
     - parameter source: view to copy
     
     - returns: a copy of the source view
     */
    private func copyView(source: UIView) -> UIView
    {
        let archive = NSKeyedArchiver.archivedDataWithRootObject(source)
        return NSKeyedUnarchiver.unarchiveObjectWithData(archive) as! UIView
    }
    
    
    // MARK: - Layout Methods
    
    /**
     This method recenters the scroll view's content size if necessary.
     The recentering occurs if the offset ends up at the edge of the content.
     */
    private func recenterIfNecessary()
    {
        // Get the current offset of the content
        let currentOffsetX = self.contentOffset.x
        
        // Get the width of a single page
        let pageWidth = CGRectGetWidth(self.bounds)
        
        // If the offset in the X dimension is larger than one page width,
        // the page moved forward. If the offset is smaller or equal to 0,
        // the page moved backwards. Recenter the content and update the pages.
        if (currentOffsetX > pageWidth || currentOffsetX <= 0.0)
        {
            // Center the content view on the middle page
            self.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), self.contentOffset.y)
            
            if (currentOffsetX >= pageWidth)
            {
                self.currentPage = (self.currentPage < self.internalItems.count - 1) ? self.currentPage + 1 : 0
            }
            else
            {
                self.currentPage = (self.currentPage > 0) ? self.currentPage - 1 : self.internalItems.count - 1
            }
            
            // Update the left and right views if needs
            self.updatePagingIfNeeded()
        }
    }
    
    /**
     This method updates the current page, if needed. After setting
     the `currentPage` property, you can call this method to set that
     page as the current view.
     */
    private func updatePagingIfNeeded()
    {
        // Remove all the views from the scroll view
        for view in self.visibleItems {
            view.removeFromSuperview()
        }
        
        // Remove all the visible items from the array
        self.visibleItems.removeAll()
        
        // If we have no items to display, get out
        if (self.internalItems.isEmpty) {
            return
        }
        
        // Count our internal items
        let numberOfItems = self.internalItems.count
        
        // Get the view for the current page, and set its frame based on the number of items
        let currentView = self.internalItems[self.currentPage]
        currentView.frame = (numberOfItems > 1) ? self.currentViewFrame : self.previousViewFrame
        
        // Reference for the item in our previous page
        var previousView: UIView?
        
        // Reference for the item in our next page
        var nextView: UIView?
        
        
        // Set up our view for the previous and next pages
        if (numberOfItems == 2) {
            // If we only have 2 items,
            // the previous and next pages will be the same
            previousView = (self.currentPage == 0) ? self.internalItems.last! : self.internalItems.first!
            nextView = self.copyView(previousView!)
        }
        else if (numberOfItems > 2) {
            // We have more than 2 items,
            // display the previous and next pages
            previousView = (self.currentPage > 0) ? self.internalItems[self.currentPage - 1] : self.internalItems.last!
            nextView = (self.currentPage < self.internalItems.count - 1) ? self.internalItems[self.currentPage + 1] : self.internalItems.first!
        }
        
        // Set up the frame for the previous and next pages
        previousView?.frame = self.previousViewFrame
        nextView?.frame = self.nextViewFrame
        
        
        // Add our views to the scroll view and the visible items array
        self.addSubview(currentView)
        self.visibleItems.append(currentView)
        
        if (previousView != nil) {
            self.addSubview(previousView!)
            self.visibleItems.append(previousView!)
        }
        
        if (nextView != nil) {
            self.addSubview(nextView!)
            self.visibleItems.append(nextView!)
        }
        
        
        // Notifiy the delegate that the current page has changed
        self.pagingDelegate?.scrollView(self, didUpdateCurrentPage: self.currentPage)
    }
    
    
    // MARK: - UIScrollViewDelegate Methods
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if (decelerate)
        {
            self.userInteractionEnabled = false
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        self.recenterIfNecessary()
        scrollView.userInteractionEnabled = true
    }
    
}
