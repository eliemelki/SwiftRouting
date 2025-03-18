//
//  RoutingQueue.swift
//  SwiftRouting
//
//  Created by Elie Melki on 17/03/2025.
//

import Foundation


public typealias RoutingQueueOperation = () async -> Void

typealias IsolatedClosure<each Input, Output> = ((isolated Actor?, repeat each Input) async throws -> Output)

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
@globalActor public actor StorageActor: GlobalActor {
    public static let shared = StorageActor()
}

@StorageActor
class T {

    func u() async {
        let queue = RoutingQueue()
        let v = { @StorageActor in }
        Task {
            v()
            await queue.execute{ @StorageActor in await self.updateUI() }
        }
        if #available(iOS 17.0, *) {
            DispatchQueue.main.asyncUnsafe {
                 self.updateUI()
            }
        } else {
            // Fallback on earlier versions
        }
        
        func updateUI() async {
            
        }
    }

    @MainActor
    func updateUI() {
        
    }
}


