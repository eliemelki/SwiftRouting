# SwiftRouting


SwiftRouting is a Library that abstract different sort of swiftui navigation/routing inside your app. It decouples your navigation logic from your buisness logic and handle internally through default provided implementation. This allows for more testable and decouple implementation.  

## Motivation 

In swiftui, navigation is somehow coupled with ui and business logic layer. This makes a view or a buisness logic tied to a specific navigation. Therefore, the library provided a way where you can implement view and buisness logic seperatly standalone and leave it for a coordinator layer to decide how and where to show it. This also allow for abstracting communication between different views. 


## Definition 

Here is the list of the most import concepts to define. 
1- `Routable` routable represents any swiftui view that needs to be displayed. 
2- `Coordinator`  is an abstract layer that takes a router and knows how to display it. 


Currently the Library provides 3 coordinators. Later on more can be added, but for now i covered the basic. Follow the concept of `Routable` you can have different sort of navigation, like pageview, tab etc... 

1- `SheetCoordinator`: Provides a convenient way to show hide a view as a sheet. You can show as full or partial. The default implementation of the library allows only one view (regardless if its fullscreen or partial) at a time and it make sure all calls are synchronised. In other words, if you call show twice, the second call will hide the existing and show the new one. The reason we synchronise is to avoid any UI issues and for proper dismiss handler calls.

2- `SheetsCoordinator`: Provides a convenient way to show hide as many views as a sheet. The default implementation of the library allows to stack views on top of each other presented as sheets, without having to worry if an existing view is present or not. It also sycnrhonise all calls. In other words, if you try to show 2 views at the same time,It will present both views sequantially.
 
3- `NavigationCoordinator`: Provides a convenient way for to push pop views. 


The core concept of this library is routable. Coordinators on the other hands are views that declares the type of navigation and takes and return routable. Internally the coordinators knows how to display and hide the views. Routable are basically view factory, which has one job which is to return an instance of the view. It also must comform to Identifiable and Hashable.

## Create a Routable 

As described above Routable is simply a view factory that is identifiable and hashable. It is used by Coordinators to show/hide. When you implement a view. In order to display it, you will need to create a corresponding routable that knows how to create your view. The rest is left for coordinator. 

Example. 

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
  //We will also needs to make it identifiable and hashable. We used below HashableByType which works for class objects.
 class TestViewRoutable : Routable, HashableByType {
     func createView() -> some View {
         return TestView()
     }
 }
 ```
 
 Another way to create routable is to use `RoutableFactory`. `RoutableFactory` is simply a helper, that takes a closure that returns a view and implement Routable itself. 
 
 ```
 let routable = RoutableFactory {
    return TestView()
 }
 ```
 
 
 ## Usage. 
 
 Now that we have a built up an understanding of the library we can now learn how to use it. let see how to use it. Its best to show by example. 
 
 ```
  struct TestView : View {
     var body: some View {
         VStack {
             Text("Base")
         }
     }
 }
 ```
 

Be careful of retaining cycle when creating `Routable`. Basically the default Coordinators implementations strong hold reference of routable instance.  

If for example you have a parent Coordinator that has strong reference for our built in coordinator, and you want to pass the parent Coordinator to your routable, in order to know how to navigate, make sure you weakly retain the parent coordinator reference in your routable, otherwise you will create a retaining cycle. 
ParentCoordinator (Hold strong reference)-> SheetCordinator (Hold strong routable)-> Routable (Holds a strong reference of ParentCoordinator) eventually causing a retain cycle. 

An example will clarify Better. 



