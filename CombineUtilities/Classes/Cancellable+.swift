//
//  Cancellable+.swift
//  CombineUtilities
//
//  Created by Gabriele Trabucco on 18/06/2019.
//  Copyright © 2019 Gabriele Trabucco. All rights reserved.
//

import Combine

public class CancellableBag: Cancellable {

    private let lock = os_unfair_lock_t.allocate(capacity: 1)
    private var cancellables: [Cancellable] = []

    public init() {
        lock.initialize(to: os_unfair_lock())
    }

    deinit {
        cancel()
    }

    public func append(_ cancellable: Cancellable) {

        lock.execute {
            cancellables.append(cancellable)
        }
    }

    public func cancel() {
        lock.execute {
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

extension UnsafeMutablePointer where Pointee == os_unfair_lock_s {

    func execute(execute: () -> Void) {
        os_unfair_lock_lock(self)
        execute()
        os_unfair_lock_unlock(self)
    }
}
