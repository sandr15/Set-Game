//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Andrew on 11/22/20.
//

import Foundation

/**
 Extension to array to support looking for an Identifiable Element
 
 # Additional Notes
 The canonical way of naming a file that adds functionality to some data structure
 is <original_file>+<extension>.swift
 - original_file: the name of the original file or type
 - extension: a one word description of the capability being added
 */
extension Array where Element: Identifiable {
  /**
   Find the location of an item in the items array
   */
  func firstIndex(matching element: Element) -> Int? {
    for index in 0 ..< self.count {
      if self[index].id == element.id {
        return index
      }
    }
    
    return nil
  }
}
