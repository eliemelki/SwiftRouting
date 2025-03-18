//
//  RoutingQueue.swift
//  SwiftRouting
//
//  Created by Elie Melki on 17/03/2025.
//

import Foundation


public typealias RoutingQueueOperation = () async -> Void


public actor RoutingQueue {
    private var operations: [Task<Void, Never>] = []

    func execute(operation: @escaping RoutingQueueOperation) async {
        
        let last = operations.last
            
        let task = Task {
            let _ = self
            await last?.value
            await operation()
        }
        
        operations.append(task)
        await task.value
        operations.removeFirst()
    }
    
    @MainActor
    func executeW(operation: @escaping RoutingQueueOperation) async {
        let t = Task {
            await self.execute(operation: operation)
        }
        await t.value
    }

}



