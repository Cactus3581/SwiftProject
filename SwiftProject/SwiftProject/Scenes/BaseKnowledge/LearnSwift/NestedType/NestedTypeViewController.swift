//
//  NestedTypeViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class NestedTypeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        use_s()
    }

    func use_s() {

        // 嵌套定义了一个结构体
        struct BlackjackCard {

            // 嵌套定义了一个枚举
            enum Suit: Character {
                case Spades = "♠", Hearts = "♡", Diamonds = "♢", Clubs = "♣"
            }

            //嵌套定义了一个枚举
            enum Rank: Int {

                case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
                case Jack, Queen, King, Ace

                //在嵌套的枚举里面画又定义了一个结构体
                struct Values {
                    let first: Int, second: Int?
                }

                // 定义了属性，重写了getter方法
                var values: Values {
                    switch self {
                    case .Ace:
                        return Values(first: 1, second: 11)
                    case .Jack, .Queen, .King:
                        return Values(first: 10, second: nil)
                    default:
                        return Values(first: self.rawValue, second: nil)
                    }
                }
            }

            // 定义了属性和方法
            let rank: Rank
            let suit: Suit

            var description: String {
                var output = "suit is \(suit.rawValue),"
                output += " value is \(rank.values.first)"
                if let second = rank.values.second {
                    output += " or \(second)"
                }
                return output
            }
        }

        // 要在定义外部使用内嵌类型，只需在其前缀加上内嵌了它的类的类型名即可：
        let heartsSymbol = BlackjackCard.Suit.Hearts.rawValue
    }
}
