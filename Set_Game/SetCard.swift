//
//  Card.swift
//  Set
//
//  Created by Andrew on 10/13/19.
//  Copyright © 2019 Andrew Siemon. All rights reserved.
//

import Foundation

struct SetCard : Equatable, Identifiable
{
  var id: Int
  private(set) var number : Int
  private(set) var shape : CardShape
  private(set) var style : CardStyle
  private(set) var color : CardColor
  var isPlayable = false
  var isSelected = false
  var isMatched = false
  var inBadSet = false
  
  static public let MAX_NUMBER = 3
  
  /**
   Conform to the Equatable protocol. Check if two cards are the same
   */
  static func ==(rhs: SetCard, lhs: SetCard) -> Bool
  {
    return rhs.number == lhs.number &&
      rhs.shape == lhs.shape &&
      rhs.style == lhs.style &&
      rhs.color == lhs.color
  }
  
  init(number: Int, shape: CardShape, style: CardStyle, color: CardColor)
  {
    self.number = number
    self.shape = shape
    self.style = style
    self.color = color
    id = number +
         shape.rawValue * shapeWeight +
         style.rawValue * styleWeight +
         color.rawValue * colorWeight
  }
  
  enum CardColor : Int, CaseIterable
  {
    case green = 1, purple, orange
  }
  
  enum CardStyle : Int, CaseIterable
  {
    case filled = 1, striped, empty
  }
  
  enum CardShape : Int, CaseIterable
  {
    case diamond = 1, oval, squiggle
  }
  
  let shapeWeight = 3
  let styleWeight = 9
  let colorWeight = 27
}

