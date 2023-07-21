import Foundation

class SplashRouter: BaseRouter {
    
    enum Route {
        case main
    }
    
    func route(to route: Route, presentationStyle: BasePresentationStyle) {
        switch route {
        case .main:
            let menuVC = MainViewController(viewModel: .init(viewType: .skins))
            present(menuVC, presentationStyle: presentationStyle)
        }
    }
    
}
