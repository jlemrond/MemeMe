//
//  FontManagerViewController.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/5/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import UIKit

class FontManagerViewController: UIViewController {
  
  @IBOutlet weak var fontManagerStackView: UIStackView!
  var contentSize = CGSize?()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if contentSize == nil {
      // Sets the size of the popover frame to be the size of the 
      // contents within + room for margins.
      
      contentSize = fontManagerStackView.sizeThatFits(fontManagerStackView.bounds.size)
      
      guard let contentSize = contentSize else {
        print("Content Size not available.")
        return
      }
      
      let popoverHeight = contentSize.height + 40
      let popoverWidth = contentSize.width + 50
      self.preferredContentSize = CGSize(width: popoverWidth, height: popoverHeight)
      print("Popover view sized to fit content.")
    }
  }

}
