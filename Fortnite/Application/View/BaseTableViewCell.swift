import UIKit

class BaseTableViewCell<Model>: UITableViewCell {
    
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
    
    internal func setupAppearence() {
        contentView.isUserInteractionEnabled = true
        backgroundColor = .white
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none
    }
    
    internal func setupLayout() {}
    
    // MARK: - update
    
    internal func updateData(with model: Model?) {
        
    }
    
    // MARK: - init
    
    internal func commonInit() {
        setupAppearence()
        setupLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
