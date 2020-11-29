//
//  Oval.swift
//  Set_Game
//
//  Created by Andrew on 11/27/20.
//

import SwiftUI

struct Oval: Shape {
  /**
   Draw a custom Oval
   */
  func path(in rect: CGRect) -> Path {
    
    let width = rect.size.width * widthRatio
    let height = rect.size.width * heightRatio
    let leftPoint = CGPoint(x: rect.minX + ((rect.size.width - width) / 2),
                            y: rect.minY + ((rect.size.height - height) / 2))
    let ovalBounds = CGRect(x: leftPoint.x, y: leftPoint.y, width: width, height: height)
    
    /* Creates the oval -- now just need to add effects */
    let path = Path(ellipseIn: ovalBounds)
    
    return path
  }
  
  /* MARK: Tunable Drawing Parameters */
  let widthRatio: CGFloat = 0.7
  let heightRatio: CGFloat = 0.25
}
