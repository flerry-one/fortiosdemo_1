import UIKit

class ContainerViewComposer {
    
    static func makeContainer(with vc: Presentable) -> ContainerViewController {
        let container = ContainerViewController(rootViewController: vc)
        return container
    }
    
}
