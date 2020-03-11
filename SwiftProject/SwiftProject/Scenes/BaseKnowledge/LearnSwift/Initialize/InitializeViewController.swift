//
//  InitializeViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class InitializeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        self.vie()
        self.sd()

    }

    func vie()  {
        let namedMeat = Food(name: "Bacon")
        // namedMeat's name is "Bacon"
        let mysteryMeat = Food()


        let oneMysteryItem = RecipeIngredient()
        let oneBacon = RecipeIngredient(name: "Bacon")
        let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)

        var breakfastList = [
            ShoppingListItem(),
            ShoppingListItem(name: "Bacon"),
            ShoppingListItem(name: "Eggs", quantity: 6),
        ]
        breakfastList[0].name = "Orange juice"
        breakfastList[0].purchased = true
        for item in breakfastList {
            print(item.description)
        }
    }

    func sd() {
        let anonymousCreature = Animal1(species: "")
        // anonymousCreature is of type Animal?, not Animal

        if anonymousCreature == nil {
            print("The anonymous creature could not be initialized")
        }
    }
}

// MARK - 类的初始化方法


// MARK - 类的初始化方法
class Food {
    var name: String
    //指定初始化器
    init(name: String) {
        self.name = name
    }
    //便捷初始化器
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }

    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

//MARK - 可失败初始化器


struct Animal1 {
    let species: String
    init?(species: String) {
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}
