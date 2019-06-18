//
//  Cancellable+.swift
//  CombineUtilities
//
//  Created by Gabriele Trabucco on 18/06/2019.
//  Copyright © 2019 Gabriele Trabucco. All rights reserved.
//

import Combine

public class CancellableBag: Cancellable {

    private var lockQueue = DispatchQueue(label: "CancellableBag Queue", attributes: .concurrent)
    private var cancellables: [Cancellable] = []

    public init() { }

    deinit {
        cancel()
    }

    public func append(_ cancellable: Cancellable) {

        lockQueue.sync(flags: .barrier) {
            cancellables.append(cancellable)
        }
    }

    public func cancel() {
        lockQueue.sync(flags: .barrier) {
            cancellables.forEach { $0.cancel() }
            cancellables = []
        }
    }
}

public extension Cancellable {

    func cancelled(by bag: CancellableBag) {
        bag.append(self)
    }
}
