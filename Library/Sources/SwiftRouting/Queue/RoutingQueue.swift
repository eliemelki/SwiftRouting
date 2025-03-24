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
    
    public func execute<T: Sendable>(@_inheritActorContext operation: @escaping RoutingQueueOperation<T>) async -> T {
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
    
//  if you dont want to use @_inheritActorContext, you will need to uncomment the below and call it instead. The below could cause
//  Data race in case it was called from a non isolated environment.
//  Refer to this https://forums.swift.org/t/closure-isolation-inheritance-issues/78703 for more info
//   func execute<T: Sendable>(isolation: isolated (any Actor)? = #isolation,_ operation: @escaping RoutingQueueOperation<T>) async -> T {
//        return await Task {
//            let _ = isolation
//            return await self._execute(operation: operation)
//        }.value
//    }
}
