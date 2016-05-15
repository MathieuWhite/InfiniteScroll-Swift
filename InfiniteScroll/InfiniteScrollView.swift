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
class InfiniteScrollView: UIScrollView
{
    // MARK: - Variables
    
    var views: [UIView]?
    
    var contentView: UIView?
        
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
        
        self.pagingEnabled = true
        
        // Initialize the content view
        let contentView = UIView(frame: CGRectMake(0.0, 0.0, self.contentSize.width, self.contentSize.height))
        
        // Add the content view as a subview of the scroll view
        self.addSubview(contentView)
        
        // Set the content view to its variable
        self.contentView = contentView
    }
    
    
    // MARK: - Instance Methods
 
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        // Called at every frame of scrolling
        self.recenterIfNecessary()
    }
    
    
    func setItems(items: [UIView])
    {
        if let views = self.views
        {
            for view in views
            {
                view.removeFromSuperview()
            }
        }
        
        items[0].frame = self.bounds
        items[0].frame.origin.x = CGRectGetWidth(self.bounds)
        
        items[1].frame = self.bounds
        items[1].frame.origin.x = CGRectGetWidth(self.bounds) * 2.0
        
        items[2].frame = self.bounds
        items[2].frame.origin.x = 0.0
        
        self.contentView?.addSubview(items[0])
        self.contentView?.addSubview(items[1])
        self.contentView?.addSubview(items[2])

        
        self.views = items
        
        self.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), self.contentOffset.y)
    }
    
    
    // MARK: - Layout Methods
    
    /**
     This method recenters the scroll view's content size if necessary. 
     The recentering occurs if the offset ends up at the edge of the content.
     */
    func recenterIfNecessary()
    {
        // Get the current offset of the content
        let currentOffset = self.contentOffset
        
        // Get the width of the content
        let contentWidth = self.contentSize.width
        
        // Calculate the x offset that gets the center point of where the content should be
        let centerOffsetX = (contentWidth - CGRectGetWidth(self.bounds)) / 2.0
        
        // Get our current distance (where we are now) from the center (where we want to be)
        let distanceFromCenter = fabs(currentOffset.x - centerOffsetX)
        
        // If the distance from the center is far enough, re center the content size
        // This distance is also arbitrary, it can be anything. The smaller the distance
        // the more recentering occurs. Half the content width should be good enough.
        if (distanceFromCenter > (contentWidth / 3.0))
        {
            self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y)
            
            // TODO: something with the views here?
        }
    }

}
