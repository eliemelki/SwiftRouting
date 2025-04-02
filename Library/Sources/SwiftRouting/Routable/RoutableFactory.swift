//
//  RoutableFactory.swift
//  SwiftRouting
//
//  Created by Elie Melki on 21/03/2025.
//
import SwiftUI
/**
  Helper to create Routable inline.
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
 
 //you could use

 let routable = RoutableFactory {
    return TestView()
 }
 */
public class RoutableFactory<V>: Routable, HashableByType where  V: View {
    public let resolver: () -> V
    public init(resolver: @escaping () -> V) {
        self.resolver = resolver
    }

    public func createView() -> V {
        return resolver()
    }
}
