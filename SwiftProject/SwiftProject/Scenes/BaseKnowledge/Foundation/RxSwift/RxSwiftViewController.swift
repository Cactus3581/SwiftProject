//
//  RxSwiftViewController.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/26.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class RxSwiftViewController : BaseViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let disposeBag = DisposeBag()

        usernameLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordLabel.text = "Password has to be at least \(minimalPasswordLength) characters"

        let usernameValid = usernameTextField.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: usernameLabel.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordLabel.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }

    func showAlert() {
        let alertView = UIAlertView(
            title: "RxExample",
            message: "This is wonderful",
            delegate: nil,
            cancelButtonTitle: "OK"
        )

        alertView.show()


        
    }

}
