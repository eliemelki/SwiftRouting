//
//  Routable.swift
//  SwiftRouting
//
//  Created by Elie Melki on 07/03/2025.
//

import SwiftUI
/**
    Routable, represents any screen/view that needs to be rendered/shown by a router.
    Its basically a view factory and also needs to be identifiable and hashable.
 
 # Example #
 
 ```
  // Assume you have a TestView. We want to make this view Routable. Meaning we either needs to show it as sheet or maybe push on navigation
 struct TestView : View {
          
     var body: some View {
         VStack {
             Text("Base")
         }
     }
 }
  //To make it Routable you will need to create an instance that comforms to Routable and implement createView to return TestView.
  //We will also needs to make identifiable and hashable. We used below HashableByType which works for class objects.
 class TestViewRoutable : Routable, HashableByType {
     func createView() -> some View {
         return TestView()
     }
 }
 ```

 Another way of creating Routable is by using `RoutableFactory`. One reason to use `RoutableFactory` is to use inline declaration and allow for multiple Routable creation of the same view and probably  with different initialisation configuration.

 */

public typealias Routable = ViewFactory & Hashable & Identifiable

/**
    Routable Type Eraser.Acts also as a wrapper for Routable.
    Routers accepts a Routable, and convert to AnyRoutable for internal use, It also can returns AnyRoutable to caller. 
 */
public class AnyRoutable: Routable, @unchecked Sendable {
    //We are pretty sure that the class is Thread safe as it act as immutable as its property are private and declared as let.
    //If that needs to be changed later we need to revisit the unchecked.
    
    private let base: (any Routable)
    private let equals: (any Routable) -> Bool
    
    public init<T: Routable>(_ routable: T) {
        self.base = routable
        self.equals = { other in
            guard let otherBase = other as? T else { return false }
            return routable == otherBase
        }
    }

    public func createView() -> some View {
        AnyView(base.createView())
    }

    open func hash(into hasher: inout Hasher) {
        self.base.hash(into: &hasher)
    }
    
    public static func == (lhs: AnyRoutable, rhs: AnyRoutable) -> Bool {
        lhs.equals(rhs.base)
    }
}
