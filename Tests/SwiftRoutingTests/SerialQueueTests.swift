//
//  SerialQueueTests.swift
//  SwiftRouting
//
//  Created by Elie Melki on 29/05/2025.
//
@testable import SwiftRouting
import Testing

actor ResultRecorder {
    var result: [Int] = []

    func append(_ value: Int) {
        result.append(value)
    }

    func get() -> [Int] {
        return result
    }
}


@Test func testSerialExecutionOrder() async {
    let queue = await SerialQueue()
    let recorder = ResultRecorder()
    
    async let first: Void = queue.execute {
        try? await Task.sleep(nanoseconds: 200_000_000) // 200ms
        await recorder.append(1)
    }
    
    async let second: Void = queue.execute {
        await recorder.append(2)
    }
    
    _ = await (first, second)
    
    let result = await recorder.get()
    #expect(result == [1, 2])
}

@Test func testExecutionReturnsCorrectValue() async {
    let queue = await SerialQueue()
    
    let result: Int = await queue.execute {
        return 42
    }
    
    #expect(result == 42)
}

@Test func testMultipleExecutions() async {
    let queue = await SerialQueue()
    var results: [Int] = []
    
    for i in 0..<5 {
    
        async let result: Void = queue.execute {
            results.append(i)
        }
        _ = await result

    }
    
    #expect(results == [0, 1, 2, 3, 4])
}


