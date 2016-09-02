//
//  SavedMemesCollectionView.swift
//  MemeMe
//
//  Created by Jason Lemrond on 8/30/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit

class SavedMemesCollectionView: UICollectionViewController, SavedMemesCollectionViewDelegate {

  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

  var memes: [Meme] {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
  }


  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)


    // Set up Cell Spacing
    let space: CGFloat =  3.0
    let dimension = (view.frame.size.width - (space * 2)) / 3.0

    flowLayout.minimumLineSpacing = space
    flowLayout.minimumInteritemSpacing = space
    flowLayout.itemSize = CGSize(width: dimension, height: dimension)

    collectionView?.reloadData()

  }

  /// Establish number of cells based on number of Memes stored.
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if memes.count > 0 {
      return memes.count
    } else {
      return 0
    }
  }


  /// Display respective meme in each cell.
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("savedMemeCell", forIndexPath: indexPath) as! SavedMemesCollectionCell

    if memes.count > 0 {
      cell.cellImage.image = memes[indexPath.item].memedImage
    }

    return cell
  }

  /// Opens Meme Editor
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    let memeViewController = storyboard?.instantiateViewControllerWithIdentifier("memeViewController") as! MemeEditorViewController

    if memes.count > 0 {
      memeViewController.selectedMeme = memes[indexPath.item]
    }

    memeViewController.collectionViewDelegate = self
    navigationController?.pushViewController(memeViewController, animated: true)
    print("Item Selected from Grid")
    
  }




  // **************************************************
  //   MARK: Buttons
  // **************************************************


  /// Open Meme Editor
  @IBAction func addMeme(sender: UIBarButtonItem) {

    let memeViewController = storyboard?.instantiateViewControllerWithIdentifier("memeViewController") as! MemeEditorViewController

    memeViewController.collectionViewDelegate = self
    memeViewController.modalPresentationStyle = .OverFullScreen
    presentViewController(memeViewController, animated: true, completion: nil)

  }

}



// **************************************************
//   MARK: Saved Memes Collection Cell
// **************************************************


class SavedMemesCollectionCell: UICollectionViewCell {

  @IBOutlet weak var cellImage: UIImageView!

}



// **************************************************
//   MARK: Saved Memes Collection View Delegate
// **************************************************
//
//   Used to inform Collection View that the data used
//   needs to be reloaded.


protocol SavedMemesCollectionViewDelegate {
  func reloadData()
}

extension SavedMemesCollectionViewDelegate where Self: UICollectionViewController {

  func reloadData() {
    collectionView?.reloadData()
  }

}





