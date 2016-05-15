//
//  InfiniteScrollView.swift
//  InfiniteScroll
//
//  Created by Mathieu White on 2016-05-14.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

/// InfiniteScrollView is a UIScrollView subclass that endlessly scrolls content,
/// never letting the user hit the edge of the content. The scrolling is horizontal only.
class InfiniteScrollView: UIScrollView, UIScrollViewDelegate
{
    // MARK: - Variables
    
    /// The content view of the scroll view. It is the only subview it contains.
    var contentView: UIView?

    /// An array containing the visible items in the scroll view.
    var visibleItems: [UIView] = []
    
    /// The current page being displayed on the scroll view.
    var currentPage: Int = 0
    
    /// An array containing all of the items in the scroll view.
    private var internalItems: [UIView] = []

    private var leftViewFrame = CGRectZero
    private var centerViewFrame = CGRectZero
    private var rightViewFrame = CGRectZero
    
    
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
        self.internalItems = items
        self.setupInfiniteScrollView()
    }
    
    convenience init()
    {
        self.init(frame: CGRectZero)
    }
    
    private func setupInfiniteScrollView()
    {
        // Set a content size that is 3 times the width of the scroll view, and equal height
        // NOTE: The width doesn't really matter, it can be as big as we want because
        // we won't ever be filling it's entire content.
        self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3.0, CGRectGetHeight(self.bounds))
        
        // Disable the scroll indicators
        self.showsVerticalScrollIndicator = false
        //self.showsHorizontalScrollIndicator = false
        
        // Enable paging on the scroll view
        self.pagingEnabled = true
        
        // Disable bouncing on the scroll view
        self.bounces = false
        
        // Initialize the content view
        let contentView = UIView(frame: CGRectMake(0.0, 0.0, self.contentSize.width, self.contentSize.height))
        
        // Add the content view as a subview of the scroll view
        self.addSubview(contentView)
        
        // Set the content view to its variable
        self.contentView = contentView
        
        // Set the delegate of the scroll view
        self.delegate = self
        
        self.leftViewFrame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        self.centerViewFrame = CGRectMake(CGRectGetWidth(self.bounds), 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
        self.rightViewFrame = CGRectMake(CGRectGetWidth(self.bounds) * 2.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
    }
    
    
    // MARK: - Instance Methods
    
    func setItems(items: [UIView])
    {
        // Reference the items
        self.internalItems = items
        
        // Set the current page
        self.currentPage = 0
        
        // Center the content view on the middle page
        self.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), self.contentOffset.y)
        
        // Update the pages
        self.updatePagingIfNeeded()
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
    
    
    private func updatePagingIfNeeded()
    {
        // Get the item for our current page
        
        let leftView = (self.currentPage > 0) ? self.internalItems[self.currentPage - 1] : self.internalItems.last!

        
        let centerView = self.internalItems[self.currentPage]
        
        let rightView = (self.currentPage < self.internalItems.count - 1) ? self.internalItems[self.currentPage + 1] : self.internalItems[0]

        
        leftView.frame = self.leftViewFrame
        centerView.frame = self.centerViewFrame
        rightView.frame = self.rightViewFrame
        
        
        // Remove all the views from the content view
        for view in self.visibleItems
        {
            view.removeFromSuperview()
        }
        
        // Remove all the visible items
        self.visibleItems.removeAll()
        
        self.contentView?.addSubview(leftView)
        self.contentView?.addSubview(centerView)
        self.contentView?.addSubview(rightView)
        
        self.visibleItems.append(leftView)
        self.visibleItems.append(centerView)
        self.visibleItems.append(rightView)
        
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
