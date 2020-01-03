//
//  MVVMViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/29.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

class MVVMViewModel: NSObject {

    var person: MVCModel
    var name: String
    var birthday: String

    init(_ person: MVCModel) {
        self.person = person
        name = person.firstName + person.lastName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthday =  dateFormatter.string(from: person.birthday)
    }

    var greeting: String? {
        didSet {
//            self.greetingDidChange!
        }
    }

    var greetingDidChange: (() -> ())?

    func showGreeting() {
        self.greeting = "Hello" + " " + self.person.firstName + " " + self.person.lastName
    }
}
