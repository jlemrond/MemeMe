//
//  DisplayMemeViewController.swift
//  MemeMe
//
//  Created by Jason Lemrond on 9/2/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit

class DisplayMemeViewController : UIViewController {

  @IBOutlet weak var displayMemeImageView: UIImageView!

  var selectedMeme: Meme?

  override func viewDidLoad() {

    guard let meme = selectedMeme else {
      return
    }

    displayMemeImageView.image = meme.memedImage
    displayMemeImageView.contentMode = .ScaleAspectFit
    
  }

  

}
