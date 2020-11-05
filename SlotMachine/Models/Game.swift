//
//  Game.swift
//  SlotMachine
//
//  Created by Anna Oksanichenko on 03.11.2020.
//

import Foundation

class Game {
    
    static let shared =  Game()
    
    init () {
        self.player =  Player()
        self.analyzer = Analyzer()
        self.counting = Counting()
    }
    
    enum GameState {
        case idle
        case playing
    }
    
    var player : Player
    var analyzer : Analyzer
    var counting : Counting
    var state: GameState = .idle
    var currentTurn: Int = 0
    let maximumTurn: Int = 20
    let minimalGameCost : Int = 25
    var balanceInRound: Int = 0
    let history = History()
    let randomizer = IntRandomizer()
    var triplet = Triplet(randomizer: IntRandomizer())
    
    init(player: Player, analyzer: Analyzer, counting: Counting) {
        self.player = player
        self.analyzer = analyzer
        self.counting = counting
    }
    
    func startGame() -> Bool {
        guard state == .idle else {
            print("The  game is already on")
            return false
        }
        guard player.balance >= minimalGameCost else {
            print("Not enough coins for paying")
            return false
        }
        player.balance -= minimalGameCost
        state = .playing
        currentTurn = 0
        return true
    }
    
    
    
    func nextTurn() -> Bool {
        
        guard currentTurn < maximumTurn else {
            print("Round is over")
            return false
        }
        
        let newTriplet = Triplet(randomizer: IntRandomizer())
        newTriplet.changeDigitsOfTriplet()
        _ = analyzer.getWinningCombinationFromTriplet(triplet: newTriplet)
        _ = counting.countPointsFromCombination(combinations: analyzer.nameOfCombination)
        //        player.balance += counting.currentPointsInRound
        balanceInRound += counting.countPointsFromCombination(combinations: analyzer.nameOfCombination)
        currentTurn += 1
        history.addRecord(triplet: newTriplet, combination: analyzer.nameOfCombination.joined(separator: "\n"), pointsForTurn: counting.countPointsFromCombination(combinations: analyzer.nameOfCombination) )
        self.triplet = newTriplet
        return true
    }
    
    func finishGame() -> Bool {
        
        return true
    }
    
}
