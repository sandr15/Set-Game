//
//  CGPoint+Offset.swift
//  Set_Game
//
//  Created by Andrew on 11/27/20.
//

import SwiftUI

/* Add an extension to CGPoint to easily create new points */
extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
