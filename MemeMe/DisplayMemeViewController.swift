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

    // If Meme is not present for some reason, return to previous screen.
    guard let meme = selectedMeme else {
      navigationController?.popViewControllerAnimated(true)
      return
    }

    let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(DisplayMemeViewController.editMeme))
    navigationItem.rightBarButtonItem = editButton

    displayMemeImageView.image = meme.memedImage
    displayMemeImageView.contentMode = .ScaleAspectFit
    
  }

  func editMeme() {

    let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("memeViewController") as! MemeEditorViewController

    memeEditor.selectedMeme = selectedMeme
    presentViewController(memeEditor, animated: true, completion: nil)

  }

  

}
