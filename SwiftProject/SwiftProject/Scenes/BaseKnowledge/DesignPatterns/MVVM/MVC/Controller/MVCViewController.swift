//
//  MVCViewController.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/29.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

/*
 1. controller：创建view，网络请求，将model封装，然后将model数据给view赋值；view接受事件，然后将事件传递给controller
 2。 model和view不会有任何引用关系

 MVVM
1. 将vc中的逻辑放到viewModel中，减少vc中的代码
2. 方便测试，只需要注入Person对象即可。真实的开发中，视图控制器中的逻辑会非常复杂，通过将逻辑部分移动到viewModel,既方便测试也对视图控制器进行了瘦身。
3. 绑定机制：在view和viewModel之间进行绑定，可以使用闭包或者RxSwift进行响应式编程。通过事件进行绑定操作。通过函数式编程进行各种 Combine 或 Filter。

 */
class MVCViewController: BaseViewController, MVCProtocol {

    lazy var customView: MVCView = MVCView()
    var viewModel: MVVMViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        customView.delegate = self
        view.addSubview(customView)
        customView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let model = MVCModel(firstName: "long", lastName: "hua", birthday: Date())

        customView.nameLabel?.text = model.firstName + model.lastName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        customView.birthdayLabel?.text =  dateFormatter.string(from: model.birthday)

        viewModel = MVVMViewModel(model)
        customView.nameLabel?.text = viewModel.name
        customView.birthdayLabel?.text = viewModel.birthday

//        viewModel.greetingDidChange = { [unowned self] viewModel in
//            //self.greetingLabel.text = viewModel.greeting
//            self.customView.birthdayLabel?.text =  dateFormatter.string(from: model.birthday)
//        }
    }

    func touchBegin() {
        print("customView touchBegin!")
        self.viewModel.showGreeting()
    }
}
