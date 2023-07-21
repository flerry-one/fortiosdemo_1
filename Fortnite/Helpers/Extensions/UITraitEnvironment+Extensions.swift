import UIKit

extension UITraitEnvironment {
    
    // MARK: SafeArea
    
    private var window: UIWindow {
        return UIApplication.shared.windows[0]
    }
    
    private var safeFrame: CGRect {
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        return safeFrame
    }
    
    var safeAreaTopPadding: CGFloat {
        return safeFrame.minY
    }
    
    var safeAreaBottomPadding: CGFloat {
        return window.frame.maxY - safeFrame.maxY
    }
    
    var isLongScreen: Bool {
        return safeAreaTopPadding > 20
    }
    
}
