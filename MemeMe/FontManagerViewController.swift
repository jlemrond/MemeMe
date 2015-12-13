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
  @IBOutlet weak var colorLabel: UILabel!
  @IBOutlet weak var colorButton: UIButton!
  @IBOutlet weak var colorView: UIView!
  @IBOutlet weak var colorConstraint: NSLayoutConstraint!
  
  
  let textDelegate = textFieldDelegate()
  var delegate = FontManagerViewControllerDelegate?()
  var fontFamilyName = String()
  var oldFontColor = UIColor()
  
  let fonts = FontModel.all()
  var fontManagerWidth: CGFloat!
  var containerWidth: CGFloat!
  let containerView = UIView()
  var fontScrollOffset: CGFloat = 0
  var contentSize = CGSize?()
  var newFontAttributes = [String: NSObject]?()
  var fontOrigin = CGPoint()
  var colorContainer = UIView()
  var colorSliders: [String: UISlider?] = ["Red": nil, "Green": nil, "Blue": nil]
  
  
  
  
  // ******************************************************************
  //   MARK: UIView methods
  // ******************************************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fontManagerWidth = 212
    fontScrollOffset = offsetFontScroll(fontFamilyName)
    addButtonsToScrollView()
    addSlidersToColorView()
    
    view.backgroundColor = ProjectColors.getNavyColor()
    fontLabel.backgroundColor = ProjectColors.getNavyColor()
    fontLabel.textColor = ProjectColors.getYellowColor()
    colorLabel.backgroundColor = ProjectColors.getNavyColor()
    colorLabel.textColor = ProjectColors.getYellowColor()
    colorView.backgroundColor = ProjectColors.getNavyColor()
    applyFontChangesButton.backgroundColor = ProjectColors.getOrangeColor()
    applyFontChangesButton.setTitleColor(ProjectColors.getNavyColor(), forState: .Normal)
    applyFontChangesButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
    applyFontChangesButton.setTitle("APPLY FONT CHANGES", forState: .Normal)
    applyFontChangesButton.layer.borderWidth = 2.0
    applyFontChangesButton.layer.borderColor = ProjectColors.getBlueColor().CGColor
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
    
    defer { self.dismissViewControllerAnimated(true, completion: nil) }
    
    guard let delegate = delegate else {
      print("Delegate is nil")
      return
    }
    
    guard let fontColor = colorButton.backgroundColor else {
      return
    }
    
    newFontAttributes = [
      NSStrokeColorAttributeName : UIColor.blackColor(),
      NSForegroundColorAttributeName : fontColor,
      NSFontAttributeName : UIFont(name: fontFamilyName, size: 40)!,
      NSStrokeWidthAttributeName : "-4.0",
    ]
    
    if let newFontAttributes = newFontAttributes {
      delegate.changeFontAttributes(newFontAttributes)
    }
    
  }
  
  @IBAction func selectFontType(sender: UIButton) {
    
    if Int(colorView.frame.size.height) > 10 {
      expandColorView(-80, colapse: true)
    }
    
    expandFontScrollView(80, colapse: false)
    
  }
  
  func selectedFont(sender: UIButton) {
    
    guard let newFont = sender.titleLabel?.font.fontName else {
      return
    }
    
    fontFamilyName = newFont
    
    fontScrollOffset = offsetFontScroll(fontFamilyName)
    expandFontScrollView(-80, colapse: true)
    
    print("Font Selected: \(fontFamilyName)")
    
  }
  
  @IBAction func expandColorSelectionTool(sender: UIButton) {
    
    if Int(fontScrollView.frame.size.height) > 45 {
      expandFontScrollView(-80, colapse: true)
    }

    if Int(colorView.frame.size.height) < 30 {
      expandColorView(80, colapse: false)
    } else {
      expandColorView(-80, colapse: true)
    }
    
  }
  
  func changeButtonColor() {
    
    let red = CGFloat(colorSliders["Red"]!!.value / 255.0)
    let green = CGFloat(colorSliders["Green"]!!.value / 255.0)
    let blue = CGFloat(colorSliders["Blue"]!!.value / 255.0)
    
    colorButton.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Animation Methods
  // ******************************************************************
  
  func expandFontScrollView(distance: CGFloat, colapse: Bool) {
    // Animation to expand the scrollView in order to select fonts or resize
    // to normal once font has been selected.
    
    // Hide overlay button while scrollView is expanded.
    fontType.hidden = !colapse
    
    var scrollContentOffset: CGFloat = 0
    let currentScrollViewHeight = self.fontScrollView.frame.height
    
    UIView.animateWithDuration(0.6, animations: { () -> Void in
      
      
      self.fontConstraint.constant = currentScrollViewHeight + distance
      self.fontScrollView.frame = CGRect(x: self.fontOrigin.x, y: self.fontOrigin.y, width: self.containerWidth, height: currentScrollViewHeight + distance)
      self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + distance)
      
      if colapse {
        self.containerView.frame = CGRect(x: self.fontOrigin.x, y: self.fontOrigin.y + self.fontScrollOffset + self.fontScrollView.contentOffset.y, width: self.containerWidth, height: CGFloat(30 * self.fonts.count))
      } else {
        if (-self.fontScrollOffset) >= CGFloat((self.fonts.count * 30) - 40) {
          scrollContentOffset = CGFloat((self.fonts.count * 30) - 110)
        } else if (-self.fontScrollOffset) <= 59 {
          scrollContentOffset = 0
        } else {
          scrollContentOffset = (-self.fontScrollOffset) - 40
        }
        
        self.fontScrollView.setContentOffset(CGPoint(x: 0, y: scrollContentOffset), animated: true)
        
        self.containerView.frame = CGRect(x: self.fontOrigin.x, y: self.fontOrigin.y, width: self.containerView.frame.width, height: self.containerView.frame.height)
      }
      
      self.view.layoutIfNeeded()
      
      }, completion: nil
    )
  }
  
  func expandColorView(distance: CGFloat, colapse: Bool) {
    // Expand and colapse the view containing the Color Changer Sliders.
    
    let currentColorViewHeight = colorView.frame.size.height
    let currentButtonOrigin = CGPoint(x: CGRectGetMinX(applyFontChangesButton.frame), y: CGRectGetMinY(applyFontChangesButton.frame))
    
    UIView.animateWithDuration(0.6, animations: {
      
      self.colorConstraint.constant = currentColorViewHeight + distance
      self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height + distance)
      self.applyFontChangesButton.frame.origin = CGPoint(x: currentButtonOrigin.x, y: currentButtonOrigin.y + distance)
    })
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Set Up UI Methods
  // ******************************************************************
  
  func sizePopoverView() {
    // Set the size of the popover frame to be the size of the
    // contents within plus room for margins.
    
    let popoverHeight = fontLabel.frame.size.height + fontScrollView.frame.size.height + applyFontChangesButton.frame.size.height + colorLabel.frame.size.height + colorButton.frame.size.height + colorView.frame.size.height + (8 * 4)
    let popoverWidth = fontManagerWidth
    contentSize = CGSize(width: popoverWidth, height: popoverHeight)
    
    guard let contentSize = contentSize else {
      print("Content Size not available.")
      return
    }

    self.preferredContentSize = contentSize
    print("Font Manager popover view did size")
    
  }
  
  func addButtonsToScrollView() {
    //Create a font button for each font available to the user.
    
    fontScrollView.layer.borderWidth = 2.0
    fontScrollView.layer.borderColor = ProjectColors.getBlueColor().CGColor
    fontScrollView.contentSize = CGSize(width: fontLabel.frame.size.width, height: CGFloat(30 * fonts.count))
    
    containerView.frame = fontScrollView.bounds
    fontScrollView.addSubview(containerView)
    
    fontOrigin = CGPoint(x: CGRectGetMinX(containerView.frame), y: CGRectGetMinY(containerView.frame))
    containerWidth = containerView.frame.size.width
    
    // Create each button.  Change each font to display the respective font.
    for (index, font) in fonts.enumerate() {
      let button = UIButton()
      button.setTitle(font.name, forState: .Normal)
      button.setTitleColor(ProjectColors.getNavyColor(), forState: .Normal)
      button.titleLabel?.font = UIFont(name: font.fontFamily, size: 12)
      button.addTarget(self, action: "selectedFont:", forControlEvents: .TouchUpInside)
      //button.backgroundColor = ProjectColors.getIvoryColor()
      containerView.addSubview(button)
      button.frame = CGRect(x: CGRectGetMinX(containerView.frame), y: CGRectGetMinY(containerView.frame) + CGFloat(30 * index), width: containerView.frame.size.width, height: 30)
    }
    
    // Ensure containerView has the correct frame with offset to display current font.
    containerView.frame = CGRect(x: fontOrigin.x, y: fontOrigin.y + fontScrollOffset, width: containerWidth, height: CGFloat(30 * fonts.count))
  }
  
  func offsetFontScroll(fontFamily: String?) -> CGFloat {
    // Establish the amount the ScrollView will need to be offset
    // in order to display the correct current font at while colapsed.
    
    guard let fontFamily = fontFamily else {
      return 0
    }
    
    for (index, value) in fonts.enumerate() {
      if value.fontFamily == fontFamily {
        return CGFloat(index * -30)
      }
    }
    
    return 0
  }
  
  
  func addSlidersToColorView() {
    // Create three sliders to change the RGB paramaters of the font.
    
    colorView.clipsToBounds = true
    colorButton.layer.borderWidth = 2.0
    colorButton.layer.borderColor = ProjectColors.getBlueColor().CGColor
    colorButton.backgroundColor = oldFontColor
    
    for (color, _) in colorSliders {
      var sliderOrigin: CGPoint?
      colorSliders[color] = UISlider()
      
      guard let currentButtonColor: UIColor = colorButton.backgroundColor else {
        return
      }
      
      //TODO: Look at this optional binding.
      //      Can you remove the dictionary and just use regular sliders similar
      //      to fontScrollView?
      guard let slider = colorSliders[color] else {
        break
      }
      guard let colorSlider = slider else {
        break
      }
    
      colorSlider.minimumValue = 0
      colorSlider.maximumValue = 255
      
      switch color {
        case "Red":
          sliderOrigin = CGPoint(x: 8, y: 20)
          colorSlider.minimumTrackTintColor = UIColor.redColor()
          colorSlider.value = Float(currentButtonColor.red()) * 255
        case "Green":
          sliderOrigin = CGPoint(x: 8, y: 52)
          colorSlider.minimumTrackTintColor = UIColor.greenColor()
          colorSlider.value = Float(currentButtonColor.green() * 255)
        case "Blue":
          sliderOrigin = CGPoint(x: 8, y: 84)
          colorSlider.minimumTrackTintColor = UIColor.blueColor()
          colorSlider.value = Float(currentButtonColor.blue() * 255)
      default: break
      }

      let sliderSize = CGSize(width: colorView.frame.size.width - 16, height: 16)
      
      colorSlider.frame = CGRect(origin: sliderOrigin!, size: sliderSize)
      colorSlider.addTarget(self, action: "changeButtonColor", forControlEvents: .ValueChanged)
      colorView.addSubview(colorSlider)
    }
  }

}  // FontManagerViewController End




// ******************************************************************
//   MARK: Font Manager VC Delegate
// ******************************************************************

protocol FontManagerViewControllerDelegate {
  
  func changeFontAttributes (var fontAttributes: [String: NSObject])
  
}



// ******************************************************************
//   MARK: UIColor Extension
// ******************************************************************


extension UIColor {
  // Color functions to gain access to float numbers for Red, Green, Blue and Alpha.
  
  func getRGBComponents() -> [CGFloat] {
    // Create array that contains RGB components of a UIColor.
    
    var colorDescription = self.description
    colorDescription = colorDescription.stringByReplacingOccurrencesOfString("UIDeviceRGBColorSpace ", withString: "")
    var colorArray: [String] = [colorDescription]
    colorArray = colorArray[0].componentsSeparatedByString(" ")
    var rgbArray = [CGFloat]()
    
    for index in colorArray {
      guard let value = Float(index) else {
        break
      }
      rgbArray.append(CGFloat(value))
    }
  
    return rgbArray
  }
  
  // Get the individual components.
  func red() -> CGFloat {
    return self.getRGBComponents()[0]
  }
  
  func green() -> CGFloat {
    return self.getRGBComponents()[1]
  }
  
  func blue() -> CGFloat {
    return self.getRGBComponents()[2]
  }
  
  func alpha() -> CGFloat {
    return self.getRGBComponents()[3]
  }
  
}
