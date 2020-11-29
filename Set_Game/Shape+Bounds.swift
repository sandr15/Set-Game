//
//  Shape+Bounds.swift
//  Set_Game
//
//  Created by Andrew on 11/27/20.
//

import SwiftUI

extension Shape {
  
  func getBoundsLateralOffset(bounds: CGRect, ratio: CGFloat) -> CGFloat {
      return bounds.size.width * ratio
  }
  
  func getBoundsVerticalOffset(bounds:CGRect, ratio: CGFloat) -> CGFloat {
      return bounds.size.height * ratio
  }
}
