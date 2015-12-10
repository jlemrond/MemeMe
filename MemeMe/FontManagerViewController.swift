//
//  FontManagerViewController.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/5/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import UIKit

class FontManagerViewController: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
  
  
  // ******************************************************************
  //   MARK: Global Variables / IBOutlets
  // ******************************************************************
  
  @IBOutlet weak var fontLabel: UILabel!
  @IBOutlet weak var fontType: UIButton!
  @IBOutlet weak var fontScrollView: UIScrollView!
  @IBOutlet weak var fontConstraint: NSLayoutConstraint!
  @IBOutlet weak var applyFontChangesButton: UIButton!
  
  let textDelegate = textFieldDelegate()
  var delegate = FontManagerViewControllerDelegate?()
  var oldFontFamiliy = String()
  
  let fonts = FontModel.all()
  var fontManagerWidth: CGFloat!
  var containerWidth: CGFloat!
  let containerView = UIView()
  var fontScrollOffset: CGFloat = 0
  var contentSize = CGSize?()
  var newFontAttributes = [String: NSObject]?()
  var fontOrigin = CGPoint()
  
  
  
  
  // ******************************************************************
  //   MARK: UIView methods
  // ******************************************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fontManagerWidth = 212
    fontScrollOffset = offsetFontScroll(oldFontFamiliy)
    addButtonsToScrollView()
    
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    guard contentSize == nil else {
      // Check that popover view has not already been sized.
      return
    }
    
    sizePopoverView()
    
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Button Action Methods
  // ******************************************************************
  
  
  @IBAction func applyFontChanges(sender: UIButton) {
    // Utilize FontManager Protocoll to transfer data to the main
    // View Controller.
    
    guard let delegate = delegate else {
      print("Delegate is nil")
      return
    }
    
    if let newFontAttributes = newFontAttributes {
       delegate.changeFontAttributes(newFontAttributes)
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func selectFontType(sender: UIButton) {
    
    fontType.hidden = true
  
    expandFontScrollView(120, colapse: false)
    
  }
  
  func selectFont(sender: UIButton) {
    
    guard let newFont = sender.titleLabel?.text else {
      return
    }
    
    newFontAttributes = [
      NSStrokeColorAttributeName : UIColor.blackColor(),
      NSForegroundColorAttributeName : UIColor.whiteColor(),
      NSFontAttributeName : UIFont(name: newFont, size: 40)!,
      NSStrokeWidthAttributeName : "-4.0",
    ]
    
    fontScrollOffset = offsetFontScroll(newFont)
    
    fontType.hidden = false
    expandFontScrollView(-120, colapse: true)
    
  }
  
  
  
  // ******************************************************************
  //   MARK: Animation Methods
  // ******************************************************************
  
  func expandFontScrollView(distance: CGFloat, colapse: Bool) {
    // Animation to expand the scrollView in order to select fonts or resize
    // to normal once font has been selected.
    
    var scrollContentOffset: CGFloat = 0
    let currentScrollViewHeight = self.fontScrollView.frame.height
    
    if (fontScrollOffset * -1) >= CGFloat((fonts.count * 30) - 60) {
      scrollContentOffset = CGFloat((fonts.count * 30) - 150)
    } else if (fontScrollOffset * -1) <= 60 {
      scrollContentOffset = 0
    } else {
      scrollContentOffset = (fontScrollOffset * -1) - 60
    }
    
    UIView.animateWithDuration(0.6, animations: { () -> Void in
      
      self.fontScrollView.frame = CGRect(x: self.fontOrigin.x, y: self.fontOrigin.y, width: self.containerWidth, height: currentScrollViewHeight + distance)
      
      if !colapse {
        self.fontScrollView.setContentOffset(CGPoint(x: 0, y: scrollContentOffset), animated: true)
      }
      self.fontConstraint.constant = currentScrollViewHeight + distance
      
      self.applyFontChangesButton.frame = self.applyFontChangesButton.moveVertically(distance)
      self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + distance)
      
      print("fontSrollOffset: \(self.fontScrollOffset)")
      if colapse {
        print("Index is nil")
        print(self.containerView.frame)
        self.containerView.frame = CGRect(x: self.fontOrigin.x, y: self.fontOrigin.y + self.fontScrollOffset + self.fontScrollView.contentOffset.y, width: self.containerWidth, height: CGFloat(30 * self.fonts.count))
      } else {
        print("not so much")
        self.containerView.frame = CGRect(x: self.fontOrigin.x, y: self.fontOrigin.y, width: self.containerView.frame.width, height: self.containerView.frame.height)
      }
      
      self.view.layoutIfNeeded()
      
      }, completion: nil
    )
  }
  
  
  
  // ******************************************************************
  //   MARK: Set Up UI Methods
  // ******************************************************************
  
  func sizePopoverView() {
    // Set the size of the popover frame to be the size of the
    // contents within plus room for margins.
    
    let popoverHeight = fontLabel.frame.size.height + fontScrollView.frame.size.height + applyFontChangesButton.frame.size.height + (8 * 6)
    let popoverWidth = fontManagerWidth
    contentSize = CGSize(width: popoverWidth, height: popoverHeight)
    
    guard let contentSize = contentSize else {
      print("Content Size not available.")
      return
    }

    self.preferredContentSize = contentSize
    print("Font Manager popover view did size")
    print(view.bounds)
    print(fontLabel.frame)
    
  }
  
  func addButtonsToScrollView() {
    //Create a font button for each font available to the user.
    
    fontScrollView.contentSize = CGSize(width: fontLabel.frame.size.width, height: CGFloat(30 * fonts.count))
    containerView.frame = fontScrollView.bounds
    fontScrollView.addSubview(containerView)
    
    fontOrigin = CGPoint(x: CGRectGetMinX(containerView.frame), y: CGRectGetMinY(containerView.frame))
    containerWidth = containerView.frame.size.width
    
    // Create each button.  Change each font to display the respective font.
    for (index, font) in fonts.enumerate() {
      let button = UIButton()
      button.setTitle(font.name, forState: .Normal)
      button.setTitleColor(UIColor.blackColor(), forState: .Normal)
      button.titleLabel?.font = UIFont(name: font.name, size: 12)
      button.addTarget(self, action: "selectFont:", forControlEvents: .TouchUpInside)
      containerView.addSubview(button)
      
      button.frame = CGRect(x: CGRectGetMinX(containerView.frame), y: CGRectGetMinY(containerView.frame) + CGFloat(30 * index), width: containerView.frame.size.width, height: 30)
    }
    
    // Ensure containerView has the correct frame with offset to display current font.
    containerView.frame = CGRect(x: fontOrigin.x, y: fontOrigin.y + fontScrollOffset, width: containerWidth, height: CGFloat(30 * fonts.count))
  }
  
  func offsetFontScroll(fontFamily: String?) -> CGFloat {
    // Establish the amount the ScrollView will need to be offset
    // in order to display the correct current font at load time.
    
    guard let fontFamily = fontFamily else {
      return 0
    }
    
    for (index, value) in fonts.enumerate() {
      if value.name == fontFamily {
        return CGFloat(index * -30)
      }
    }
    
    return 0
    
  }
  
  
}




// ******************************************************************
//   MARK: Font Manager VC Delegate
// ******************************************************************

protocol FontManagerViewControllerDelegate {
  
  func changeFontAttributes (var fontAttributes: [String: NSObject])
  
}


// ******************************************************************
//   MARK: UIView Extension Methods
// ******************************************************************

extension UIView {
  
  func moveVertically (distance: CGFloat) -> CGRect {
    return CGRect(x: CGRectGetMinX(self.frame), y: CGRectGetMinY(self.frame) + distance, width: self.frame.size.width, height: self.frame.size.height)
  }
  
}

