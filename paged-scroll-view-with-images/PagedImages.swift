//
//  PagedScrollViewWithImages.swift
//  paged-scroll-view-with-images
//
//  Created by Evgenii Neumerzhitckii on 24/11/2014.
//  Copyright (c) 2014 The Exchange Group Pty Ltd. All rights reserved.
//

import UIKit

class PagedImages {
  class func loadImage(image: UIImage, scrollView: UIScrollView, imageSize: CGSize) {
    let cell = addCell(scrollView, imageSize: imageSize)
    cell.showImage(image)
  }
  
  class func addUrl(url: String, scrollView: UIScrollView, imageSize: CGSize) {
    let cell = addCell(scrollView, imageSize: imageSize)
    cell.url = url
  }
  
  private class func addCell(scrollView: UIScrollView, imageSize: CGSize) -> PagedImagesCellView {
    let cellFrame = CGRect(
      origin: CGPoint(x: contentRightEdge(scrollView), y:0),
      size: imageSize
    )
    
    let cell = PagedImagesCellView(frame: cellFrame)
    scrollView.addSubview(cell)
    updateScrollViewContentSize(scrollView)
    return cell
  }

  private class func updateScrollViewContentSize(scrollView: UIScrollView) {
    var rightEdge = contentRightEdge(scrollView)

    if rightEdge == 0 { return }

    scrollView.contentSize = CGSize(
      width: rightEdge,
      height: scrollView.bounds.height)
  }
  
  private class func contentRightEdge(scrollView: UIScrollView) -> CGFloat {
    var rightEdge: CGFloat = 0
    
    for view in scrollView.subviews {
      if let cellView = view as? PagedImagesCellView {
        let viewsRightEdge = cellView.frame.origin.x + cellView.frame.width
        if viewsRightEdge > rightEdge {
          rightEdge = viewsRightEdge
        }
      }
    }
    
    return rightEdge
  }
}