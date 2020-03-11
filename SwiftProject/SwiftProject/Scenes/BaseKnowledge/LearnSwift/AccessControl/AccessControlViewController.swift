//
//  AccessControlViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class AccessControlViewController: BaseViewController {

    /*

     访问控制限制其他源文件和模块对你的代码的访问。
    可以对属性，类型，函数等显式指定访问控制级别。
     模块：例如一个pod，需要使用 import 来引入
     源文件：一个.swift文件，一个.swift文件可以包含多个类型

     open public ：被其他模块访问
     internal：模块内部，默认级别
     fileprivate：当前定义源文件中。
     private：限制于封闭声明中


     public：只能在其定义模块中被继承，它的类成员只能被其定义模块的子类重写
     open：仅适用于类和类成员，可以在其他模块中被继承，它的类成员被导入其定义模块的任何模块重写。所以当可以被其他模块继承时可以显式地标记类为 open



     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
