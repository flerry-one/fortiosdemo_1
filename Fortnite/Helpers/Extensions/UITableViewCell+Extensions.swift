import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        String(describing: self)
    }
    
}

extension UITableView {
        
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }

    func reuse<T: UITableViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
}
