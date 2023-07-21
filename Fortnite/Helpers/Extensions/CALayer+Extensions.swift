import UIKit

struct Shadow {
    var color: UIColor = .black
    var alpha: Float = 0.5
    var x: CGFloat = 0
    var y: CGFloat = 2
    var blur: CGFloat = 4
    var spread: CGFloat = 0
}

extension CALayer {
    
    func applyShadow(_ shadow: Shadow = Shadow()) {
        masksToBounds = false
        shadowColor = shadow.color.cgColor
        shadowOpacity = shadow.alpha
        shadowOffset = CGSize(width: shadow.x, height: shadow.y)
        shadowRadius = shadow.blur / 2.0
        if shadow.spread == 0 {
            shadowPath = nil
        } else {
            let dx = -shadow.spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
}
