import UIKit

extension UIApplication {
    
    func switchRootViewController(_ viewController: UIViewController,
                                  animated: Bool = true,
                                  duration: TimeInterval = 0.2,
                                  options: UIView.AnimationOptions = UIView.AnimationOptions.transitionCrossDissolve,
                                  completion: (() -> Void)? = nil) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return}
        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else {return}
        
        guard animated else {
            sceneDelegate.window?.rootViewController = viewController
            return
        }
        
        UIView.transition(with: sceneDelegate.window!, duration: duration, options: options, animations: {
            sceneDelegate.window?.rootViewController = viewController
        }, completion: { _ in
            completion?()
        })
    }
    
    func rootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return nil}
        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else {return nil}
        return sceneDelegate.window?.rootViewController
    }
        
}
