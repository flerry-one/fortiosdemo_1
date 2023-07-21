import Foundation

class MainRouter: BaseRouter {
    
    enum Route {
        case menu(viewType: MainViewType)
        case bundle(id: String)
        case item(id: String)
    }
    
    func route(to route: Route, presentationStyle: BasePresentationStyle) {
        switch route {
        case .menu(let viewType):
            let menuVC = MenuViewController()
            menuVC.presentedFromViewType = viewType
            present(menuVC, presentationStyle: presentationStyle)
        case .bundle(let id):
            let vc = DetailsViewController(viewModel: .init(viewType: .bundle(id: id)))
            present(vc, presentationStyle: presentationStyle)
        case .item(let id):
            let vc = DetailsViewController(viewModel: .init(viewType: .regular(id: id)))
            present(vc, presentationStyle: presentationStyle)
        }
    }
    
}
