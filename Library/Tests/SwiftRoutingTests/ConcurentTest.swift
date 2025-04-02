//
//  File.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//

import Foundation
import Testing
import SwiftUI
@testable import SwiftRouting

import SwiftUI
@testable import SwiftRouting

import Foundation

final class GlobalActorSerialExecutor: SerialExecutor {
  private let queue = DispatchQueue(label: "MyGlobalActorQueue")

  func enqueue(_ job: UnownedJob) {
      print("here")
    queue.async {
        print("here")
      job.runSynchronously(on: self.asUnownedSerialExecutor())
    }
  }

  func asUnownedSerialExecutor() -> UnownedSerialExecutor {
    return UnownedSerialExecutor(ordinary: self)
  }
}

public actor MyRoutingQueue {
    static var sharedUnownedExecutor: UnownedSerialExecutor =  GlobalActorSerialExecutor().asUnownedSerialExecutor()
    
    
    private var operations: [Waitable] = []
    
    public func execute<T: Sendable>(@_inheritActorContext operation: @escaping RoutingQueueOperation<T>) async -> T {
        print("entered")
     
        for k in 0..<1 {
            let i = k
        }
        let last = operations.last
        
        let task = Task {
            print("entered task")
            let _ = self
            await last?.waitForCompletion()
            return await operation()
        }
        operations.append(task)
        let value = await task.value
        operations.removeFirst()
        return value
    }
}


@Test func testConcurent() async throws {
    let queue = MyRoutingQueue()
    let closure1 = { @MainActor in
        let isolation = #isolation
        print("\(isolation.debugDescription)")
        print("first")
        return 1
    }
    
    let closure2 = { @MainActor in
        let isolation = #isolation
        print("\(isolation.debugDescription)")
        print("Second")
        return 2
    }
    
    let closure3 = { @MainActor in
        let isolation = #isolation
        print("\(isolation.debugDescription)")
        print("Third")
        return 3
    }
    
    let closure4 = { @MainActor in
        let isolation = #isolation
        print("\(isolation.debugDescription)")
        print("Fourth")
        return 4
    }
    
    let t = Task {
        await queue.execute(operation: closure1)
    }
    
    let t1 = Task {
        await queue.execute(operation: closure2)
    }
    
    let t2 = Task{
        await queue.execute(operation: closure3)
    }
    
    let t3 = Task {
        await queue.execute(operation: closure4)
    }
    
    async let v =  t.value
    async let v1 =  t1.value
    async let v2 =  t2.value
    async let v3 =  t3.value
    
    let string = await "\(v) \(v1) \(v2) \(v3)"
    print(string)
}
