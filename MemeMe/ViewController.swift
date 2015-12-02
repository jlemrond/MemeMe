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
  
  
  // MARK: Inital UI Set Up Functions
  
  func setUpNavigationBar() {
    
    navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))
    
    // Set up Navigation Bar Constratints
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    
    let navigationConstraintVertical = NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
    let navigationConstraintLeading = NSLayoutConstraint(item: navigationBar, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0)
    let navigationConstraintTrailing = NSLayoutConstraint(item: navigationBar, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0)
    
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
    view.addConstraints([navigationConstraintVertical, navigationConstraintLeading, navigationConstraintTrailing])
    
  }
  
  func setUpToolbar() {
    
    // Initialize Toolbar
    toolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height - 44, width: self.view.frame.size.width, height: 44))
    
    // Set up parameters for Contrainsts
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    
    let toolbarConstraintVertical = NSLayoutConstraint(item: toolbar, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
    let toolbarConstraintLeading = NSLayoutConstraint(item: toolbar, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: -20)
    let toolbarConstraintTrailing = NSLayoutConstraint(item: toolbar, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 20)
    
    // TODO: Add Cancel Button
    let shareButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: (self.view.frame.size.width - 3) / 2, height: 44))
    shareButton2.setImage(UIImage(named: "BarButton1"), forState: .Normal)
    
    let stuffButton = UIButton(frame: CGRect(x: 0, y: 0, width: (self.view.frame.size.width - 3) / 2, height: 44))
    stuffButton.setImage(UIImage(named: "BarButton2"), forState: .Normal)
    
    // TODO: Add Actions to Bar Buttons
    let leftButton2 = UIBarButtonItem(customView: shareButton2)
    let rightButton2 = UIBarButtonItem(customView: stuffButton)
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
    flexSpace.setBackgroundImage(UIImage(named: "ToolbarTest2"), forState: .Normal, barMetrics: .Default)
    
    toolbar.items = [leftButton2, flexSpace, rightButton2]
    
    self.view.addSubview(toolbar)
    view.addConstraints([toolbarConstraintVertical, toolbarConstraintLeading, toolbarConstraintTrailing])
  }
  
}

