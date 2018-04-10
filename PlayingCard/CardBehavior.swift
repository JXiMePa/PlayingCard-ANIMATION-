//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by Tarasenco Jurik on 30.03.2018.
//  Copyright © 2018 Tarasenco Jurik. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {

    lazy var collisionBehavior: UICollisionBehavior = { //init with clouser
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }() // предоставляет указанному массиву динамических элементов возможность участвовать в столкновениях друг с другом и с указанными границами поведения.
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    private func push(_ item: UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat(arc4random_uniform(UInt32(2*CGFloat.pi)))
        push.magnitude = 1.0 + CGFloat(arc4random_uniform(UInt32(2)))
        push.action = { [unowned push, weak self] in  /// memory cycle breake
        self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
        push(item)
    }
    override init() {
         super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

