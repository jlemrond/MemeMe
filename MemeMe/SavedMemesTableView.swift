//
//  SavedMemesTableView.swift
//  MemeMe
//
//  Created by Jason Lemrond on 9/1/16.
//  Copyright © 2016 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit

class SavedMemesTableView: UITableViewController, SavedMemesTableViewDelegate {


  var memes: [Meme] {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 80
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    tableView.reloadData()
  }


  /// Number of rows is based on the number of memes stored.
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if memes.count > 0 {
      return memes.count
    } else {
      return 20
    }

  }


  /// Add Text and Images to each table cell
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell")!

    if memes.count > 0 {
      cell.imageView?.image = memes[indexPath.item].memedImage
      cell.textLabel?.text = "\(memes[indexPath.item].topText)"
    } else {
      cell.textLabel?.text = ""
    }

    return cell
  }


  /// Open Meme Editor on selection.
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let memeViewController = storyboard?.instantiateViewControllerWithIdentifier("memeViewController") as! ViewController

    if memes.count > 0 {
      memeViewController.selectedMeme = memes[indexPath.item]
    }

    memeViewController.tableViewDelegate = self
    navigationController?.pushViewController(memeViewController, animated: true)
    print("Item Selected from Table")

  }


  // **************************************************
  //   MARK: Buttons
  // **************************************************

  /// Open Meme Editor
  @IBAction func addMeme(sender: UIBarButtonItem) {

    let memeViewController = storyboard?.instantiateViewControllerWithIdentifier("memeViewController") as! ViewController

    memeViewController.tableViewDelegate = self
    memeViewController.modalPresentationStyle = .OverFullScreen
    presentViewController(memeViewController, animated: true, completion: nil)

  }


}



// **************************************************
//   MARK: Saved Memes Table View Delegate
// **************************************************
//
//   Used to inform Collection View that the data used
//   needs to be reloaded.

protocol SavedMemesTableViewDelegate {
  func reloadData()
}

extension SavedMemesTableViewDelegate where Self: UITableViewController {

  func reloadData() {
    tableView.reloadData()
  }

}

