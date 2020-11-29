//
//  SetCardView.swift
//  Set_Game
//
//  Created by Andrew on 11/27/20.
//

import SwiftUI
import Foundation

struct SetCardView: View {
  
  var card: SetCard
  
  /**
   Cards start at a random location and fly into the view of the player
   
   - Must update card position as the grid becomes larger / smaller
   */
  @State
  private var isFaceUp = false
  
  var body: some View {
    GeometryReader { geometry in
      body(with: geometry)
    }
    .onAppear() {
      /* When card first appears, it must fly in */
      startFlyingAnimation()
    }
    .onDisappear() {
      startFlyingAnimation()
    }
  }
  
  @ViewBuilder
  private func body(with proxy: GeometryProxy) -> some View {
    if isFaceUp {
      ZStack {
        RoundedRectangle(cornerRadius: 5.0).fill(Color.white)
        RoundedRectangle(cornerRadius: 5.0)
          .stroke()
          .fill(card.inBadSet ? Color.red :
                  card.isSelected ? Color.yellow : Color.black)
        
        VStack {
          ForEach(0 ..< card.number) { _ in
            ZStack {
              if card.shape == SetCard.CardShape.oval {
                Oval().fill(convertCardColor()).opacity(convertCardStyle())
                Oval().stroke(lineWidth: strokeWidth).fill(convertCardColor())
              }
              else if card.shape == SetCard.CardShape.diamond {
                Diamond().fill(convertCardColor()).opacity(convertCardStyle())
                Diamond().stroke(lineWidth: strokeWidth).fill(convertCardColor())
              }
              else {
                Squiggle().fill(convertCardColor()).opacity(convertCardStyle())
                Squiggle().stroke(lineWidth: strokeWidth).fill(convertCardColor())
              }
            } // End Nested ZStack
            
          }// End ForEach
          
        }// End VStack
        
      } // End Zstack
      .transition(AnyTransition.offset(getRandomPosition(with: proxy.frame(in: .global))))
    }
  }
  
  /* Start the card at a random location and move to the center of its bounds */
  private func startFlyingAnimation() {
    withAnimation(.easeIn(duration: 1)) {
      isFaceUp = !isFaceUp
    }
  }
  
  /* Card appearing / disappearing */
  private func getRandomPosition(with frame: CGRect) -> CGSize {
    let offset = CGSize(width: frame.maxX + CGFloat(Int.random(in: 100 ..< 200)),
                        height: frame.maxY + CGFloat(Int.random(in: 0 ..< 100)))
    return offset
  }
  
  /* Translate card color to view */
  private func convertCardColor() -> Color {
    switch card.color {
    case .green: return Color.green
    case .purple: return Color.purple
    case .orange: return Color.orange
    }
  }
  
  /* Translate card style to opacity */
  private func convertCardStyle() -> Double {
    switch card.style {
    case .empty: return 0
    case .filled: return 1
    case .striped: return 0.25
    }
  }
  
  /* Tunable Params */
  let strokeWidth: CGFloat = 2.0
}

/**
 Preview the custom view
 */
struct SetCardView_Previews: PreviewProvider {
  static var previews: some View {
    SetCardView(card: createCard())
  }
  
  static func createCard() -> SetCard {
    SetCard(number: 2,
            shape: SetCard.CardShape.oval,
            style: SetCard.CardStyle.empty,
            color: SetCard.CardColor.purple
    )
  }
}
