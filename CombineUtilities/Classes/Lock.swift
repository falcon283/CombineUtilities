//
//  Lock.swift
//  CombineUtilities
//
//  Created by Gabriele Trabucco on 19/06/2019.
//  Copyright © 2019 Gabriele Trabucco. All rights reserved.
//

import Foundation

class UnfairLock {

    private var lock = os_unfair_lock()

    func execute(closure: () -> Void) {
        os_unfair_lock_lock(&lock)
        closure()
        os_unfair_lock_unlock(&lock)
    }
}
