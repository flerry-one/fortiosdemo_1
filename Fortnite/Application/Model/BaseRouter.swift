import Foundation
import UIKit

enum BasePresentationStyle {
    case none
    case root(animated: Bool)
    case modal(animated: Bool)
    case modalFade
    case push(animated: Bool)
    
    var isRoot: Bool {
        if case .root = self {
            return true
        }
        return false
    }
    
    var isPush: Bool {
        if case .push = self {
            return true
        }
        return false
    }
    
    var isModal: Bool {
        if case .modal = self {
            return true
        }
        return false
    }
    
}

protocol Navigatable: AnyObject {
    func leftBarButtonTapped()
    func rightBarButtonTapped()
}

protocol Presentable where Self: UIViewController {
    var presentationStyle: BasePresentationStyle {get set}
}


class BaseRouter: Navigatable {
    
    weak var sourceViewController: UIViewController?
    
    func present(_ vc: Presentable, presentationStyle: BasePresentationStyle) {
        vc.presentationStyle = presentationStyle
        switch presentationStyle {
        case .none: break
        case .root(let animated): routerPresentationRoot(vc, animated: animated)
        case .modal(let animated): routerPresentationModal(vc, animated: animated)
        case .push(let animated): routerPresentationPush(vc, animated: animated)
        case .modalFade: routerPresentationModalFade(vc, animated: true)
        }
    }
    
    // MARK: private realization
    
    private func routerPresentationRoot(_ vc: Presentable, animated: Bool) {
        let container = ContainerViewComposer.makeContainer(with: vc)
        UIApplication.shared.switchRootViewController(container, animated: animated)
    }
    
    private func routerPresentationPush(_ vc: Presentable, animated: Bool) {
        sourceViewController?.navigationController?.pushViewController(vc, animated: animated)
    }
    
    private func routerPresentationModal(_ vc: Presentable, animated: Bool) {
        vc.modalPresentationStyle = .fullScreen
        sourceViewController?.present(vc, animated: animated)
    }
    
    private func routerPresentationModalFade(_ vc: Presentable, animated: Bool) {
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        sourceViewController?.present(vc, animated: animated)
    }
    
    
    
    // MARK: navigation
    
    func pop(animated: Bool) {
        
        guard let navController = sourceViewController?.navigationController else {
            sourceViewController?.dismiss(animated: animated)
            return
        }
        
        navController.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        sourceViewController?.dismiss(animated: animated, completion: completion)
    }
    
    // MARK: Navigatable
    
    func leftBarButtonTapped() {
        pop(animated: true)
    }
    
    func rightBarButtonTapped() {}
    
    // MARK: init
    
    required init(sourceViewController: UIViewController?) {
        self.sourceViewController = sourceViewController
    }
    
}
