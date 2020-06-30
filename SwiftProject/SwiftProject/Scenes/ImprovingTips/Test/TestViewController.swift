//
//  TestViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/6/24.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class TestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let playerVC = AVPlayerViewController()
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "testAudio", ofType: "m4a") ?? ""))
        playerVC.player = player
        addChild(playerVC)
        view.addSubview(playerVC.view)
        playerVC.view.frame = view.bounds

//        AVAudioSession.sharedInstance().category,
//        AVAudioSession.sharedInstance().mode,
//        AVAudioSession.sharedInstance().categoryOptions
//        try? AVAudioSession.sharedInstance().setActive(true)
//
//        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
//

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback)
//        try? session.setActive(true, options: .notifyOthersOnDeactivation)

//        player.addObserver(self, forKeyPath: "status", options: [.new], context: nil)

        let b = 0
        let c = true

        let a = b > 0 ? (c ? 1 : 2) : 3
        print(a)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let key = keyPath, key == "status", let status = change?[.newKey] as? Int, status == AVPlayer.Status.readyToPlay.rawValue {
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playback)
//            try? session.setActive(true)
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }

}
