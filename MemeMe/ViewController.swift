//
//  ViewController.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/1/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
  
  var navigationBar = UINavigationBar()
  var toolbar = UIToolbar()
  var cameraButton = UIButton()
  
  @IBOutlet weak var pickedImage: UIImageView!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  
  let imagePickerController = UIImagePickerController()
  let textDelegate = textFieldDelegate()
  
  // Text attributes for top and bottom text fields.
  let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : "4.0",
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up NavigationBar and Toolbar along with Buttons.
    setUpNavigationBar()
    setUpToolbar()
    
    // Make this ViewController a imagePicker Delegate.
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
  
  
  // **
  // MARK: Get Image Methods
  // **
  
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
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //Dismiss view controller when cancel is selected.
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  // **
  // MARK: Inital UI Set Up Methods
  // **
  
  func setUpNavigationBar() {
    // Sets up navigation bar along with buttons.
    navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))
    
    // TODO: Add Cancel Button
    let shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    shareButton.setImage(UIImage(named: "BarButton1"), forState: .Normal)
    
    // TODO: Add Actions to Bar Buttons
    let leftButton = UIBarButtonItem(title: nil, style: .Plain, target: self, action: nil)
    let rightButton = UIBarButtonItem(title: nil, style: .Plain, target: self, action: nil)
    
    leftButton.customView = shareButton
    
    navigationItem.rightBarButtonItem = rightButton
    navigationItem.leftBarButtonItem =  leftButton
    
    navigationBar.items = [navigationItem]
    
    self.view.addSubview(navigationBar)
    
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    pinToParent(target: navigationBar, parent: view, top: 20, bottom: nil, leading: 0, trailing: 0)
    
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
    pinToParent(target: toolbar, parent: view, top: nil, bottom: 0, leading: -10, trailing: 10)
  }
  
  
  func pinToParent(target target: AnyObject, parent: AnyObject, top: Int?, bottom: Int?, leading: Int?, trailing: Int?) {
    // Establishes the constraints to parent view for objects.
    var constraintArray: [NSLayoutConstraint] = []
    
    if let top = top {
      let topConstant = CGFloat(top)
      let topConstraint = NSLayoutConstraint(item: target, attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1, constant: topConstant)
      constraintArray.append(topConstraint)
    }
    
    if let bottom = bottom {
      let bottomConstant = CGFloat(bottom)
      let bottomConstraint = NSLayoutConstraint(item: target, attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1, constant: bottomConstant)
      constraintArray.append(bottomConstraint)
    }
    
    if let leading = leading {
      let leadingConstant = CGFloat(leading)
      let leadingConstraint = NSLayoutConstraint(item: target, attribute: .Leading, relatedBy: .Equal, toItem: parent, attribute: .Leading, multiplier: 1, constant: leadingConstant)
      constraintArray.append(leadingConstraint)
    }
    
    if let trailing = trailing {
      let trailingConstant = CGFloat(trailing)
      let trailingConstraint = NSLayoutConstraint(item: target, attribute: .Trailing, relatedBy: .Equal, toItem: parent, attribute: .Trailing, multiplier: 1, constant: trailingConstant)
      constraintArray.append(trailingConstraint)
    }
    
    view.addConstraints(constraintArray)
  }
  
}

