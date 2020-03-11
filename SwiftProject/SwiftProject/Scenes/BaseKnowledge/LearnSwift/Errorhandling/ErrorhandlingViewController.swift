//
//  ErrorhandlingViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

/*
try 出现异常处理异常
try? 不处理异常,返回一个可选值类型,出现异常返回nil
try! 不让异常继续传播,一旦出现异常程序停止,类似NSAssert()
*/

class ErrorhandlingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        use_try()
        use_defer()
    }

    func use_try() {

        //MARK 1:使用关键字throws标记为抛出函数
        var inventory = [
            "1":[]
        ]

        func vend(itemNamed name: String) throws {
            guard let item = inventory[name] else {
                // 使用throw抛出错误
                throw VendingMachineError.invalidSelection
            }

            guard item.count > 0 else {
                throw VendingMachineError.outOfStock
            }
        }

        //MARK:使用 Do-Catch和try处理错误
        do {
            try vend(itemNamed: "1")
        } catch VendingMachineError.invalidSelection {
            print("Invalid Selection.")
        } catch VendingMachineError.outOfStock {
            print("Out of Stock.")
        } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
            print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
        } catch {
             print("Insufficient funds. Please insert an additional coins.")
        }

        //MARK:转换错误为可选项：使用 try?将错误转换为可选项。如果不想处理异常那么可以用这个关键字,使用这个关键字返回一个可选值类型,如果有异常出现,返回nil.如果没有异常,则返回可选值
        func fetchDataFromDisk() throws -> Int {
            let i = 5
            if  i == 0 {
                throw VendingMachineError.outOfStock
            }
            return 1
        }

        if let data = try? fetchDataFromDisk() {
            print(data)
        } else {
            print("data")
        }

    //MARK:取消错误传递：如果不想处理异常,而且不想让异常继续传播下去,可以使用try!.在可能抛出异常的方法中抛出了异常,那么程序会立刻停止
        let data = try! fetchDataFromDisk()
    }

    //MARK:延迟操作。defer会在该当前声明的作用域结束时候执行
    func use_defer() {
        firstProcesses(true)
    }

    func firstProcesses(_ isOpen: Bool) {

        //作用域1 整个函数作用域
        defer{
            print("推迟操作🐢")
        }

        print("😳")

        if isOpen == true {
            //作用域2 if的作用域
            defer{
                print("推迟操作🐌")
            }
            print("😁")
        }
    }

}

