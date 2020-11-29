//
//  Diamond.swift
//  Set_Game
//
//  Created by Andrew on 11/27/20.
//

import SwiftUI

struct Diamond: Shape {
  /**
   Conform to the Shape protocol, do custom drawing
   */
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    /* Create the points to be used in the shape */
    let lateralReach = (rect.width * widthRatio) / 2
    let verticalReach = (rect.height * heightRatio) / 2
    let leftPoint =   CGPoint(x: rect.midX - lateralReach,
                              y: rect.midY)
    let topPoint =    CGPoint(x: rect.midX,
                              y: rect.midY - verticalReach)
    let bottomPoint = CGPoint(x: rect.midX,
                              y: rect.midY + verticalReach)
    let rightPoint =  CGPoint(x: rect.midX + lateralReach,
                              y: rect.midY)
    
    /* Create the shape */
    path.move(to: leftPoint)
    path.addLine(to: bottomPoint)
    path.addLine(to: rightPoint)
    path.addLine(to: topPoint)
    path.closeSubpath()
    
    /* Return our nice diamond */
    return path
  }
  
  /* Drawing constants -- tunable drawing params */
  let widthRatio: CGFloat = 0.8
  let heightRatio: CGFloat = 0.6
  
}
