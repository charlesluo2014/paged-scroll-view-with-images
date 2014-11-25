//
//  PagedStoryboardObject.swift
//  paged-scroll-view-with-images
//
//  Created by Evgenii Neumerzhitckii on 24/11/2014.
//  Copyright (c) 2014 The Exchange Group Pty Ltd. All rights reserved.
//

import UIKit

class YiiPagedImages: NSObject, UIScrollViewDelegate {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!

  var placeholderImageName = "paged-scroll-view-with-images-placeholder.jpg"

  deinit {
    cancelImageDownloads()
  }
  
  func setup() {
    scrollView.delegate = self
    pageControl.backgroundColor = nil
  }

  func load(image: UIImage) {
    TegPagedImages.loadImage(image, scrollView: scrollView, imageSize: imageSize)
    updateNumberOfPages()
  }

  func addUrl(url: String) {
    TegPagedImages.addUrl(url, scrollView: scrollView, imageSize: imageSize,
      placeholderImage: placeholderImage)

    updateNumberOfPages()
  }

  private var imageSize: CGSize {
    scrollView.layoutIfNeeded()
    return scrollView.bounds.size
  }

  private var placeholderImage: UIImage? {
    return UIImage(named: placeholderImageName)
  }

  private func updateNumberOfPages() {
    let numberOfPages = scrollView.subviews.count
    pageControl.numberOfPages = numberOfPages
  }

  private func updateCurrentPage() {
    let xOffset = scrollView.contentOffset.x
    let currentPage = Int(xOffset / scrollView.frame.size.width)
    pageControl.currentPage = currentPage
  }

  private func notifyCellAboutTheirVisibility() {
    for cell in cellViews {
      if TegPagedImages.subviewVisible(scrollView, subview: cell) {
        cell.cellIsVisible()
      } else {
        if !TegPagedImages.isSubviewNearScreenEdge(scrollView, subview: cell) {
          // Do not send 'invisible' message to cell if it is still nearby
          // This prevents cancelling download for the cell that was shown for a moment
          // with spring animation
          cell.cellIsInvisible()
        }
      }
    }
  }
  
  private func cancelImageDownloads() {
    for cell in cellViews {
      cell.cancelImageDownload()
    }
  }
  
  private var cellViews: [TegPagedImagesCellView] {
    return scrollView.subviews.filter { return $0 is TegPagedImagesCellView }.map { $0 as TegPagedImagesCellView }
  }
}

// UIScrollViewDelegate
// --------------------------

typealias UIScrollViewDelegate_implementation = YiiPagedImages

extension UIScrollViewDelegate_implementation {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    updateCurrentPage()
    notifyCellAboutTheirVisibility()
  }
}
