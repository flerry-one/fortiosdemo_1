import UIKit

extension UIViewController {
    
    func add(vc: UIViewController, in containerView: UIView) {
        addChild(vc)
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
}

extension UIViewController: UIGestureRecognizerDelegate {

  func disableInteractivePopGesture() {
    navigationItem.hidesBackButton = true
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }

  func enableInteractivePopGesture() {
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
}
