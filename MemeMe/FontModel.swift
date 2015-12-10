//
//  FontModel.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/7/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

struct FontModel {
  
  let name: String
  
  static func all() -> [FontModel] {
    return [
      FontModel(name: "AmericanTypewriter-CondensedBold"),
      FontModel(name: "AppleSDGothicNeo-SemiBold"),
      FontModel(name: "Arial-BoldMT"),
      FontModel(name: "AvenirNextCondensed-Heavy"),
      FontModel(name: "Courier-Bold"),
      FontModel(name: "Futura-CondensedExtraBold"),
      FontModel(name: "HelveticaNeue-CondensedBlack")
    ]
  }
  
}
