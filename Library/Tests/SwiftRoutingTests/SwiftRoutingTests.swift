//import Testing
//@testable import SwiftRouting
//import Foundation
//
//@globalActor actor CustomActor : GlobalActor {
//    static var shared = CustomActor()
//}
//
//
//
//func printIsolation(isolation:  (any Actor)? = #isolation, _ context: String)  {
//    print("\(context):\(isolation.debugDescription)")
//    print("\(context):\(Thread.current.description)")
//
//}
//
//typealias myClosure = (isolated (any Actor)) async -> Void
//
//func myClosureWrapper(isolation:  (any Actor)? = #isolation, closure: myClosure) async {
//    let iso = isolation ?? MainActor.shared
//    await closure(iso)
//}
//
//func transfer(_ queue: isolated any Actor) async {
//   // queue.operations.removeAll()
//    printIsolation("4")
//}
//
//public actor RoutingQueueX {
//    var operations: [Waitable] = []
//    
//    func notOnActor(_ context: String, _ g: @escaping () async -> Void) async {
//  
//        await self.execute(context, g)
////        printIsolation("\(context)-notOnActor execute")
////        try? await Task.sleep(for: .seconds(1))
////        printIsolation("\(context)-notOnActor execute2")
////        await g()
//    }
//    
//    func execute<T: Sendable>(_ context: String = "Actor",_ g: @escaping () async -> T) async -> T {
//        //printIsolation("\(context)-execute")
//        
//        
//        let task = Task.init(operation: {
//            //printIsolation("\(context)-task")
//       
//        })
//        
////        await notOnActor(context) {
////            printIsolation("\(context)-notOnActor closure execute")
////            v()
////        }
//        
//        operations.append(task)
//        operations.removeFirst()
//        self.operations = []
//        printIsolation("\(context)-execute end")
//        return await g()
//    }
//    
//    func t() {
//        printIsolation("t closure execute")
//        self.operations = []
//    }
//    
//    
//  
//}
//
//@MainActor
//class Example {
//
//    var x = 1
//    let routingQueue = RoutingQueueX()
////    func test(_ actor: isolated (any Actor)) async {
////        let routingQueue = RoutingQueueX()
////           var x = 1
////        let context = actor
////        printIsolation("\(context)")
////        let v = {
////            printIsolation("\(context)-v")
////            x += 1
////        }
////        
////        Task.init(operation: {
////            printIsolation("\(context)-Task")
////  
////        })
////        
////        Task { [actor]
////            await routingQueue.notOnActor("\(context)", v)
////        }
////        printIsolation("\(context)-end")
////    }
//    
//    func test4(object: AnyObject) async {
//        
//    }
//    
//    func test1(object: AnyObject) async {
//        let context = "Main"
//        printIsolation("\(context)-Example test")
//        Task {
//            printIsolation("\(context)-Task Example test")
//        }
//        
//        let v: @MainActor () async -> Sendable = {
//            printIsolation("\(context)--v")
//            self.x += 1
//            await self.test4(object: object)
//            return
//        }
//        
//        await routingQueue.execute(context,v)
//        
//        printIsolation("\(context)-Example test end")
//    }
//    
////    @CustomActor
////    func test2() async {
////        let context = "Custom"
////        printIsolation("\(context)-Example test")
////        let routingQueue = RoutingQueueX()
////    
////        
////        let v = { @CustomActor in
////            printIsolation("\(context)--v")
////        }
////        Task {
////            printIsolation("\(context)-Task Example test")
////            v()
////        }
////       
////        
////        await routingQueue.notOnActor(context,v)
////      
////        printIsolation("\(context)-Example test end")
////    }
//}
//
//
//@MainActor
//@Test func example() async throws {
//
////    let t = Task {
////        await queue.execute()
////
////    }
//////    let t1 = Task {
//////        print("y")
//////        await queue.execute(2)
//////
//////    }
////    let m:myClosure =  { iso in
////        printIsolation("5")
////    }
////    
////    await myClosureWrapper(closure: m)
////    await transfer(MainActor.shared)
////    await t.value
//    //await t1.value
//    await Task {
//        //await Example().test(MainActor.shared)
//        await Example().test1(object: MyClass())
////        await Example().test2()
//    }.value
//
//    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//}
//
//class MyClass {
//    var count = 1
//}
//func exampleFunc() async {
//  let isNotSendable = MyClass()
//
//  Task {
//    isNotSendable.count += 1
//  }
//}
//
//func notOnActor(_ g: @escaping () async -> Void) async {
//    await g()
//}
//
//
//
