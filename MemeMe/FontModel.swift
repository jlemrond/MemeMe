//
//  FontModel.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/7/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

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
