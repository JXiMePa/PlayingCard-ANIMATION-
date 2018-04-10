//
//  ViewController.swift
//  PlayingCard
//
//  Created by Tarasenco Jurik on 13.03.2018.
//  Copyright © 2018 Tarasenco Jurik. All rights reserved.

/// В констрейнах - /'соотношение сторон'/'Приоритет'/'
/// Прозрачность вюшки галочка! - oraque
///....@2x , .....@3x - В названиях картинок

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    //MARK:deck екземпляр PlayingCardDeck()
    
    @IBOutlet private var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    //предоставляет связанные с физикой возможности и анимации для своих динамических элементов и предоставляет контекст для этих анимаций.
    lazy var cardBehavior = CardBehavior(in: animator)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cards = [PlayingCard]()//masiv Structur
        
        for _ in 1...((cardViews.count+1)/2) { // okrugluem do Int(13/2=6)
            let card = deck.draw()!//cards - (1 PlayingCard),
            cards += [card, card]
        }
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView) //this stuf in new file
            cardBehavior.addItem(cardView)
           
        }
    }
    
    private var faceUpCardView: [PlayingCardView] {
        return cardViews.filter { $0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
            && $0.alpha == 1
        }
    }
    
    private var faceCardViewMatch: Bool {
        return faceUpCardView.count == 2 &&
            faceUpCardView[0].rank == faceUpCardView[1].rank &&
            faceUpCardView[0].suit == faceUpCardView[1].suit
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardView.count < 2 {
                cardBehavior.removeItem(chosenCardView)
                UIView.transition(with: chosenCardView, duration: 0.7, options: [.transitionFlipFromLeft],
                              animations: { chosenCardView.isFaceUp = !chosenCardView.isFaceUp },
                              
                  completion: { finished in
                    if self.faceCardViewMatch {
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.6,
                            delay: 0,
                            options: [],
                            animations: {
                                self.faceUpCardView.forEach {
                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                }
                           },
                            completion: {position in
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 0.75,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        self.faceUpCardView.forEach {
                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                                            $0.alpha = 0
                                      }
                                },
                                completion: {position in
                                    self.faceUpCardView.forEach {
                                        $0.isHidden = true
                                        $0.alpha = 1
                                        $0.transform = .identity
                                    }
                                }
                                )
                           }
                        )
                    } else if self.faceUpCardView.count == 2 {
                        self.faceUpCardView.forEach { cardViews in
                            UIView.transition(with: cardViews,
                                              duration: 0.6,
                                              options: [.transitionFlipFromLeft],
                                              animations: { cardViews.isFaceUp = false },
                                              completion: { finished in
                                                self.cardBehavior.addItem(cardViews) } )
                     }
                    } else {
                        if !chosenCardView.isFaceUp {
                            self.cardBehavior.addItem(chosenCardView)
                        }
                    }
                }
              )
            }
        default: break
        }
    }
}


