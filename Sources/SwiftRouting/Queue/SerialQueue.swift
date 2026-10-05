//
//  SerialQueue.swift
//  SwiftRouting
//
//  Created by Elie Melki on 17/03/2025.
//

import Foundation

/// An operation executed on the main actor by a serial queue.
public typealias SerialQueueOperation<T> = @MainActor () async -> T

/// Runs async operations one at a time in the order they enter the queue.
/// An operation must not await another operation on the same queue.
@MainActor
public final class SerialQueue {
    private var isExecuting = false
    private var waiters: [CheckedContinuation<Void, Never>] = []

    /// Creates an idle queue.
    public init() {
    }

    /// Waits for preceding operations, then runs this operation to completion.
    /// - Parameter operation: The main-actor async work to serialize.
    /// - Returns: The value returned by the operation.
    public func execute<T>(operation: SerialQueueOperation<T>) async -> T {
        if isExecuting {
            await withCheckedContinuation {
                waiters.append($0)
            }
        } else {
            isExecuting = true
        }

        defer {
            if waiters.isEmpty {
                isExecuting = false
            } else {
                waiters.removeFirst().resume()
            }
        }

        return await operation()
    }
}
