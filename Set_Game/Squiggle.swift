//
//  Squiggle.swift
//  Set_Game
//
//  Created by Andrew on 11/27/20.
//

import SwiftUI

struct Squiggle: Shape {
  
  /**
   Conform to the Shape protocol and do the drawing of a squiggle
   */
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    /* Move the starting point to the location you want  - Draw Bottom Bezier path */
    let lateralInset = (rect.width - (rect.width * widthRatio)) / 2
    let startingPoint = CGPoint(x: rect.minX + lateralInset,
                                y: rect.midY)
    
    /* Create the Points on the curve */
    let endingPoint = CGPoint(x: rect.maxX - lateralInset,
                              y: rect.midY)
    
    /* Place to start the path */
    path.move(to: startingPoint)
    
    let controlPoint1 = startingPoint.offsetBy(
      dx: (endingPoint.x - startingPoint.x) * controlPointToEndPointRatio,
      dy: getBoundsVerticalOffset(bounds: rect, ratio: controlPointToBoundsHeightRatio)
    )
    
    let controlPoint2 = endingPoint.offsetBy(
      dx: (endingPoint.x - startingPoint.x) * -controlPointToEndPointRatio,
      dy: -getBoundsVerticalOffset(bounds: rect, ratio: controlPointToBoundsHeightRatio)
    )
    
    
    /* Draw the top bezier path */
    let topSquiggleOffset = lateralInset * squiggleRatio
    let squiggleVerticalOffset = getBezierSquiggleOffset(bounds: rect)
    let startingPoint2 = startingPoint.offsetBy(dx: topSquiggleOffset,
                                                dy: -squiggleVerticalOffset)
    let endPoint2 = endingPoint.offsetBy(dx: topSquiggleOffset,
                                         dy: -squiggleVerticalOffset)
    let cp1 = controlPoint1.offsetBy(dx: topSquiggleOffset,
                                     dy: -squiggleVerticalOffset)
    let cp2 = controlPoint2.offsetBy(dx: topSquiggleOffset,
                                     dy: -squiggleVerticalOffset)
    
    /* Create control Points for Quad Curve's to connect the ends */
    let quadCurveSquiggleVerticalOffset = (startingPoint.y - startingPoint2.y) / quadCurveScalingFactor
    let quadCurveLateralOffset = getQuadCurveSquiggleLateralOffset(bounds: rect)
    let quadLeftCp = startingPoint2.offsetBy(dx: -quadCurveLateralOffset,
                                               dy: quadCurveSquiggleVerticalOffset)
    let quadRightCp = endingPoint.offsetBy(dx: quadCurveLateralOffset,
                                             dy: -quadCurveSquiggleVerticalOffset)

    /* Draw the curves and close the shape */
    path.addCurve(to: endingPoint, control1: controlPoint1, control2: controlPoint2)
    path.addQuadCurve(to: endPoint2, control: quadRightCp)
    path.addCurve(to: startingPoint2, control1: cp2, control2: cp1)
    path.addQuadCurve(to: startingPoint, control: quadLeftCp)
    path.closeSubpath()
    return path
  }
  
  /* MARK: Drawing constants - tune the drawing */
  /* Conform to Shape Extension */
  let shapeToBoundsRatio: CGFloat = 0.20
  let controlPointToBoundsHeightRatio: CGFloat = 0.1
  let cornerRadiusToBoundsHeightRatio: CGFloat = 0.06
  let controlPointToEndPointRatio: CGFloat = 0.3
  let topToBottomBezierPathRatio: CGFloat = 0.2
  let topToBottomBezierPathLateralOffsetRatio: CGFloat = 0.0
  let quadCurveLateralOffsetRatio: CGFloat = 0.1
  let quadCurveScalingFactor: CGFloat = 10
  
  let widthRatio: CGFloat = 0.6
  let heightRatio: CGFloat = 0.8
  let squiggleRatio: CGFloat = 0.1
  
  private func getCornerRadius(bounds: CGRect) -> CGFloat {
      return cornerRadiusToBoundsHeightRatio * bounds.size.height
  }
  
  private func getBezierSquiggleOffset(bounds: CGRect) -> CGFloat {
      return bounds.size.height * topToBottomBezierPathRatio
  }
  
  private func getBezierSqiggleLateralOffset(bounds: CGRect) -> CGFloat {
      return bounds.size.width * topToBottomBezierPathLateralOffsetRatio
  }
  
  private func getQuadCurveSquiggleLateralOffset(bounds: CGRect) -> CGFloat {
      return bounds.size.width * quadCurveLateralOffsetRatio
  }
}
