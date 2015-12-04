//
//  ViewController.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/1/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationBarDelegate {

  var navigationBar = UINavigationBar()
  var toolbar = UIToolbar()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpNavigationBar()
    setUpToolbar()
    

  }
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  func pickImageFromAlbum() {
    
  }
  
  // MARK: Get Image Functions
  
  func selectImageFromAlbum() {
    print("Things and Stuff")
  }
  
  
  // MARK: Inital UI Set Up Functions
  
  // Set up and initalize NavigationBar
  func setUpNavigationBar() {
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
    establishConstraints(navigationBar)
    
  }
  
  
  // Set up and initialize Toolbar
  func setUpToolbar() {
    toolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height - 54, width: self.view.frame.size.width, height: 44))
    
    let tapGesture = UITapGestureRecognizer(target: self, action: "selectImageFromAlbum")
    
    // TODO: Add Cancel Button
    let shareButton2 = UIImageView(frame: CGRect(x: 0, y: 0, width: (self.view.frame.size.width - 3) / 2, height: 44))
    shareButton2.image = UIImage(named: "BarButton2")
    shareButton2.userInteractionEnabled = true
    shareButton2.addGestureRecognizer(tapGesture)
    shareButton2.contentMode = UIViewContentMode.ScaleAspectFill
    
    let stuffButton = UIButton(frame: CGRect(x: 0, y: 0, width: (self.view.frame.size.width - 3) / 2, height: 44))
    stuffButton.addTarget(self, action: "selectImageFromAlbum", forControlEvents: .TouchUpInside)
    stuffButton.setImage(UIImage(named: "BarButton1"), forState: .Normal)
    stuffButton.imageView?.contentMode = .ScaleAspectFill
    
    // TODO: Add Actions to Bar Buttons
    let leftButton2 = UIBarButtonItem(title: "Album", style: .Plain, target: self, action: "selectImageFromAlbum")
    leftButton2.customView = shareButton2
    let rightButton2 = UIBarButtonItem(title: "Album", style: .Plain, target: self, action: "selectImageFromAlbum")
    rightButton2.customView = stuffButton
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
    flexSpace.setBackgroundImage(UIImage(named: "ToolbarTest2"), forState: .Normal, barMetrics: .Default)
    
    toolbar.items = [leftButton2, flexSpace, rightButton2]
    
    self.view.addSubview(toolbar)
    
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    establishConstraints(toolbar)
  }
  
  
  // Sets up the constraints to keep NavBar and Toolbar at top and bottom of view, respectivly.
  func establishConstraints(target: AnyObject) {
    var verticalConstraint = NSLayoutConstraint()
    
    if target as! NSObject == navigationBar {
      verticalConstraint = NSLayoutConstraint(item: target, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
    } else {
      verticalConstraint = NSLayoutConstraint(item: target, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 10)
    }
    
    let leadingConstraint = NSLayoutConstraint(item: target, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: -20)
    let trailingConstraint = NSLayoutConstraint(item: target, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 20)
    
    view.addConstraints([verticalConstraint, leadingConstraint, trailingConstraint])
  }
  
}

