//
//  FontModel.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/7/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import UIKit

// ******************************************************************
//   MARK: Meme Struct
// ******************************************************************

struct Meme {
  
  var bottomText: String
  var topText: String
  var image: UIImage
  var memedImage: UIImage
  
}



// ******************************************************************
//   MARK: Project Fonts
// ******************************************************************

struct FontModel {
  
  let name: String
  let fontFamily: String
  
  static func all() -> [FontModel] {
    return [
      FontModel(name: "American Typewriter", fontFamily: "AmericanTypewriter-CondensedBold"),
      FontModel(name: "Arial", fontFamily: "Arial-BoldMT"),
      FontModel(name: "Avenir Next", fontFamily: "AvenirNextCondensed-Heavy"),
      FontModel(name: "Courier", fontFamily: "Courier-Bold"),
      FontModel(name: "FontAwesome", fontFamily: "FontAwesome"),
      FontModel(name: "Futura", fontFamily: "Futura-CondensedExtraBold"),
      FontModel(name: "Gothic Neo", fontFamily: "AppleSDGothicNeo-SemiBold"),
      FontModel(name: "Helvetica Neue", fontFamily: "HelveticaNeue-CondensedBlack"),
      FontModel(name: "Impact", fontFamily: "Impact"),
      FontModel(name: "Superclarendon", fontFamily: "Superclarendon-Black"),
      FontModel(name: "Verdana", fontFamily: "Verdana-Bold")
    ]
  }
}




// ******************************************************************
//   MARK: Project Colors
// ******************************************************************

struct ProjectColors {
  
  static var red = UIColor(red: 255/255, green: 124/255, blue: 108/255, alpha: 1.0)
  static var blue = UIColor(red: 25/255,  green: 181/255, blue: 254/255, alpha: 1.0)
  static var green = UIColor(red: 62/255,  green: 220/255, blue: 129/255, alpha: 1.0)
  
  static var secondAccent = UIColor(red: 55/255,  green: 219/255, blue: 208/255, alpha: 1.0)
  static var background = UIColor(red: 41/255,  green: 41/255,  blue: 41/255,  alpha: 1.0)
  static var backgroundAlt = UIColor(red: 53/255,  green: 53/255,  blue: 53/255,  alpha: 1.0)

}




