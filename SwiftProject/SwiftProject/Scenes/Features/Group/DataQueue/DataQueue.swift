//
//  DataQueue.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/11.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

class DataQueue {

    enum TaskType: String {
        case draging
    }

    private let dataQueue: OperationQueue

    init() {
        self.dataQueue = OperationQueue()
        dataQueue.maxConcurrentOperationCount = 1
        dataQueue.qualityOfService = .userInteractive
    }

    func frozenDataQueue(_ taskType: DataQueue.TaskType) {
        dataQueue.isSuspended = true
    }

    func resumeDataQueue(_ taskType: DataQueue.TaskType) {
        dataQueue.isSuspended = false
    }

    func isQueueState() -> Bool {
        dataQueue.isSuspended
    }

    func addTask(_ task: @escaping () -> Void) {
        let t = { [weak self] in
            task()
        }
        dataQueue.addOperation(t)
    }
}
