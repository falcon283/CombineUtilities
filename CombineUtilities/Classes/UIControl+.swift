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

    private var eventHandlers: NSMutableDictionary? {
        get {
            if let dictionary = objc_getAssociatedObject(self, &PublisherAssociatedValues.eventHandlers) as? NSMutableDictionary {
                return dictionary
            } else {
                let dictionary = NSMutableDictionary()
                objc_setAssociatedObject(self, &PublisherAssociatedValues.eventHandlers, dictionary, .OBJC_ASSOCIATION_RETAIN)
                return dictionary
            }
        }
    }

    func publisher(for events: UIControl.Event) -> AnyPublisher<Void, Never> {

        class EventHandler {

            let identifier = NSUUID()
            let subscriber: AnySubscriber<Void, Never>

            init(for subscriber: AnySubscriber<Void, Never>) {
                self.subscriber = subscriber
            }

            @objc func onEvent(sender: AnyObject, event: UIControl.Event) {
                _ = subscriber.receive(())
            }
        }

        return AnyPublisher<Void, Never> { [weak self] subscriber in
            let eventHandler = EventHandler(for: subscriber)

            subscriber.receive {
                return Subscriptions.AnySubscription(task: { _ in
                    self?.addTarget(eventHandler, action: #selector(EventHandler.onEvent(sender:event:)), for: events)
                    self?.eventHandlers?.setObject(eventHandler, forKey: eventHandler.identifier)
                }, onCancelled: {
                    self?.removeTarget(eventHandler, action: #selector(EventHandler.onEvent(sender:event:)), for: events)
                    self?.eventHandlers?.removeObject(forKey: eventHandler.identifier)
                })
            }
        }
    }
}
