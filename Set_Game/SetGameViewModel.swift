//
//  SetGameViewModel.swift
//  Set_Game
//
//  Created by Andrew on 11/27/20.
//

import Foundation

/**
 ViewModel's in swiftUI are always classes
 */
class SetGameViewModel: ObservableObject
{
  @Published
  private var game: SetGame = createSetGame()
  
  /* One-liners don't require return statement */
  static func createSetGame() -> SetGame {
    SetGame()
  }
  
  /* Return the playable cards for the view to render */
  var cardsInPlay: Array<SetCard> {
    return game.playableCards
  }
  
  /* Return the currently selected cards */
  var selectedCards: Array<SetCard> {
    return game.selectedCards
  }
  
  /* Get the score */
  var score: String {
    "Score: \(game.score)"
  }
  
  /* MARK: User Intent */
  
  /* Let the user pick a card */
  func choose(card: SetCard) {
    game.selectCard(card)
  }
  
  /* Easily start a new game */
  func newGame()
  {
    game.resetGame()
  }
  
  /* Check if we have any cards left to deal */
  var ableToDeal: Bool {
    game.ableToDeal()
  }
  
  /* Deal 3 cards in the game */
  func dealCards()
  {
    game.dealThreeCards()
  }
}
