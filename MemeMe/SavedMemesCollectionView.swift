//
//  SavedMemesCollectionView.swift
//  MemeMe
//
//  Created by Jason Lemrond on 8/30/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit

class SavedMemesCollectionView: UICollectionViewController {

  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

  var memes: [Meme] {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
  }
  var indexPaths = [NSIndexPath]?()
  @IBOutlet weak var addMeme: UIBarButtonItem!


  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)

    let space: CGFloat =  3.0
    let dimension = (view.frame.size.width - (space * 2)) / 3.0

    flowLayout.minimumLineSpacing = space
    flowLayout.minimumInteritemSpacing = space
    flowLayout.itemSize = CGSize(width: dimension, height: dimension)

    collectionView?.reloadData()

  }


  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if memes.count > 0 {
      return memes.count
    } else {
      return 20
    }
  }


  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("savedMemeCell", forIndexPath: indexPath) as! SavedMemesCollectionCell

    if memes.count > 0 {
      cell.cellImage.image = memes[indexPath.item].memedImage
    }

    if indexPaths == nil {
      indexPaths = [indexPath]
    } else {
      indexPaths!.append(indexPath)
    }

    cell.backgroundColor = UIColor.blackColor()
    return cell
  }


  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    let memeViewController = storyboard?.instantiateViewControllerWithIdentifier("memeViewController") as! ViewController

    if memes.count > 0 {
      memeViewController.selectedMeme = memes[indexPath.item]
    }

    navigationController?.pushViewController(memeViewController, animated: true)
    print("Item Selected")
    
  }

}

class SavedMemesCollectionCell: UICollectionViewCell {

  @IBOutlet weak var cellImage: UIImageView!

}





