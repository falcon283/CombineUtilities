//
//  Task.swift
//  CombineUtilitiesExample
//
//  Created by Gabriele Trabucco on 18/06/2019.
//  Copyright © 2019 Gabriele Trabucco. All rights reserved.
//

import Foundation

class CancellableTask {

    private let queue = DispatchQueue.init(label: "Serial")
    private var item: DispatchWorkItem?

    func start(async: @escaping () -> Void) {
        item?.cancel()
        item = somethingAsync(async)
    }

    func cancel() {
        item?.cancel()
        item = nil
    }

    private func somethingAsync(_ async: @escaping () -> Void) -> DispatchWorkItem {
        let item = DispatchWorkItem {
            async()
        }

        queue.asyncAfter(deadline: .now() + .seconds(2), execute: item)
        return item
    }
}
