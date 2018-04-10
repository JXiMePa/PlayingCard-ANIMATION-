//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Tarasenco Jurik on 13.03.2018.
//  Copyright © 2018 Tarasenco Jurik. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    //CustomStringConvertible- протокол преобразовании экземпляра в строку(for "print()")
    //(var description)
    var description: String {return "\(rank)\(suit)"}

    
    var suit: Suit
    var rank: Rank
    
    // Масть
    enum Suit: String, CustomStringConvertible {
        case spades = "♠️"
        case hearts = "♥️"
        case diamonds = "♣️"
        case clubs = "♦️"
        
        static var all = [Suit.spades, .hearts, .diamonds, .clubs]
        
        var description: String { return rawValue }
        //CustomStringConvertible
    }
    // Ранг
    enum Rank: CustomStringConvertible {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank] {
            get { //!
                var allRanks = [Rank.ace]
                for pips in 2...10 {
                    allRanks.append(Rank.numeric(pips))
                }
                allRanks += [Rank.face("J"),.face("Q"),.face("K")]
                return allRanks
            }
        }
        
        var description: String {
            //CustomStringConvertible
            switch self  {
            case .ace: return "A"
            case .numeric(let nomerKarty): return String(nomerKarty)
            case .face(let kind): return kind
            }
        }
    }
}
