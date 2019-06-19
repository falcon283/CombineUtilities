//
//  UIControl+.swift
//  CombineUtilities
//
//  Created by Gabriele Trabucco on 18/06/2019.
//  Copyright © 2019 Gabriele Trabucco. All rights reserved.
//

import Combine

public extension UIControl {

    private struct PublisherAssociatedValues {
        static var eventHandlers = 0
    }

    private class EventHandler<Failure: Error> {

        let subscriber: AnySubscriber<Void, Failure>

        init(for subscriber: AnySubscriber<Void, Failure>) {
            self.subscriber = subscriber
        }

        @objc func onEvent(sender: AnyObject, event: UIControl.Event) {
            _ = subscriber.receive(())
        }
    }

    func publisher<Failure: Error>(for events: UIControl.Event) -> AnyPublisher<Void, Failure> {

        return AnyPublisher<Void, Failure> { [weak self] subscriber in
            let eventHandler = EventHandler<Failure>(for: subscriber)

            subscriber.receive {
                return Subscriptions.AnySubscription(task: { _ in
                    self?.addTarget(eventHandler, action: #selector(EventHandler<Failure>.onEvent(sender:event:)), for: events)
                }, onCancelled: {
                    self?.removeTarget(eventHandler, action: #selector(EventHandler<Failure>.onEvent(sender:event:)), for: events)
                })
            }
            }
            .subscribe(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
