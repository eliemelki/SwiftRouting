import SwiftUI

private enum PageDemoRoute: String, Route { case first, second, third }

@MainActor
private class PageCoordinator: ObservableObject {
    let pageRouter = PageRouter<PageDemoRoute>(pages: [.first, .second, .third])

    func next() { pageRouter.next() }
    func previous() { pageRouter.previous() }
}

struct PageDemoView: View {
    @StateObject private var coordinator = PageCoordinator()

    var body: some View {
        coordinator.pageRouter.view { route in
            VStack {
                Text(route.rawValue.capitalized)
                HStack {
                    Button("Previous", action: coordinator.previous)
                    Button("Next", action: coordinator.next)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue.opacity(0.15))
        }
    }
}

#Preview { PageDemoView() }
