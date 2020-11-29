//
//  ContentView.swift
//  Set_Game
//
//  Created by Andrew on 11/27/20.
//

import SwiftUI

struct SetGameView: View {
  
  /**
   Watch the viewModel for published data
   */
  @ObservedObject
  var setGameVM: SetGameViewModel
  
  var body: some View {
    VStack {
      Text("The Game of Set")
        .font(.title)
    
      HStack {
        Grid(setGameVM.cardsInPlay) { card in
          SetCardView(card: card).onTapGesture {
            withAnimation(.easeOut(duration: 0.5)) {
              setGameVM.choose(card: card)
            }
          }
          .aspectRatio(2/3, contentMode: .fit)
          .padding(2)
        }
      }
      
      HStack {
        Button("Deal 3") {
          /* Add animation */
          withAnimation(.linear(duration: 0.5)) {
            setGameVM.dealCards()
          }
        }
        .disabled(setGameVM.ableToDeal ? false : true)
        
        Spacer()
        Text(setGameVM.score)
        Spacer()
        
        Button("Restart") {
          withAnimation(.linear(duration: 0.5)){
            setGameVM.newGame()
          }
        }
      }
      .padding()
    }
  }
  
  /* Tunable Params */
  let cardPadding: CGFloat = 5
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      SetGameView(setGameVM: SetGameViewModel())
    }
}
