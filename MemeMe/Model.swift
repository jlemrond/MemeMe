//
//  FontModel.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/7/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import UIKit

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
  
  static func getNavyColor() -> UIColor {
    return UIColor(red: 1/255, green: 26/255, blue: 39/255, alpha: 1.0)
  }
  
  static func getBlueColor() -> UIColor {
    return UIColor(red: 6/255, green: 56/255, blue: 82/255, alpha: 1.0)
  }
  
  static func getOrangeColor() -> UIColor {
    return UIColor(red: 240/255, green: 129/255, blue: 15/255, alpha: 1.0)
  }
  
  static func getYellowColor() -> UIColor {
    return UIColor(red: 230/255, green: 223/255, blue: 68/255, alpha: 1.0)
  }
  
  static func getIvoryColor() -> UIColor {
    return UIColor(red: 241/255, green: 243/255, blue: 206/255, alpha: 1.0)
  }
}




