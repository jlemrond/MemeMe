//
//  ViewController.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/1/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, FontManagerViewControllerDelegate {
  
  
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
  var currentDeviceHeight:  CGFloat!
  
  var shareImage = UIImage()
  var pickedImageOrigin = CGPoint()
  var pickedImageSize = CGSize()

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var navigationBarTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var pickedImage: UIImageView!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var textStack: UIStackView!
  @IBOutlet weak var textStackTopConst: NSLayoutConstraint!
  @IBOutlet weak var textStackBottomConst: NSLayoutConstraint!
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

  var selectedMeme = Meme?()
  var collectionViewDelegate = SavedMemesCollectionViewDelegate?()
  var tableViewDelegate = SavedMemesTableViewDelegate?()
  
  
  
  
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
    
    view.backgroundColor       = ProjectColors.background
    parentView.backgroundColor = ProjectColors.backgroundAlt
    
    setUpNavigationBar()
    setUpToolbar()
    setUpTextFields()
    
    imagePickerController.delegate = self

    if (selectedMeme != nil) {
      print("A Meme is selected")
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    print("View Will Appear Called")
    
    // If a camera is not available, make camera button unuseable
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    
    subscribeToKeyboardNotifications()
    
    resetParentViewConstraints()
    
  }
  
  // Reset frame when device is rotated
  override func viewDidLayoutSubviews() {
    if view.frame.height != currentDeviceHeight {
      print("Device rotated")
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
    isImageAvailable()
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
    
    activateTextStackConstraints()

  }
  
  func activateTextStackConstraints() {
    print("Reset Text Constraints Called")
    textStackTopConst.constant = activeConstratint
    textStackBottomConst.constant = activeConstratint
  }
  
  func resetTextStackConstraints() {
    print("Reset Text Constraints Called")
    textStackTopConst.constant = defaultConstraint
    textStackBottomConst.constant = defaultConstraint
  }
  
  func activateParentViewConstraints() {
    print("Reset Parent View Constraints Called")
    parentViewTopConst.constant = activeConstratint
    parentViewBotConst.constant = activeConstratint
  }
  
  func resetParentViewConstraints() {
    print("Reset Parent View Constraints Called")
    parentViewTopConst.constant = defaultConstraint
    parentViewBotConst.constant = defaultConstraint
  }
  
  func resizeIfPortait(image: UIImage) {
    print("Resize if Portrait Called")
    
    if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait {
      resizeTextStack(image)
    } else {
      resetTextStackConstraints()
    }
  
  }
  
  /// If image does not neeed to be scaled down, the absolute height of
  /// the image will be returned, else the scaled down size of the image
  /// is returned.
  func checkImageSize(image: UIImage, scale: CGFloat) -> CGFloat {
    
    if image.size.width  < parentView.frame.size.width  &&
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
  
  /// Returns the scale for the given object.
  func scaleFactor(object: CGSize) -> CGFloat {
    let height = object.height
    let width  = object.width
    return width / height
  }
  
  
  
  // Save Image Methods
  
  // Create image from the parentView
  func generateMemedImage() -> UIImage {
    UIGraphicsBeginImageContext(parentView.frame.size)
    parentView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let memedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return memedImage
  }
  
  /// Save the current image as a 'Meme' Struct
  func save(topText: String, bottomText: String, image: UIImage, meme: UIImage) {
    
    let savedImage = Meme(top: topText, bottom: bottomText, image: image, memedImage: meme)
    
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    appDelegate.memes.append(savedImage)
    print("Image Saved")
    print(appDelegate.memes)
  }
  
  /// Generates image to be saved or shared and opens Activity View Controller
  func share() {
    
    guard let image = pickedImage.image
      else { return }
    
    let group: dispatch_group_t = dispatch_group_create()
    
    dispatch_group_async(group, dispatch_get_main_queue()) { () -> Void in
      self.resizeImageView()
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
      // Waits for view to be resized to image size before executing
      self.shareImage = self.generateMemedImage()
      let activityViewController = UIActivityViewController(activityItems: [self.shareImage], applicationActivities: nil)

      activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in

        if (!completed) {
          return
        }

        self.collectionViewDelegate?.reloadData()
        self.tableViewDelegate?.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)

      }


      self.presentViewController(activityViewController, animated: true, completion: { () -> Void in
        self.save(self.topTextField.text!, bottomText: self.bottomTextField.text!, image: image, meme: self.shareImage)
        self.resetParentViewConstraints()
        self.activateTextStackConstraints()
      })
    }
    
  }
  
  func resizeImageView() {
    print("Resize Image View")
    resetTextStackConstraints()
    if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait {
      activateParentViewConstraints()
    }
  }
  

  // Cancel Button.
  
  func cancelImage() {
    pickedImage.image = nil
    isImageAvailable()

    dismissViewControllerAnimated(true, completion: nil)
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
    popoverFontController.backgroundColor = ProjectColors.background
    
    self.presentViewController(fontManagerViewController, animated: true, completion: nil)
  }
  
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
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
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    print("Notications subscribed")
  }
  
  func unsubscriveToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    print("Notifications unsubscribed")
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if bottomTextField.isFirstResponder() {
      view.frame.origin.y -= getKeyboardHeight(notification)
      navigationBarTopConstraint.constant -= getKeyboardHeight(notification)
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if bottomTextField.isFirstResponder() {
      view.frame.origin.y += getKeyboardHeight(notification)
      navigationBarTopConstraint.constant += getKeyboardHeight(notification)
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
  
  /// Sets up navigation bar along with buttons.
  func setUpNavigationBar() {
    navigationBar.barTintColor = ProjectColors.background
    navigationBar.translucent = false
    
    navigationBar.layer.shadowColor = UIColor.blackColor().CGColor
    navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    navigationBar.layer.shadowOpacity = 0.25
    navigationBar.layer.shadowRadius = 2.0
    
    let attributes = [NSFontAttributeName : UIFont(name: "FontAwesome", size: 18)!]

    fontButton = UIBarButtonItem(title: "Aa",       style: .Plain, target: self, action: #selector(MemeEditorViewController.fontManagerSelected(_:)))
    cancelButton = UIBarButtonItem(title: "\u{f00d}", style: .Plain, target: self, action: #selector(MemeEditorViewController.cancelImage))
    shareButton = UIBarButtonItem(barButtonSystemItem: .Action,     target: self, action: #selector(MemeEditorViewController.share))
    
    for buttons in [fontButton, shareButton, cancelButton] {
      buttons.setTitleTextAttributes(attributes, forState: .Normal)
      buttons.tintColor = ProjectColors.secondAccent
    }
    
    navigationItem.rightBarButtonItems = [shareButton, fontButton]
    navigationItem.leftBarButtonItem = cancelButton
    navigationBar.items = [navigationItem]
    
    view.addSubview(navigationBar)
  }
  
  /// Sets up toolbar along with buttons.
  func setUpToolbar() {
    toolbar.barTintColor = ProjectColors.background
    toolbar.translucent = false
    
    toolbar.layer.shadowColor = UIColor.blackColor().CGColor
    toolbar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    toolbar.layer.shadowOpacity = 0.4
    toolbar.layer.shadowRadius = 5.0
    
    albumButton.addTarget(self, action: #selector(MemeEditorViewController.selectImageFromAlbum), forControlEvents: .TouchUpInside)
    albumButton.setTitle("\u{f03e}", forState: .Normal)
    albumButton.backgroundColor = ProjectColors.secondAccent
    
    cameraButton.addTarget(self, action: #selector(MemeEditorViewController.captureImageFromCamera), forControlEvents: .TouchUpInside)
    cameraButton.setTitle("\u{f083}", forState: .Normal)
    cameraButton.backgroundColor = ProjectColors.secondAccent
    
    for buttons in [albumButton, cameraButton] {
      buttons.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
      buttons.setTitleColor(ProjectColors.background, forState: .Normal)
      buttons.titleLabel?.font = UIFont(name: "FontAwesome", size: 20)
      buttons.layer.cornerRadius = 3.0
    }
    
    let leftToolbarButton = UIBarButtonItem()
    leftToolbarButton.customView = albumButton
    let rightToolbarButton = UIBarButtonItem()
    rightToolbarButton.customView = cameraButton
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
    
    toolbar.items = [flexSpace, leftToolbarButton, flexSpace, rightToolbarButton, flexSpace]
    
    view.addSubview(toolbar)
  }
  
  /// Set up attributes for top and bottom text fields.
  func setUpTextFields() {
    textFieldArray = [topTextField, bottomTextField]
    
    topTextField.text    = "TOP"
    bottomTextField.text = "BOTTOM"
    
    for index in textFieldArray {
      index.delegate = textDelegate
      index.defaultTextAttributes = memeTextAttributes
      index.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      index.textAlignment = NSTextAlignment.Center
    }
  }
  
}  // MemeEditorViewController End
