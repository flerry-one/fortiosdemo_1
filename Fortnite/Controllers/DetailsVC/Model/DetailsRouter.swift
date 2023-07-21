import Foundation

class DetailsRouter: BaseRouter {
    
    enum Route {
        case item(id: String)
    }
    
    func route(to route: Route, presentationStyle: BasePresentationStyle) {
        switch route {
        case .item(let id):
            let vc = DetailsViewController(viewModel: .init(viewType: .regular(id: id)))
            present(vc, presentationStyle: presentationStyle)
        }
    }
}
