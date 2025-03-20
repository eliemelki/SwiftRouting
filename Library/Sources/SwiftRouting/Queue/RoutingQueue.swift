//
//  RoutingQueue.swift
//  SwiftRouting
//
//  Created by Elie Melki on 17/03/2025.
//

import Foundation

public typealias RoutingQueueOperation<T> = () async -> T

public actor RoutingQueue {
    private var operations: [Waitable] = []
    
    private func _execute<T: Sendable>(operation: @escaping RoutingQueueOperation<T>) async -> T {
        let last = operations.last
        
        let task = Task {
            let _ = self
            await last?.waitForCompletion()
            return await operation()
        }
        operations.append(task)
        let value = await task.value
        operations.removeFirst()
        return value
    }
    
    func execute<T: Sendable>(isolation: isolated (any Actor)? = #isolation,_ operation: @escaping RoutingQueueOperation<T>) async -> T {
        return await Task {
            let _ = isolation
            return await self._execute(operation: operation)
        }.value
    }
}

