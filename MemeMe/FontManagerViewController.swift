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
  
  
  let textDelegate   = textFieldDelegate()
  var delegate       = FontManagerViewControllerDelegate?()
  var fontFamilyName = String()
  var oldFontColor   = UIColor()
  
  let fonts             = FontModel.all()
  var fontManagerWidth:   CGFloat!
  var containerWidth:     CGFloat!
  let containerView     = UIView()
  var fontScrollOffset:   CGFloat = 0
  var contentSize       = CGSize?()
  var newFontAttributes = [String: NSObject]?()
  var fontOrigin        = CGPoint()
  var colorContainer    = UIView()
  var colorSliders: [String: RGBSliders] = ["Red": RGBSliders(), "Green": RGBSliders(), "Blue": RGBSliders()]
  
  
  
  
  // ******************************************************************
  //   MARK: UIView methods
  // ******************************************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fontManagerWidth = 212
    fontScrollOffset = offsetFontScroll(fontFamilyName)
    addButtonsToScrollView()
    addSlidersToColorView()
    
    view.layer.shadowColor = UIColor.blackColor().CGColor
    view.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    view.layer.shadowOpacity = 0.4
    view.layer.shadowRadius = 5.0
    
    view.backgroundColor      = ProjectColors.background
    colorView.backgroundColor = ProjectColors.background
    
    for label in [fontLabel, colorLabel] {
      label.font            = UIFont(name: "AppleSDGothicNeo-Medium", size: 10)
      label.backgroundColor = ProjectColors.background
      label.textColor       = ProjectColors.secondAccent
    }
    
    applyFontChangesButton.backgroundColor    = ProjectColors.secondAccent
    applyFontChangesButton.layer.cornerRadius = 3.0
    applyFontChangesButton.titleLabel?.font   = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
    applyFontChangesButton.setTitle("APPLY", forState: .Normal)
    applyFontChangesButton.setTitleColor(ProjectColors.background, forState: .Normal)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // Check that popover view has not already been sized
    guard contentSize == nil
      else { return }
    
    sizePopoverView()
  }

  
  
  
  // ******************************************************************
  //   MARK: Button Action Methods
  // ******************************************************************
  
  /// Utilize FontManager Protocoll to transfer data to the main
  /// View Controller
  @IBAction func applyFontChanges(sender: UIButton) {
    
    defer { self.dismissViewControllerAnimated(true, completion: nil) }
    
    guard let delegate = delegate else {
      print("Delegate is nil")
      return
    }
    
    guard let fontColor = colorButton.backgroundColor
      else { return }
    
    newFontAttributes = [
      NSStrokeColorAttributeName     : UIColor.blackColor(),
      NSForegroundColorAttributeName : fontColor,
      NSFontAttributeName            : UIFont(name: fontFamilyName, size: 40)!,
      NSStrokeWidthAttributeName     : "-4.0",
    ]
    
    if let newFontAttributes = newFontAttributes {
      delegate.changeFontAttributes(newFontAttributes)
    }
  }
  
  @IBAction func selectFontType(sender: UIButton) {
    
    if Int(colorView.frame.size.height) > 10 {
      expandColorView(-120, colapse: true)
    }
    
    expandFontScrollView(120, colapse: false)
    
  }
  
  func selectedFont(sender: UIButton) {
    
    guard let newFont = sender.titleLabel?.font.fontName
      else { return }
    
    fontFamilyName = newFont
    
    fontScrollOffset = offsetFontScroll(fontFamilyName)
    expandFontScrollView(-120, colapse: true)
    
    print("Font Selected: \(fontFamilyName)")
    
  }
  
  @IBAction func expandColorSelectionTool(sender: UIButton) {
    
    if Int(fontScrollView.frame.size.height) > 45 {
      expandFontScrollView(-120, colapse: true)
    }

    if Int(colorView.frame.size.height) < 30 {
      expandColorView(120, colapse: false)
    } else {
      expandColorView(-120, colapse: true)
    }
    
  }
  
  func changeButtonColor() {
    
    guard let redSlider   = colorSliders["Red"],
              greenSlider = colorSliders["Green"],
              blueSlider  = colorSliders["Blue"]
      else { return }
    
    let red   = CGFloat(redSlider.value   / 255.0)
    let green = CGFloat(greenSlider.value / 255.0)
    let blue  = CGFloat(blueSlider.value  / 255.0)
    
    colorButton.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Animation Methods
  // ******************************************************************
  
  /// Animaiton to expand the scroll view to select the desired font, or
  /// colapse the view once font is selected.
  func expandFontScrollView(distance: CGFloat, colapse: Bool) {
    
    // Hide overlay button while scrollView is expanded.
    fontType.hidden = !colapse
    
    var scrollContentOffset: CGFloat = 0
    let currentScrollViewHeight = self.fontScrollView.frame.height
    
    UIView.animateWithDuration(0.6, animations: { () -> Void in
    
      self.fontConstraint.constant = currentScrollViewHeight + distance
      self.fontScrollView.frame.size.height = CGFloat(currentScrollViewHeight + distance)
      self.preferredContentSize = CGSize(width: self.view.frame.size.width,
                                        height: self.view.frame.size.height + distance)
      
      if colapse {
        self.containerView.frame = CGRect(x: self.fontOrigin.x,
                                          y: self.fontOrigin.y + self.fontScrollOffset + self.fontScrollView.contentOffset.y,
                                      width: self.containerWidth,
                                     height: CGFloat(30 * self.fonts.count))
      } else {
        
        if -self.fontScrollOffset >= CGFloat((self.fonts.count * 30) - 60) {
          scrollContentOffset = CGFloat((self.fonts.count * 30) - 110)
        } else if (-self.fontScrollOffset) <= 60 {
          scrollContentOffset = 0
        } else {
          scrollContentOffset = (-self.fontScrollOffset) - 60
        }
        
        self.fontScrollView.setContentOffset(CGPoint(x: 0, y: scrollContentOffset), animated: true)
        
        self.containerView.frame = CGRect(x: self.fontOrigin.x,
                                          y: self.fontOrigin.y,
                                      width: self.containerView.frame.width,
                                     height: self.containerView.frame.height)
      }
      
      self.view.layoutIfNeeded()
      
      }, completion: nil
    )
  }
  
  /// Expand and colapse the view containing the Color Changer Sliders.
  func expandColorView(distance: CGFloat, colapse: Bool) {
    
    let currentColorViewHeight = colorView.frame.size.height
    let currentButtonOrigin = CGPoint(x: CGRectGetMinX(applyFontChangesButton.frame), y: CGRectGetMinY(applyFontChangesButton.frame))
    
    UIView.animateWithDuration(0.6, animations: {
      self.colorConstraint.constant = currentColorViewHeight + distance
      self.preferredContentSize = CGSize(width: self.view.frame.size.width,
                                        height: self.view.frame.size.height + distance)
      self.applyFontChangesButton.frame.origin = CGPoint(x: currentButtonOrigin.x,
                                                         y: currentButtonOrigin.y + distance)
    })
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Set Up UI Methods
  // ******************************************************************
  
  /// Set the size of the popover frame to be the size of the
  /// contents within plus room for margins.
  func sizePopoverView() {
    
    let popoverHeight = fontLabel.frame.size.height +
                        fontScrollView.frame.size.height +
                        applyFontChangesButton.frame.size.height +
                        colorLabel.frame.size.height +
                        colorButton.frame.size.height +
                        colorView.frame.size.height + 44
    let popoverWidth = fontManagerWidth
    contentSize = CGSize(width: popoverWidth, height: popoverHeight)
    
    guard let contentSize = contentSize else {
      print("Content Size not available.")
      return
    }

    self.preferredContentSize = contentSize
    print("Font Manager popover view did size")
    
  }
  
  /// Create a font button for each font available to the user.
  func addButtonsToScrollView() {
    
    fontScrollView.contentSize = CGSize(width: fontLabel.frame.size.width,
                                        height: CGFloat(30 * fonts.count))
    fontScrollView.layer.cornerRadius = 3.0
    
    containerView.frame = fontScrollView.bounds
    fontScrollView.addSubview(containerView)
    
    fontOrigin = CGPoint(x: CGRectGetMinX(containerView.frame),
                         y: CGRectGetMinY(containerView.frame))
    containerWidth = containerView.frame.size.width
    
    // Create each button.  Change each font to display the respective font.
    for (index, font) in fonts.enumerate() {
      let button = UIButton()
      button.setTitle(font.name, forState: .Normal)
      button.setTitleColor(ProjectColors.background, forState: .Normal)
      button.titleLabel?.font = UIFont(name: font.fontFamily, size: 12)
      button.addTarget(self, action: #selector(FontManagerViewController.selectedFont(_:)), forControlEvents: .TouchUpInside)
      containerView.addSubview(button)
      
      button.frame = CGRect(x: CGRectGetMinX(containerView.frame),
                            y: CGRectGetMinY(containerView.frame) + CGFloat(30 * index),
                        width: containerView.frame.size.width,
                       height: 30)
    }
    
    // Ensure containerView has the correct frame with offset to display current font.
    containerView.frame = CGRect(x: fontOrigin.x,
                                 y: fontOrigin.y + fontScrollOffset,
                             width: containerWidth,
                            height: CGFloat(30 * fonts.count))
  }
  
  ///  Establish the amount the ScrollView will need to be offset
  ///  in order to display the correct current font while colapsed
  func offsetFontScroll(fontFamily: String?) -> CGFloat {
    
    guard let fontFamily = fontFamily
      else { return 0 }
    
    for (index, value) in fonts.enumerate() {
      if value.fontFamily == fontFamily {
        return CGFloat(index * -30)
      }
    }
    
    return 0
  }
  
  /// Create three sliders to change the RGB paramaters of the font
  func addSlidersToColorView() {
    
    colorView.clipsToBounds        = true
    colorButton.backgroundColor    = oldFontColor
    colorButton.layer.cornerRadius = 3.0
    
    for (color, _) in colorSliders {
      var sliderOrigin: CGPoint?
      colorSliders[color] = RGBSliders()
      
      guard let currentButtonColor = colorButton.backgroundColor,
                colorSlider = colorSliders[color]
        else { return }
    
      colorSlider.minimumValue = 0
      colorSlider.maximumValue = 255
      
      switch color {
        case "Red":
          sliderOrigin                      = CGPoint(x: 8, y: 20)
          colorSlider.minimumTrackTintColor = ProjectColors.red
          colorSlider.value                 = Float(currentButtonColor.red) * 255
          colorSlider.setThumbImage(UIImage(named: "RedSlider"), forState: .Normal)
        case "Green":
          sliderOrigin                      = CGPoint(x: 8, y: 60)
          colorSlider.minimumTrackTintColor = ProjectColors.green
          colorSlider.value                 = Float(currentButtonColor.green) * 255
          colorSlider.setThumbImage(UIImage(named: "GreenSlider"), forState: .Normal)
        default:
          sliderOrigin                      = CGPoint(x: 8, y: 100)
          colorSlider.minimumTrackTintColor = ProjectColors.blue
          colorSlider.value                 = Float(currentButtonColor.blue) * 255
          colorSlider.setThumbImage(UIImage(named: "BlueSlider"), forState: .Normal)
      }
      colorSlider.trackWidth = colorView.frame.size.width - 16
      let sliderSize = CGSize(width: colorSlider.trackWidth, height: 16)
      
      colorSlider.frame = CGRect(origin: sliderOrigin!, size: sliderSize)
      colorSlider.addTarget(self, action: #selector(FontManagerViewController.changeButtonColor), forControlEvents: .ValueChanged)
      colorView.addSubview(colorSlider)
    }
  }

}  // FontManagerViewController End




// ******************************************************************
//   MARK: Font Manager VC Delegate
// ******************************************************************

protocol FontManagerViewControllerDelegate {
  
  func changeFontAttributes (fontAttributes: [String: NSObject])
  
}



// ******************************************************************
//   MARK: UIColor Extension
// ******************************************************************

// Color functions to gain access to CGFloat numbers for Red, Green, Blue and Alpha.
extension UIColor {
  
  /**
    Gets the components of a UIColor and returns it as an array
  
    - Returns: [Red, Green, Blue, Alpha]
   */
  func getRGBComponents() -> [CGFloat] {
    
    var colorDescription = self.description
    colorDescription = colorDescription.stringByReplacingOccurrencesOfString("UIDeviceRGBColorSpace ", withString: "")
    let colorArray: [String] = colorDescription.componentsSeparatedByString(" ")
    var rgbArray = [CGFloat]()
    
    for index in colorArray {
      guard let value = Float(index)
        else { break }
      
      rgbArray.append(CGFloat(value))
    }
  
    return rgbArray
  }
  
  /// Returns the red component of a UIColor
  var red:   CGFloat { return self.getRGBComponents()[0] }
  /// Returns the blue component of a UIColor
  var blue:  CGFloat { return self.getRGBComponents()[1] }
  /// Returns the green component of a UIColor
  var green: CGFloat { return self.getRGBComponents()[2] }
  /// Returns the alpha component of a UIColor
  var alpha: CGFloat { return self.getRGBComponents()[3] }
  
}


// ******************************************************************
//   MARK: Class RGBSliders
// ******************************************************************

class RGBSliders: UISlider {
  
  internal var trackWidth: CGFloat = 100.0
  
  override func trackRectForBounds(bounds: CGRect) -> CGRect {
    return CGRect(x: 0, y: 0, width: trackWidth, height: 5)
  }
}
