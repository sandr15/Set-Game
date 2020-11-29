//
//  Grid.swift
//  Memorize
//
//  Created by Andrew on 11/22/20.
//

import SwiftUI


struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
  private var items: [Item]
  private var viewForItem: (Item) -> ItemView
  
  /**
   Initialize a grid of generic Items
   
   # Additonal Notes
   The @escaping identifier is needed so that the function (or closure)
   passed to this function can be referenced *outside of* this init later on
   - Functions are treated as *Reference* types, so we are just assiging a
   pointer to the function in this init
   
   - If a function has a pointer to self, and self has a pointer to a function
   this can create a `Memory Cycle`!
   
   - The @escaping identifier helps swift determine where reference cycles may
   occur and handle them approprietly
   */
  init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
    self.items = items
    self.viewForItem = viewForItem
  }
  
  /**
   Implementation of a generic grid view
   */
  var body: some View {
    GeometryReader { geometry in
      body(for: GridLayout(itemCount: items.count, in: geometry.size))
    }
  }
  
  /**
   Short helper to layout the Elements
   */
  private func body(for layout: GridLayout) -> some View {
    ForEach(items) { item in
      body(for: item, in: layout)
    }
  }
  
  /**
   Short helper to create the ItemView
   */
  private func body(for item: Item, in layout: GridLayout) -> some View {
    let index = items.firstIndex(matching: item)!
    
    return viewForItem(item)
      .frame(width: layout.itemSize.width, height: layout.itemSize.height)
      .position(layout.location(ofItemAt: index)) /* force unwrap the optional */
      .transition(.scale)
  }
}

/* No preview since this is a generic type */
