//
//  ViewController.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/1/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, FontManagerViewControllerDelegate {

  
  // ******************************************************************
  //   MARK: Global Variables / IBOutlets
  // ******************************************************************
  
  var navigationBar = UINavigationBar()
  var toolbar = UIToolbar()
  var cameraButton = UIButton()
  var albumButton = UIButton()
  var navBarTopConstraint = NSLayoutConstraint()
  var imageViewScale: CGFloat?
  var imageScale = CGFloat()
  var resizedTopConst = CGFloat()
  var resizedBotConst = CGFloat()
  var defaultTopConst: CGFloat = 20
  var defaultBotConst: CGFloat = -20

  
  @IBOutlet weak var pickedImage: UIImageView!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var textStack: UIStackView!
  @IBOutlet weak var textStackTopConst: NSLayoutConstraint!
  @IBOutlet weak var textStackBottomConst: NSLayoutConstraint!
  
  let imagePickerController = UIImagePickerController()
  let textDelegate = textFieldDelegate()
  
  
  // Default text attributes for top and bottom text fields.
  var memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
    NSStrokeWidthAttributeName : "-4.0",
  ]
  var textFieldArray: [UITextField] = []
  
  
  
  
  // ******************************************************************
  //   MARK: Load and Appear Methods
  // ******************************************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = ProjectColors.getNavyColor()
    pickedImage.backgroundColor = ProjectColors.getIvoryColor()
    
    setUpNavigationBar()
    setUpToolbar()
    subscribeToKeyboardNotifications()
    
    imagePickerController.delegate = self
    
    // Set up attributes for top and bottom text fields.
    textFieldArray = [topTextField, bottomTextField]
    
    topTextField.text = "TOP"
    bottomTextField.text = "BOTTOM"
    
    for index in textFieldArray {
      index.delegate = textDelegate
      index.defaultTextAttributes = memeTextAttributes
      index.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      index.textAlignment = NSTextAlignment.Center
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    // If a camera is not available, make camera button unuseable
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    print("pickedImage: \(pickedImage.frame.size.width / pickedImage.frame.size.height)")
  }
  
  override func viewDidLayoutSubviews() {
    
    // Establish the scale factor for portrait mode.
    if imageViewScale == nil {
      imageViewScale = initalImageViewScaleFactor()
    }
    
    // Move and manipulate Navigation Bar when the frame is rotated.
    if view.bounds.size.height > view.bounds.size.width {
      navBarTopConstraint.constant = 20
      navigationBar.frame.size = CGSize(width: navigationBar.frame.size.width, height: 44)
    } else {
      navBarTopConstraint.constant = 0
      navigationBar.frame.size = CGSize(width: navigationBar.frame.size.width, height: 32)
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  override func viewWillDisappear(animated: Bool) {
    unsubscriveToKeyboardNotifications()
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    resizeIfPortait()
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Get Image Methods
  // ******************************************************************
  
  // Select Image From Album and Camera methods.
  
  func selectImageFromAlbum() {
    // Present view controller to get image from photo album.
    print("Select image from album selected")
    
    resetTextStackConstraints()
    imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(imagePickerController, animated: true, completion: nil)
  }
  
  func captureImageFromCamera() {
    // Present view controller to get image from camera.
    print("Caputre image from Camera Selected")
    
    resetTextStackConstraints()
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
    pickedImage.frame.size = pickedImage.sizeThatFits(selectedImage.size)
    
    if let image = pickedImage.image {
      resizeImageView(image)
    }
    
    // Dismiss view controller
    dismissViewControllerAnimated(true, completion: nil)
    
    print("Image selected and displayed")
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //Dismiss view controller when cancel is selected.
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  
  
  // Image manipulation methods
  func resizeImageView(image: UIImage) {
    
    imageScale = imageScaleFactor(image)
    
    if imageScale > imageViewScale {
      print("short image")
      
      let newImageHeight = textStack.frame.size.width / imageScale
      resizedTopConst = (textStack.frame.size.height - newImageHeight) / 2 + 20
      resizedBotConst = -((textStack.frame.size.height - newImageHeight) / 2 + 20)
    } else {
      resizedTopConst = defaultTopConst
      resizedBotConst = defaultBotConst
    }
    
    resizeIfPortait()
  }
  
  func resetTextStackConstraints() {
    textStackTopConst.constant = defaultTopConst
    textStackBottomConst.constant = defaultBotConst
  }
  
  func resizeIfPortait() {
    if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait {
      textStackTopConst.constant = resizedTopConst
      textStackBottomConst.constant = resizedBotConst
    } else {
      resetTextStackConstraints()
    }
  }
  
  func initalImageViewScaleFactor() -> CGFloat {
    // Returns the inital scale of the text stack (image frame).
    
    let imageViewHeight = textStack.frame.size.height
    let imageViewWidth  = textStack.frame.size.width
    return imageViewWidth / imageViewHeight
  
  }
  
  func imageScaleFactor(image: UIImage) -> CGFloat {
    // Returns the scale of the given image.
    
    let imageHeight = image.size.height
    let imageWidth  = image.size.width
    return imageWidth / imageHeight
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
      print("Current Font is \(currentFontName)")
      fontManagerViewController.fontFamilyName = currentFontName
    }
    
    if let currentFontColor = topTextField.textColor {
      print("Current Text Color description is \(currentFontColor)")
      fontManagerViewController.oldFontColor = currentFontColor
    }
  
    guard let popoverFontController = fontManagerViewController.popoverPresentationController else {
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
    return .None
  }
  
  func changeFontAttributes(fontAttributes: [String : NSObject]) {
    memeTextAttributes = fontAttributes
    
    for index in textFieldArray {
      index.defaultTextAttributes = fontAttributes
      index.textAlignment = .Center
    }
  }
  
  
  
  
  
  // ******************************************************************
  //   MARK: Keyboard Methods
  // ******************************************************************
  
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func unsubscriveToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if bottomTextField.isFirstResponder() {
      view.frame.origin.y -= getKeyboardHeight(notification)
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if bottomTextField.isFirstResponder() {
      view.frame.origin.y += getKeyboardHeight(notification)
    }
  }
  
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Inital UI Set Up Methods
  // ******************************************************************
  
  func setUpNavigationBar() {
    // Sets up navigation bar along with buttons.
    navigationBar.barTintColor = ProjectColors.getNavyColor()
    navigationBar.translucent = false

    // TODO: Add Share and Cancel Buttons
    let fontButton = UIBarButtonItem(title: "Aa", style: .Plain, target: self, action: "fontManagerSelected:")
    fontButton.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor(),
                                       NSFontAttributeName : UIFont(name: "FontAwesome", size: 18)!],
                                       forState: .Normal)
    
    // TODO: Add Actions to Bar Buttons
    let leftButton = UIBarButtonItem(title: nil, style: .Plain, target: self, action: nil)
    
    navigationItem.rightBarButtonItem = fontButton
    navigationItem.leftBarButtonItem =  leftButton
    
    navigationBar.items = [navigationItem]
    
    self.view.addSubview(navigationBar)
    
    view.addConstraints(navigationBar.pinToParent(top: nil, bottom: nil, leading: 0, trailing: 0))
    
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    navBarTopConstraint = NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: navigationBar.superview, attribute: .Top, multiplier: 1, constant: 20)
    view.addConstraint(navBarTopConstraint)
    
  }
  
  
  func setUpToolbar() {
    // Sets up toolbar along with buttons.
    toolbar.barTintColor = ProjectColors.getNavyColor()
    toolbar.translucent = false
    
    albumButton = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 30))
    albumButton.addTarget(self, action: "selectImageFromAlbum", forControlEvents: .TouchUpInside)
    albumButton.setTitle("\u{f03e}", forState: .Normal)
    albumButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 20)
    albumButton.backgroundColor = ProjectColors.getOrangeColor()
    albumButton.setTitleColor(ProjectColors.getNavyColor(), forState: .Normal)
    
    cameraButton = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 30))
    cameraButton.addTarget(self, action: "captureImageFromCamera", forControlEvents: .TouchUpInside)
    cameraButton.setTitle("\u{f083}", forState: .Normal)
    cameraButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 20)
    cameraButton.backgroundColor = ProjectColors.getYellowColor()
    cameraButton.setTitleColor(ProjectColors.getNavyColor(), forState: .Normal)
    
    let leftToolbarButton = UIBarButtonItem()
    leftToolbarButton.customView = albumButton
    let rightToolbarButton = UIBarButtonItem()
    rightToolbarButton.customView = cameraButton
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
    
    toolbar.items = [flexSpace, leftToolbarButton, flexSpace, rightToolbarButton, flexSpace]
    
    self.view.addSubview(toolbar)
    view.addConstraints(toolbar.pinToParent(top: nil, bottom: 0, leading: 0, trailing: 0))
  }
  
  func addTextStackConstraints() {
    
  }
  
}  // ViewController End




// ******************************************************************
//   MARK: UIView Extension
// ******************************************************************


extension UIView {
  
  func pinToParent(top top: Int?, bottom: Int?, leading: Int?, trailing: Int?) -> [NSLayoutConstraint] {
    // Pin a view to it's parent view.  To not include a constraint for a specified direction
    // simply assign that parameter to nil.
    
    self.translatesAutoresizingMaskIntoConstraints = false
    
    var constraintArray: [NSLayoutConstraint] = []
    
    if let top = top {
      let topConstant = CGFloat(top)
      let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.superview, attribute: .TopMargin, multiplier: 1, constant: topConstant)
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
