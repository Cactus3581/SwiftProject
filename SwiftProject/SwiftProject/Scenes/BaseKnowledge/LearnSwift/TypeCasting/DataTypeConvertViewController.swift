//
//  TypeCastingViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class TypeCastingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    //MARK:类型检查:判断某个对象是否是某个类的对象。类似OC的 isKindOfClass 。
    func use_is() {
        let name:String = "cactus"

        let item = Movie(name: "Casablanca", director: "Michael Curtiz")
        let item1 = Song(name: "Blue Suede Shoes", artist: "Elvis Presley")

        if item is Movie {
            print(item)
        }

        if item1 is Song {
            print(item1)
        }

        if item1 is MediaItem {
            print(item1)
        }
    }

    //MARK:向下类型转换as？as，父类对象转为子类对象

    func use_as() {
        let item:MediaItem = Movie(name: "Casablanca", director: "Michael Curtiz")

        if let movie = item as? Movie {
            print("Movie: '\(movie.name)', dir. \(movie.director)")
        }
        let movie = item as! Movie
        print("Movie: '\(movie.name)', dir. \(movie.director)")
    }


    //MARK:向下类型转换as，从子类对象转换为父类对象
    func use_as1() {

        class Animal {}
        class Cat: Animal {}
        let cat = Cat()
        let animal = cat as Animal

        // switch 语句中进行模式匹配：如果不知道一个对象是什么类型，你可以通过switch语法检测它的类型，并且尝试在不同的情况下使用对应的类型进行相应的处理。
        switch animal {
        case let cat as Cat:
            print("如果是Cat类型对象，则做相应处理")
        case let dog as Dog:
            print("如果是Dog类型对象，则做相应处理")
        default: break
        }

        //还可以消除二义性，比如数值类型转换
        let num1 = 42 as Double
    }


    //MARK:Any 和 AnyObject 的类型转换
    func use_any() {

        /*
         - AnyObject:可以表示任何一个类的实例。经常用于对象类型
         - Any:可以表示任何类型，包括函数类型。经常用于值类型，比如 Int、结构体、String、Array
         AnyObject是Any的子集
         */

        var things = [Any]()

        things.append(0)
        things.append(0.0)
        things.append(42)
        things.append(3.14159)
        things.append("hello")
        things.append((3.0, 5.0))
        things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
        things.append({ (name: String) -> String in "Hello, \(name)" })

        for thing in things {
            switch thing {
            case 0 as Int:
                print("zero as an Int")
            case 0 as Double:
                print("zero as a Double")
            case let someInt as Int:
                print("an integer value of \(someInt)")
            case let someDouble as Double where someDouble > 0:
                print("a positive double value of \(someDouble)")
            case is Double:
                print("some other double value that I don't want to print")
            case let someString as String:
                print("a string value of \"\(someString)\"")
            case let (x, y) as (Double, Double):
                print("an (x, y) point at \(x), \(y)")
            case let movie as Movie:
                print("a movie called \(movie.name), dir. \(movie.director)")
            case let stringConverter as (String) -> String:
                print(stringConverter("Michael"))
            default:
                print("something else")
            }
        }
    }

}

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}
