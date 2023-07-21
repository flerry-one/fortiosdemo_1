import UIKit

extension UICollectionReusableView {
    
    static var identifier: String {
        String(describing: self)
    }
    
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func register<T: UICollectionReusableView>(_ type: T.Type) {
        register(T.self, forSupplementaryViewOfKind: T.identifier, withReuseIdentifier: T.identifier)
    }
    
    func reuse<T: UICollectionViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    func reuse<T: UICollectionReusableView>(_ type: T.Type, _ indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(
            ofKind: T.identifier,
            withReuseIdentifier: T.identifier,
            for: indexPath) as! T
    }
    
}
