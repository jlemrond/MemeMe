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

  
  // TODO: List
  // Add Crop
  // Change color slider thumb
  // Remove or use "Image View"
  // Edit Color Scheme
  // Check functionality while other views are visable and device is rotated
  // Optional Binding in FontManager
  
  
  // ******************************************************************
  //   MARK: Global Variables / IBOutlets
  // ******************************************************************
  
  var cameraButton = UIButton()
  var albumButton = UIButton()
  var shareButton = UIBarButtonItem()
  var fontButton = UIBarButtonItem()
  var cancelButton = UIBarButtonItem()
  var saveButton = UIBarButtonItem()

  var navBarTopConstraint = NSLayoutConstraint()
  var imageViewScale: CGFloat?
  var imageScale = CGFloat()
  var defaultConstraint: CGFloat = 0
  var activeConstratint: CGFloat = 0
  var currentDeviceHeight: CGFloat!
  
  var shareImage = UIImage()
  var pickedImageOrigin = CGPoint()
  var pickedImageSize = CGSize()

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var pickedImage: UIImageView!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var textStack: UIStackView!
  @IBOutlet weak var textStackTopConst: NSLayoutConstraint!
  @IBOutlet weak var textStackBottomConst: NSLayoutConstraint!
  @IBOutlet weak var imageView: UIView!
  @IBOutlet weak var imageViewTopConst: NSLayoutConstraint!
  @IBOutlet weak var imageViewBotConst: NSLayoutConstraint!
  @IBOutlet weak var parentView: UIView!
  @IBOutlet weak var parentViewTopConst: NSLayoutConstraint!
  @IBOutlet weak var parentViewBotConst: NSLayoutConstraint!
  
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
  
  var memes: [Meme] = []
  
  
  
  
  // ******************************************************************
  //   MARK: UIView Methods
  // ******************************************************************
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("View Did Load Called")
    
    // Establish the scale factor for portrait mode.
    if imageViewScale == nil {
      let viewSize = CGSize(width: view.frame.size.width, height: view.frame.size.height - 44 - 64)
      imageViewScale = scaleFactor(viewSize)
    }
    
    view.backgroundColor = ProjectColors.getNavyColor()
    parentView.backgroundColor = ProjectColors.getBlueColor()
    
    setUpNavigationBar()
    setUpToolbar()
    setUpTextFields()
    
    imagePickerController.delegate = self
    
    imageView.layer.borderWidth = 3.0
    imageView.layer.borderColor = UIColor.redColor().CGColor
    
  }
  
  override func viewWillAppear(animated: Bool) {
    print("View Will Appear Called")
    
    // If a camera is not available, make camera button unuseable
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    subscribeToKeyboardNotifications()
    
    parentViewTopConst.constant = defaultConstraint
    parentViewBotConst.constant = defaultConstraint
    
  }
  
  // Reset frame when device is rotated
  override func viewDidLayoutSubviews() {
    if view.frame.height != currentDeviceHeight {
      print("rotation called")
      isImageAvailable()
      currentDeviceHeight = view.frame.height
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  override func viewWillDisappear(animated: Bool) {
    unsubscriveToKeyboardNotifications()
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Image Methods
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
    
    isImageAvailable()
    
    // Dismiss view controller
    dismissViewControllerAnimated(true, completion: nil)
    
    print("Image selected and displayed")
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //Dismiss view controller when cancel is selected.
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  
  // Image Text manipulation methods
  
  func resizeTextStack(image: UIImage) {
    // Establish constraints for an image in Portrait View.
    print("Resize Text Called")
    
    imageScale = scaleFactor(image.size)
    
    if imageScale > imageViewScale {
      print("Active constraints implimented")
      let newStackHeight = checkImageSize(image, scale: imageScale)
      activeConstratint = (parentView.frame.size.height - newStackHeight) / 2
    } else {
      print("Default constraints implimented")
      activeConstratint = defaultConstraint
    }
    
    textStackTopConst.constant = activeConstratint
    textStackBottomConst.constant = activeConstratint

  }
  
  func resetTextStackConstraints() {
    print("Reset Text Constraints Called")
    textStackTopConst.constant = defaultConstraint
    textStackBottomConst.constant = defaultConstraint
  }
  
  func resizeIfPortait(image: UIImage) {
    print("Resize if Portrait Called")
    
    if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait {
      resizeTextStack(image)
    } else {
      resetTextStackConstraints()
    }
  
  }
  
  // If image does not neeed to be scaled down, the absolute height of
  // the image will be returned, else the scaled down size of the image
  // is returned.
  func checkImageSize(image: UIImage, scale: CGFloat) -> CGFloat {
    
    if image.size.width < parentView.frame.size.width  &&
       image.size.height < parentView.frame.size.height {
        print("Image Size Used")
        return image.size.height
    } else {
        print("Parent View Used")
        return parentView.frame.size.width / scale
    }
  }
  
  func isImageAvailable() {
    print("Check if image is available called")
    
    if let image = pickedImage.image {
      shareButton.enabled = true
      resizeIfPortait(image)
    } else {
      shareButton.enabled = false
      resetTextStackConstraints()
    }
  }
  
  // Returns the scale for the given object.
  func scaleFactor(object: CGSize) -> CGFloat {
    let height = object.height
    let width  = object.width
    return width / height
  }
  
  
  
  // Save Image Methods
  
  // Create image from the parent view
  func generateMemedImage() -> UIImage {
    UIGraphicsBeginImageContext(parentView.frame.size)
    parentView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let memedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return memedImage
  }
  
  // Save the current image as a 'Meme' Struct
  func save() {
    guard let image = pickedImage.image else { return }
    
    let savedImage = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: image, memedImage: generateMemedImage())
    memes.append(savedImage)
    print(memes)
  }
  
  // Generates image to be saved or shared and opens Activity View Controller
  func share() {
    
    let group: dispatch_group_t = dispatch_group_create()
    
    dispatch_group_async(group, dispatch_get_main_queue()) { () -> Void in
      self.resizeImageView()
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
      // Waits for view to be resized to image size before executing
      self.shareImage = self.generateMemedImage()
      let activityViewController = UIActivityViewController(activityItems: [self.shareImage], applicationActivities: nil)
      self.presentViewController(activityViewController, animated: true, completion: { () -> Void in
        self.parentViewTopConst.constant = self.defaultConstraint
        self.parentViewBotConst.constant = self.defaultConstraint
        self.textStackTopConst.constant = self.activeConstratint
        self.textStackBottomConst.constant = self.activeConstratint
      })
    }
    
  }
  
  func resizeImageView() {
    print("Resize Image View")
    resetTextStackConstraints()
    if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait {
      parentViewTopConst.constant = activeConstratint
      parentViewBotConst.constant = activeConstratint
    }
  }
  

  // Cancel Button.
  
  func cancelImage() {
    pickedImage.image = nil
    isImageAvailable()
  }
  
  
  
  // ******************************************************************
  //   MARK: Font Manager Methods
  // ******************************************************************
  
  func fontManagerSelected(sender: UIBarButtonItem) {
    // Present the Font Manager via Modal Popover
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
    popoverFontController.backgroundColor = ProjectColors.getBlueColor()
    
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
    
    isImageAvailable()
  }
  
  
  
  
  // ******************************************************************
  //   MARK: Keyboard Methods
  // ******************************************************************
  
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    print("Notications subscribed")
  }
  
  func unsubscriveToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    print("Notification unsubscribed")
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
    
    let attributes = [NSFontAttributeName : UIFont(name: "FontAwesome", size: 18)!]

    fontButton = UIBarButtonItem(title: "Aa", style: .Plain, target: self, action: "fontManagerSelected:")
    fontButton.setTitleTextAttributes(attributes, forState: .Normal)
    fontButton.tintColor = ProjectColors.getYellowColor()
    
    shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "share")
    shareButton.enabled = false
    shareButton.tintColor = ProjectColors.getYellowColor()
    
    cancelButton = UIBarButtonItem(title: "\u{f00d}", style: .Plain, target: self, action: "cancelImage")
    cancelButton.setTitleTextAttributes(attributes, forState: .Normal)
    cancelButton.tintColor = ProjectColors.getYellowColor()
    
    saveButton = UIBarButtonItem(title: "\u{f0c7}", style: .Plain, target: self, action: "save")
    saveButton.setTitleTextAttributes(attributes, forState: .Normal)
    saveButton.tintColor = ProjectColors.getYellowColor()
    
    //navigationItem.rightBarButtonItem = fontButton
    navigationItem.rightBarButtonItems = [saveButton, shareButton, fontButton]
    navigationItem.leftBarButtonItem =  cancelButton
    
    navigationBar.items = [navigationItem]
    
    self.view.addSubview(navigationBar)
  }
  
  // Sets up toolbar along with buttons.
  func setUpToolbar() {
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
  }
  
  func setUpTextFields() {
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
  
}  // ViewController End
