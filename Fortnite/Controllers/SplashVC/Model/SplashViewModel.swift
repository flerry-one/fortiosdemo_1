import UIKit

class SplashViewModel: BaseViewModel {
    
    var image: UIImage? {
        let name = SplashImageManager.shared.getNextImageName()
        return UIImage(named: name)
    }
    
}
