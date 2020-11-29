//
//  Set.swift
//  Set
//
//  Created by Andrew on 10/13/19.
//  Copyright © 2019 Andrew Siemon. All rights reserved.
//

import Foundation

/**
 Set Game
 
 @brief
 This is the model implementation for a game of set.
 */
struct SetGame
{
  private(set) var cardDeck = [SetCard]()
  
  private(set) var playableCards = [SetCard]()
  
  private(set) var selectedCards = [SetCard]()
  
  private(set) var discardPile = [SetCard]()
  
  private(set) var score = 0
  
  /* We should be able to play with all 81 cards if need be */
  static let MAX_PLAYABLE_CARDS = 81
  
  mutating func shuffleCardDeck(){
    cardDeck.removeAll()
    
    for number in 1 ... SetCard.MAX_NUMBER {
      for color in SetCard.CardColor.allCases {
        for shape in SetCard.CardShape.allCases {
          for shade in SetCard.CardStyle.allCases {
            cardDeck.append(SetCard(number: number,
                                 shape: shape,
                                 style: shade,
                                 color: color))
          }
        }
      }
    }
    
    /* Shuffle the deck */
    cardDeck.shuffle()
  }
  
  mutating func initPlayingCards(){
    /* Deal the first 12 cards */
    assert(cardDeck.count >= 12, "Error: expected at least 12 cards in the deck")
    
    playableCards.removeAll()
    
    for _ in 0 ..< 12 {
      playableCards.append(cardDeck.removeFirst())
    }
  }
  
  /* Creates the deck of 81 cards */
  init(){
    shuffleCardDeck()
    initPlayingCards()
  }
  
  mutating func resetGame() {
    shuffleCardDeck()
    initPlayingCards()
    selectedCards.removeAll()
    score = 0
  }
  
  mutating func markMatchedCards(){
    assert(selectedCards.count == 3,
           "Error: func markMatchedCards() expected three cards to be selected!")
    
    for card in selectedCards {
      guard let matchIndex = playableCards.firstIndex(of: card) else {
        print("Error: selected card not found in the playable cards!")
        continue
      }
      
      /* Explicitly Unwrapped since we know matchIndex is valid */
      playableCards[matchIndex].isMatched = true
    }
  }
  
  /* Uh-oh, you didn't match correctly */
  mutating func markBadSet(){
    assert(selectedCards.count == 3,
           "Error: func markMatchedCards() expected three cards to be selected!")
    
    for card in selectedCards {
      guard let matchIndex = playableCards.firstIndex(of: card) else {
        print("Error: selected card not found in the playable cards!")
        continue
      }
      
      /* Explicitly Unwrapped since we know matchIndex is valid */
      playableCards[matchIndex].inBadSet = true
    }
  }
  
  func ableToDeal() -> Bool
  {
    
    /* Ideally should be a multiple of 3, but just need to see if
     any cards are available to be dealt */
    return cardDeck.count > 0
  }
  
  mutating func replaceThreeSelectedCards()
  {
    assert(selectedCards.count == 3,
           "Error: func replaceCards() expected three cards to be selected!")
    
    /* Place cards in the discardPile */
    for card in selectedCards {
      
      /* Mark card as matched */
      guard let removeIndex = playableCards.firstIndex(of: card) else {
        print("Error: selected card not found in the playable cards")
        continue
      }
      
      /* Replace the matched card */
      if cardDeck.count > 0 {
        discardPile.append(playableCards[removeIndex])
        playableCards[removeIndex] = cardDeck.removeFirst()
      }
      else {
        let removedCard = playableCards.remove(at: removeIndex)
        discardPile.append(removedCard)
        assert(card == removedCard,
               "Error: card removed is NOT the a selected card!")
      }
    }
    
    /* Make sure there are no more selected cards now */
    selectedCards.removeAll()
  }
  
  mutating func deselectThreeCards()
  {
    /* overwrite previous selected indices with new cards */
    for card in selectedCards {
      
      /* Find card to deselect */
      guard let deselectIndex = playableCards.firstIndex(of: card) else {
        print("Error: selected card not found in the playable cards")
        continue
      }
      
      playableCards[deselectIndex].isSelected = false
      playableCards[deselectIndex].inBadSet = false
    }
    
    /* Make sure there are no more selected cards now */
    selectedCards.removeAll()
  }
  
  /**
   Card is "put back" in the game
   */
  mutating func deselectCard(_ card: SetCard)
  {
    guard let indexToDeselect = playableCards.firstIndex(of: card) else {
      print("Could not find card in the set of playable cards!")
      return
    }
    
    playableCards[indexToDeselect].isSelected = false
  }
  
  
  /**
   Card is selected in the game
   */
  mutating func selectCard(_ viewCard: SetCard)
  {
    guard let index = playableCards.firstIndex(of: viewCard) else {
      print("Could not find card \(viewCard) in the playable cards")
      return
    }
    
    print("Card \(viewCard) was selected")
    
    let card = playableCards[index]
    
    if !selectedCards.contains(card) && !card.isMatched {
      /* Put card in selected cards array */
      selectedCards.append(card)
      playableCards[index].isSelected = true
      
      /* If three cards are selected, check for a match */
      if selectedCards.count == 3 {
        let validSet = isValidSet()
        
        if validSet {
          score += 3
          markMatchedCards()
        }
        else {
          score -= 5
          markBadSet()
        }
      }
      else if selectedCards.count > 3 {
        /* Remove card at the end of the array, so it will not get replaced */
        let cardToKeep = selectedCards.removeLast()
        
        /* Replace the selected cards, clears selected cards as well */
        if isValidSet(){
          replaceThreeSelectedCards()
        }
        else{
          deselectThreeCards()
        }
        
        /* Put the removed card back */
        selectedCards.append(cardToKeep)
      }
    }
    else if selectedCards.contains(card),
            let indexToDeselect = selectedCards.firstIndex(of: card) {
      /* Deselect a selected card */
      if selectedCards.count < 3 {
        selectedCards.remove(at: indexToDeselect)
        deselectCard(card)
      }
      else if selectedCards.count == 3 && !isValidSet() {
        let cardToKeep = selectedCards[indexToDeselect]
        deselectThreeCards()
        selectedCards.append(cardToKeep)
        playableCards[index].isSelected = true
      }
    }
  }
  
  /**
   Shuffle the playing cards, help user find a new match
   */
  mutating func shufflePlayableCards()
  {
    playableCards.shuffle()
  }
  
  /**
   Change the model by dealing 3 more cards into the game
   */
  mutating func dealThreeCards()
  {
    /* Make sure set was valid before replacing 3 selected cards */
    if selectedCards.count == 3 && isValidSet(){
      /* overwrite previous selected indices with new cards */
      replaceThreeSelectedCards()
      
      /* Don't need to continue once three cards are replaced */
      return
    }
    
    /* Deal three cards if any are left in the deck */
    if !cardDeck.isEmpty{
      
      /* Since deck is multiple of three, can always deal 3 */
      for _ in 0 ..< 3 {
        /* No longer relies on statically allocated array */
        playableCards.append(cardDeck.removeFirst())
      }
    }
  }
  
  /**
   Determine if a set of 3 cards is valid
   */
  func isValidSet() -> Bool{
    assert(selectedCards.count == 3,
           "Error: isValidSet expected 3 cards to be selected, but \(selectedCards.count) cards were selected.")
    
    return checkValidNumbers() && checkValidShapes() &&
      checkValidShades() && checkValidColors()
  }
  
  /**
   Check the number of symbols property for a valid match
   */
  private func checkValidNumbers() -> Bool{
    if(selectedCards[0].number == selectedCards[1].number) &&
        (selectedCards[0].number == selectedCards[2].number) {
      return true
    }
    else if(selectedCards[0].number != selectedCards[1].number) &&
            (selectedCards[1].number != selectedCards[2].number) &&
            (selectedCards[0].number != selectedCards[2].number) {
      return true
    }
    
    return false
  }
  
  /**
   Check the shape property for a valid match
   */
  private func checkValidShapes() -> Bool {
    if(selectedCards[0].shape == selectedCards[1].shape) &&
        (selectedCards[0].shape == selectedCards[2].shape)
    {
      return true
    }
    else if(selectedCards[0].shape != selectedCards[1].shape) &&
            (selectedCards[1].shape != selectedCards[2].shape) &&
            (selectedCards[0].shape != selectedCards[2].shape)
    {
      return true
    }
    
    return false
  }
  
  /**
   Check the shading property for a valid match
   */
  private func checkValidShades() -> Bool {
    if(selectedCards[0].style == selectedCards[1].style) &&
        (selectedCards[0].style == selectedCards[2].style)
    {
      return true
    }
    else if(selectedCards[0].style != selectedCards[1].style) &&
            (selectedCards[1].style != selectedCards[2].style) &&
            (selectedCards[0].style != selectedCards[2].style)
    {
      return true
    }
    
    return false
  }
  
  /**
   Check the color property for a valid match
   */
  private func checkValidColors() -> Bool {
    if(selectedCards[0].color == selectedCards[1].color) &&
        (selectedCards[0].color == selectedCards[2].color)
    {
      return true
    }
    else if(selectedCards[0].color != selectedCards[1].color) &&
            (selectedCards[1].color != selectedCards[2].color) &&
            (selectedCards[0].color != selectedCards[2].color)
    {
      return true
    }
    
    return false
  }
}
