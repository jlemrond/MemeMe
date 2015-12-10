//
//  ViewController.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/1/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, FontManagerViewControllerDelegate {

  
  // ******************************************************************
  //   MARK: Global Variables / IBOutlets
  // ******************************************************************
  
  var navigationBar = UINavigationBar()
  var toolbar = UIToolbar()
  var cameraButton = UIButton()
  
  @IBOutlet weak var pickedImage: UIImageView!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  
  let imagePickerController = UIImagePickerController()
  let textDelegate = textFieldDelegate()
  
  
  // Text attributes for top and bottom text fields.
  var memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "AvenirNextCondensed-Heavy", size: 40)!,
    NSStrokeWidthAttributeName : "-4.0",
  ]
  
  
  
  
  // ******************************************************************
  //   MARK: Load and Appear Methods
  // ******************************************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpNavigationBar()
    setUpToolbar()
    
    imagePickerController.delegate = self
    
    // Set up attributes for top and bottom text fields.
    topTextField.text = "TOP"
    topTextField.delegate = textDelegate
    topTextField.defaultTextAttributes = memeTextAttributes
    topTextField.textAlignment = NSTextAlignment.Center
    
    bottomTextField.text = "BOTTOM"
    bottomTextField.delegate = textDelegate
    bottomTextField.defaultTextAttributes = memeTextAttributes
    bottomTextField.textAlignment = NSTextAlignment.Center
    
  }
  
  override func viewWillAppear(animated: Bool) {
    // If a camera is not available, make camera button unuseable
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Get Image Methods
  // ******************************************************************
  
  // Select Image From Album and Camera methods.
  
  func selectImageFromAlbum() {
    // Present view controller to get image from photo album.
    print("Select image from album selected")
    
    imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(imagePickerController, animated: true, completion: nil)
  }
  
  func captureImageFromCamera() {
    // Present view controller to get image from camera.
    print("Caputre image from Camera Selected")
    
    imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
    self.presentViewController(imagePickerController, animated: true, completion: nil)
  }
  
  
  // Image picker delegate methods.
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    // Select image and assign it to the pickedImage Image View.
    
    guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
      print("No Image Selected")
      return
    }
    
    // Make the visable image view the image selected by the user.
    pickedImage.image = selectedImage
    pickedImage.contentMode = .ScaleAspectFit
    
    // Dismiss view controller
    dismissViewControllerAnimated(true, completion: nil)
    
    print("Image selected and displayed")
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //Dismiss view controller when cancel is selected.
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Font Manager Methods
  // ******************************************************************
  
  func fontManagerSelected(sender: UIBarButtonItem) {
    // Present the Font Manager via Modal Popover.
    print("Font manager selected")
    
    var fontManagerViewController = FontManagerViewController()
    fontManagerViewController = storyboard?.instantiateViewControllerWithIdentifier("FontManagerViewController") as! FontManagerViewController
    fontManagerViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
    
    // Data that will be transfered to FontManagerViewController
    fontManagerViewController.delegate = self
    if let currentFontName = topTextField.font?.fontName {
      fontManagerViewController.oldFontFamiliy = (currentFontName)
    }
  
    
    guard let popoverFontController = fontManagerViewController.popoverPresentationController else {
      // Presents in legacy modal view (non-popover) for iOS 7 and earlier.
      self.presentViewController(fontManagerViewController, animated: true, completion: nil)
      print("Popover Presentation Controller not available.  Legacy veresion used.")
      return
    }
    
    // Configure popover paramaters
    popoverFontController.delegate = self
    popoverFontController.barButtonItem = sender
    
    self.presentViewController(fontManagerViewController, animated: true, completion: nil)
  }
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    // Required method to use popover modal presentations style on iPhones.  Only used in iOS 8 and later.
    return .None
  }
  
  func changeFontAttributes(fontAttributes: [String : NSObject]) {
    memeTextAttributes = fontAttributes
    topTextField.defaultTextAttributes = fontAttributes
    bottomTextField.defaultTextAttributes = fontAttributes
    
    topTextField.textAlignment = .Center
    bottomTextField.textAlignment = .Center
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Inital UI Set Up Methods
  // ******************************************************************
  
  func setUpNavigationBar() {
    // Sets up navigation bar along with buttons.
    
    navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))

    // TODO: Add Share and Cancel Buttons
    let fontButton = UIBarButtonItem(title: "Font", style: .Plain, target: self, action: "fontManagerSelected:")
    
    // TODO: Add Actions to Bar Buttons
    let leftButton = UIBarButtonItem(title: nil, style: .Plain, target: self, action: nil)
    
    navigationItem.rightBarButtonItem = fontButton
    navigationItem.leftBarButtonItem =  leftButton
    
    navigationBar.items = [navigationItem]
    
    self.view.addSubview(navigationBar)
    
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraints(navigationBar.pinToParent(top: 20, bottom: nil, leading: 0, trailing: 0))
    
  }
  
  
  func setUpToolbar() {
    // Sets up toolbar along with buttons.
    
    toolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height - 54, width: self.view.frame.size.width, height: 44))
    toolbar.barStyle = UIBarStyle.Black
    toolbar.translucent = true
    
    // TODO: Add Cancel Button
    let albumButton = UIButton(frame: CGRect(x: 0, y: 0, width: (self.view.frame.size.width - 30) / 2, height: 30))
    albumButton.addTarget(self, action: "selectImageFromAlbum", forControlEvents: .TouchUpInside)
    albumButton.setImage(UIImage(named: "BarButton1"), forState: .Normal)
    
    cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: (self.view.frame.size.width - 30) / 2, height: 30))
    cameraButton.addTarget(self, action: "captureImageFromCamera", forControlEvents: .TouchUpInside)
    cameraButton.setImage(UIImage(named: "BarButton1"), forState: .Normal)
    
    // TODO: Add Actions to Bar Buttons
    let leftToolbarButton = UIBarButtonItem()
    leftToolbarButton.customView = albumButton
    let rightToolbarButton = UIBarButtonItem()
    rightToolbarButton.customView = cameraButton
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
    flexSpace.setBackgroundImage(UIImage(named: "ToolbarTest2"), forState: .Normal, barMetrics: .Default)
    
    toolbar.items = [leftToolbarButton, flexSpace, rightToolbarButton]
    
    self.view.addSubview(toolbar)
    
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraints(toolbar.pinToParent(top: nil, bottom: 0, leading: 0, trailing: 0))
    
  }
  
}


extension UIView {
  
  func pinToParent(top top: Int?, bottom: Int?, leading: Int?, trailing: Int?) -> [NSLayoutConstraint] {
    // Pin a view to it's parent view.  To not include a constraint for a specified direction
    // simply assign that parameter to nil.
    
    self.translatesAutoresizingMaskIntoConstraints = false
    
    var constraintArray: [NSLayoutConstraint] = []
    
    if let top = top {
      let topConstant = CGFloat(top)
      let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.superview, attribute: .Top, multiplier: 1, constant: topConstant)
      constraintArray.append(topConstraint)
    }
    
    if let bottom = bottom {
      let bottomConstant = CGFloat(bottom)
      let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.superview, attribute: .Bottom, multiplier: 1, constant: bottomConstant)
      constraintArray.append(bottomConstraint)
    }
    
    if let leading = leading {
      let leadingConstant = CGFloat(leading)
      let leadingConstraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: self.superview, attribute: .Leading, multiplier: 1, constant: leadingConstant)
      constraintArray.append(leadingConstraint)
    }
    
    if let trailing = trailing {
      let trailingConstant = CGFloat(trailing)
      let trailingConstraint = NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: self.superview, attribute: .Trailing, multiplier: 1, constant: trailingConstant)
      
      constraintArray.append(trailingConstraint)
    }
    
    return constraintArray
  
  }
  
}
