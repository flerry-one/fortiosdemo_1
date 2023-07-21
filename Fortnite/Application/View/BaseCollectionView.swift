import UIKit

class BaseCollectionViewCell<Model>: UICollectionViewCell {
    
    // MARK: - properties
    
    internal var model: Model? {
        didSet {
            updateData(with: model)
        }
    }
    
    // MARK: - setup
    
    func setup(with model: Model) {
        self.model = model
    }
    
    internal func setupAppearence() {}
    
    internal func setupLayout() {}
    
    internal func bind() {}
    
    // MARK: - update
    
    internal func updateData(with model: Model?) {
        
    }
    
    // MARK: - init
    
    internal func commonInit() {
        setupAppearence()
        setupLayout()
        bind()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
