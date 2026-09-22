//
//  RoutingQueue.swift
//  SwiftRouting
//
//  Created by Elie Melki on 17/03/2025.
//

import Foundation
public typealias SerialQueueOperation<T> = @MainActor () async -> T

@MainActor
public final class SerialQueue {
    private var isExecuting = false
    private var waiters: [CheckedContinuation<Void, Never>] = []

    public init() {}

    public func execute<T>(operation: SerialQueueOperation<T>) async -> T {
        if isExecuting {
            await withCheckedContinuation { waiters.append($0) }
        }else {
            isExecuting = true
        }

        defer {
            if waiters.isEmpty {
                isExecuting = false
            }else {
                waiters.removeFirst().resume()
            }
        }

        return await operation()
    }
}
