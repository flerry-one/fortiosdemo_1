import UIKit
import SnapKit

class BaseView: UIView {
    
    // MARK: - setup

    internal func setupAppearence() {}
    internal func setupLayout() {}
    internal func bind() {}
    
    // MARK: - init
    
    internal func commonInit() {
        setupAppearence()
        setupLayout()
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
}
