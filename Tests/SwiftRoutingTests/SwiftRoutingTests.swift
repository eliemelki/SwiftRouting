//import Testing
////@testable import SwiftRouting
////import Foundation
////
////@globalActor actor CustomActor : GlobalActor {
////    static var shared = CustomActor()
////}
////
////
////
////func printIsolation(isolation:  (any Actor)? = #isolation, _ context: String)  {
////    print("\(context):\(isolation.debugDescription)")
////    print("\(context):\(Thread.current.description)")
////
////}
////
////typealias myClosure = (isolated (any Actor)) async -> Void
////
////func myClosureWrapper(isolation:  (any Actor)? = #isolation, closure: myClosure) async {
////    let iso = isolation ?? MainActor.shared
////    await closure(iso)
////}
////
////func transfer(_ queue: isolated any Actor) async {
////   // queue.operations.removeAll()
////    printIsolation("4")
////}
////
////public actor RoutingQueueX {
////    var operations: [Waitable] = []
////    
////    func notOnActor(_ context: String, _ g: @escaping () async -> Void) async {
////  
////        await self.execute(context, g)
//////        printIsolation("\(context)-notOnActor execute")
//////        try? await Task.sleep(for: .seconds(1))
//////        printIsolation("\(context)-notOnActor execute2")
//////        await g()
////    }
////    
////    func execute<T: Sendable>(_ context: String = "Actor",_ g: @escaping () async -> T) async -> T {
////        //printIsolation("\(context)-execute")
////        
////        
////        let task = Task.init(operation: {
////            //printIsolation("\(context)-task")
////       
////        })
////        
//////        await notOnActor(context) {
//////            printIsolation("\(context)-notOnActor closure execute")
//////            v()
//////        }
////        
////        operations.append(task)
////        operations.removeFirst()
////        self.operations = []
////        printIsolation("\(context)-execute end")
////        return await g()
////    }
////    
////    func t() {
////        printIsolation("t closure execute")
////        self.operations = []
////    }
////    
////    
////  
////}
////
////@MainActor
////class Example {
////
////    var x = 1
////    let routingQueue = RoutingQueueX()
//////    func test(_ actor: isolated (any Actor)) async {
//////        let routingQueue = RoutingQueueX()
//////           var x = 1
//////        let context = actor
//////        printIsolation("\(context)")
//////        let v = {
//////            printIsolation("\(context)-v")
//////            x += 1
//////        }
//////        
//////        Task.init(operation: {
//////            printIsolation("\(context)-Task")
//////  
//////        })
//////        
//////        Task { [actor]
//////            await routingQueue.notOnActor("\(context)", v)
//////        }
//////        printIsolation("\(context)-end")
//////    }
////    
////    func test4(object: AnyObject) async {
////        
////    }
////    
////    func test1(object: AnyObject) async {
////        let context = "Main"
////        printIsolation("\(context)-Example test")
////        Task {
////            printIsolation("\(context)-Task Example test")
////        }
////        
////        let v: @MainActor () async -> Sendable = {
////            printIsolation("\(context)--v")
////            self.x += 1
////            await self.test4(object: object)
////            return
////        }
////        
////        await routingQueue.execute(context,v)
////        
////        printIsolation("\(context)-Example test end")
////    }
////    
//////    @CustomActor
//////    func test2() async {
//////        let context = "Custom"
//////        printIsolation("\(context)-Example test")
//////        let routingQueue = RoutingQueueX()
//////    
//////        
//////        let v = { @CustomActor in
//////            printIsolation("\(context)--v")
//////        }
//////        Task {
//////            printIsolation("\(context)-Task Example test")
//////            v()
//////        }
//////       
//////        
//////        await routingQueue.notOnActor(context,v)
//////      
//////        printIsolation("\(context)-Example test end")
//////    }
////}
////
////
////@MainActor
////@Test func example() async throws {
////
//////    let t = Task {
//////        await queue.execute()
//////
//////    }
////////    let t1 = Task {
////////        print("y")
////////        await queue.execute(2)
////////
////////    }
//////    let m:myClosure =  { iso in
//////        printIsolation("5")
//////    }
//////    
//////    await myClosureWrapper(closure: m)
//////    await transfer(MainActor.shared)
//////    await t.value
////    //await t1.value
////    await Task {
////        //await Example().test(MainActor.shared)
////        await Example().test1(object: MyClass())
//////        await Example().test2()
////    }.value
////
////    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
////}
////
////class MyClass {
////    var count = 1
////}
////func exampleFunc() async {
////  let isNotSendable = MyClass()
////
////  Task {
////    isNotSendable.count += 1
////  }
////}
////
////func notOnActor(_ g: @escaping () async -> Void) async {
////    await g()
////}
////
////
////
//
//
//
////
////
////
////
////struct myClass2 {
////    @CustomWrapper var count: Int
////    
////    func test() {
////        count += 1
////    }
////}
////
////
////struct myClass4 {
////    var count: CustomWrapper<Int>
////    
////    func test() {
////        count.t()
////    }
////}
////
////
////
////struct myClass {
////    var count: State<Int>
////    
////    init(count: State<Int>) {
////        self.count = count
////    }
////    
////    func test() {
////        count.wrappedValue += 1
////    }
////}
////
////
////struct myClassX {
////    @State var count: Int
////    
////    func test() {
////        count += 1
////    }
////}
////
////struct SimpleStruct {
////    var anotherFlag: Bool {
////        get {
////            _anotherFlag = true
////            return _anotherFlag
////        }
////    }
////
////    private var _anotherFlag: Bool {
////        get { return storage.pointee }
////        nonmutating set { storage.pointee = newValue }
////    }
////
////    private let storage = UnsafeMutablePointer<Bool>.allocate(capacity: 1)
////}
//import SwiftUI
//import Combine
//import Testing
//
//class T: ObservableObject {
//    @Published var value: Int = 0
//    var x: Int = 2
//    @XPublished var  d = 1
//    
//    func ttt() {
//        
//        
//    }
//  
//}
//
//@dynamicCallable
//struct RandomNumberGenerator {
//    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double {
//
//        let numberOfZeroes = Double(args.first?.value ?? 0)
//        let maximum = pow(10, numberOfZeroes)
//        return Double.random(in: 0...maximum)
//    }
//}
//
////@MainActor
////@dynamicMemberLookup
////struct XX {
////    @ObservedObject var t: T = .init()
////  
////    
////    func ss() {
////        let v = $t.x
////       
////        
////    }
////}
////
////@ObservedObject
////@Binding
////@Published
////@StateObject
////@State
////@Bindable
//
//@dynamicMemberLookup public struct Wrapper{
//
//
//    /// Gets a binding to the value of a specified key path.
//    ///
//    /// - Parameter keyPath: A key path to a specific  value.
//    ///
//    /// - Returns: A new binding.
//    public subscript<T,Subject>(dynamicMember keyPath: KeyPath<T, Subject>) -> String  {
//        return "Elie"
//    }
//       
//}
//
//struct Te : Encodable {
//    let v: Decimal
//}
//
//struct Ve: Encodable {
//    let x: String
//    
//    enum CodingKeys : String, CodingKey {
//        case x
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(x, forKey: .x)
//    }
//}
//
//protocol HasTest {
//    var authenticationData: Int { get }
//}
//
//protocol HasAuthentication {
//    var authenticationData : Authentication<Int> { get set }
//}
//
//extension HasAuthentication where Self: Encodable {
//    mutating func update(authentication: Int) {
//        self.authenticationData.wrappedValue = authentication
//    }
//}
//
//@propertyWrapper
//struct Authentication<Value: Encodable>: Encodable {
//    var wrappedValue: Value
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(wrappedValue)
//    }
//    
//}
//
//
//struct Merged : HasAuthentication, Encodable {
//    var authenticationData: Authentication<Int>
//   
//}
//
//class Closed {
//    var value = 1
//    func getMe() -> Int {
//        var t: Int {
//            get {
//                return value
//            }set {
//                value = newValue
//                print("here")
//            }
//        }
//        t += 1
//        t += 1
//        
//        return t
//    }
//}
//
//@Test func holul() async throws {
//    let x = Closed()
//   
//    var v = x.getMe()
//    v += 1
//    
//    print(v)
//    print(x.value)
//    
//    
//    
////    let myCancellable = x.objectWillChange.sink { v in
////        print(v)
////    }
////    print (x.objectWillChange)
////  
////    x.d = 2
////    let eee = x.d
////    x.d = 3
////
////    let vv = TestMe()
////   
////    let d = [vv].map( \.mybabe )
////    
////    let ddd = vv[keyPath: \.mybabe]
////  
////    let t = Wrapper()
////
////    let te = Te(v: 0.89)
////    
//    let example = Merged( authenticationData: Authentication(wrappedValue: 123))
//    let de = try JSONEncoder().encode(example)
//    print (String(data: de, encoding: .utf8)!)
//    
//
//    
//    // invalidKeyPath == nil
//}
// 
//func xre<Element, T>(element: Element, _ keyPath: KeyPath<Element, T>) -> T {
//    return element[keyPath: keyPath]
//}
//
//extension Sequence {
//    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
//        return map { $0[keyPath: keyPath] }
//    }
//    
//    
//}
//
//class TestMe{
//    let mybabe:Int =  1
//    
//
//    
////    static subscript<T: ObservableObject>(
////        _enclosingInstance instance: T,
////        wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
////        storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
////    ) -> Value {
////        get {
////            
////        }set {
////          
////        }
////    }
//}
//
//@propertyWrapper
//struct XPublished<Value> {
//    static subscript<T: ObservableObject>(
//        _enclosingInstance instance: T,
//        wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
//        storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
//    ) -> Value {
//        get {
//            instance[keyPath: storageKeyPath].storage
//        }
//        set {
//            let publisher = instance.objectWillChange
//// This assumption is definitely not safe to make in
//// production code, but it's fine for this demo purpose:
//(publisher as! ObservableObjectPublisher).send()
//
//instance[keyPath: storageKeyPath].storage = newValue
//        }
//    }
//
//    @available(*, unavailable,
//        message: "@Published can only be applied to classes"
//    )
//    var wrappedValue: Value {
//        get { fatalError() }
//        set { fatalError() }
//    }
//
//    private var storage: Value
//
//    init(wrappedValue: Value) {
//        storage = wrappedValue
//    }
//}
//
//protocol HasInt {
//    var intValue: Int { get set }
//}
//
//protocol HasDecimal {
//    var decimalValue: Double { get set }
//}
//
//
//struct ComplexObject: HasInt, HasDecimal {
//    var intValue: Int
//    var decimalValue: Double
//}
//
//struct Generic<T> {
//    var element: T
//}
//
//protocol Parent {
//    
//}
//
//protocol Child1: Parent {
//    
//}
//
//protocol Child2: Parent {
//    
//}
//
//
////Object -> Int
////Object -> String
//
////Array<Object> = [Int, String]
//
////
////@Test func generics()  {
////    
////    let hasInt: HasInt = ComplexObject(intValue: 1, decimalValue: 1)
////    let hasDecimal: HasDecimal = ComplexObject(intValue: 1, decimalValue: 1)
////    let complex: ComplexObject = ComplexObject(intValue: 1, decimalValue: 1)
////    
////    let constraintToHasInt:HasInt = complex
////    
////    let genericComplex:Generic<ComplexObject> = Generic(element: complex)
////    var genericHasInt:Generic<HasInt> = genericComplex
////    
////
////    var arrayComplex: Array<ComplexObject> = [complex]
////    var arrayInt: Array<HasInt> = arrayComplex
////    
////}
////
//
//
//@propertyWrapper
//struct SharedStorage<Value> {
//    var anyCancellable: AnyCancellable? = nil
//    var valueCancellable: AnyCancellable? = nil
//    let subject: CurrentValueSubject<Value, Never>
//    
//    init(wrappedValue: Value) {
//        self.init(subject: .init(wrappedValue))
//    }
//    
//    private init(subject: CurrentValueSubject<Value, Never>) {
//        self.subject = subject
//    }
//    
//    var wrappedValue: Value {
//        get {
//            return subject.value
//        }set {
//            subject.value = newValue
//        }
//    }
//    
//    var projectedValue: SharedStorage<Value> {
//        self
//    }
//   
//    
//    mutating func subscribe<T: ObservableObject>(enclosingType: T) where T.ObjectWillChangePublisher : ObservableObjectPublisher {
//        weak var enclosingType = enclosingType
//        if let value = subject.value as? (any ObservableObject),
//           let publisher = value.objectWillChange as? ObservableObjectPublisher {
//            print("schedules")
//            valueCancellable = publisher.sink {
//                 print("Here")
//                enclosingType?.objectWillChange.send()
//            }
//        }
//        self.anyCancellable = subject.dropFirst().sink { _ in
//            print(enclosingType)
//            enclosingType?.objectWillChange.send()
//        }
//    }
//}
//
//class observed: ObservableObject {
//    
//}
//
//struct SomeData {
//    var x: Int
//}
//
//struct StateView : View {
//    @State var state: SomeData = .init(x: 1)
//    
//    var body: some View {
//        Text("\(state.x)")
// 
//    }
//    @SceneBuilder func m() -> some Scene {
//        WindowGroup {
//            
//        }
//        
//    }
//}
//
//class Object: ObservableObject {
//    @Published var x: Int
//    
//    init(x: Int) {
//        self.x = x
//    }
//}
//struct StateObjectView : View {
//    @StateObject var state: Object = .init(x:1)
//    
//    var body: some View {
//        Text("\(state.x)")
//    }
//}
//
//struct ObservedObjectView : View {
//    @ObservedObject var state: Object = .init(x:1)
//    
//    var body: some View {
//        Text("\(state.x)")
//    }
//    
//   
//}
//
//@MainActor
//@Test func TestSharedStorage() async  {
//
//    
//    let ui = StateView()
//    ui.state.x = 10
//    print(ui.state)
//    dump(ui.state)
//    let v = ui.body
//    print(v)
//    dump(ui.body)
//    dump(ui.m())
//}
//
//@MainActor
//@Test func TestSharedObjectStorage() async  {
//    let state = StateObject(wrappedValue: Object(x: 3))
//    state.wrappedValue.x = 10
//    
//    
//    print(state.wrappedValue.x)
//    
//    let ui = StateObjectView(state:  Object(x: 3))
//    ui.state.x = 10
//    print(ui.state.x)
//    
//    dump(ui.body)
//}
//
//
//
//@MainActor
//@Test func TestObvservedObjectStorage() async  {
//    let state = ObservedObject(wrappedValue: Object(x: 1))
//    state.wrappedValue.x = 10
//    
//    
//    print(state.wrappedValue.x)
//    
//    var ui = ObservedObjectView()
//    ui.state = .init(x: 10)
//    print(ui.state.x)
//    dump(ui.body)
//
//
//}
//
//@propertyWrapper
//struct MyState<Value>: DynamicProperty {
//    private var _value: Value
//    private var _location: AnyLocation<Value>?
//    
//    init(wrappedValue: Value) {
//        self._value = wrappedValue
//      
//    }
//    
//    var wrappedValue: Value {
//        get { _location?._value.pointee ?? _value }
//        nonmutating set { _location?._value.pointee = newValue }
//    }
//    
//    var projectedValue: Binding<Value> {
//        Binding<Value>(
//            get: { self.wrappedValue },
//            set: { self._location?._value.pointee = $0 }
//        )
//    }
//    
//    func update() {
//        print("Redraw view")
//    }
//}
//
//class AnyLocation<Value> {
//    let _value = UnsafeMutablePointer<Value>.allocate(capacity: 1)
//    init(value: Value) {
//        self._value.pointee = value
//    }
//}
//
//
//@MainActor
//@Test func MutableSTringTest() async  {
//    var x = MutableStruct()
//    test(t: &x)
//    print(x.x)
//    
//}
//
//struct MutableStruct {
//    var x = 1
//}
//
//func test( t:inout MutableStruct) {
//    t.x = 3
//}
//
//@MainActor
//@Test func subclassStatis() async  {
//     Sub.a()
//    
//}
//
//protocol ParentX {
//    static func list()
//}
//
//extension ParentX {
//    static func list() {
//        print("from parent")
//    }
//    
//    static func a() {
//        print("from parent")
//    }
//}
//
//struct Sub : ParentX {
//    
//    static func list() {
//
//        print("from Sub")
//    }
//    static func a() {
//        print("from a Sub")
//    }
//}
