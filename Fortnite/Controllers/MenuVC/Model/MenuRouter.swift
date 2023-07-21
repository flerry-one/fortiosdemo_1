import Foundation

class MenuRouter: BaseRouter {
    
    func route(to route: MainViewType?, presentationStyle: BasePresentationStyle) {
        guard let route else {
            let vc = CoomingSoonViewController(viewModel: .init(viewType: .stats))
            present(vc, presentationStyle: presentationStyle)
            return
        }
        let mainVC = MainViewController(viewModel: .init(viewType: route))
        present(mainVC, presentationStyle: presentationStyle)
    }
    
}
