//
//  Subscriptions+.swift
//  CombineUtilities
//
//  Created by Gabriele Trabucco on 18/06/2019.
//  Copyright © 2019 Gabriele Trabucco. All rights reserved.
//

import Combine

extension Subscriptions {

    public class AnySubscription: Subscription {

        private let task: (Subscribers.Demand) -> Void
        private let onCancelled: () -> Void

        public init(task: @escaping (Subscribers.Demand) -> Void, onCancelled: @escaping () -> Void) {
            self.task = task
            self.onCancelled = onCancelled
        }

        public func request(_ demand: Subscribers.Demand) {
            task(demand)
        }

        public func cancel() {
            onCancelled()
        }
    }
}

public extension Subscriber {

    func receive(subscription: () -> Subscriptions.AnySubscription) {
        receive(subscription: subscription())
    }
}
