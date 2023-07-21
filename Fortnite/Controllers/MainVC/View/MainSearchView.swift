import UIKit

class MainSearchView: BaseView {
    
    private lazy var textField: UITextField = {
        $0.font = UIFont.Steppe.book(size: 18)
        $0.textColor = .grayTwo
        $0.placeholder = placeholder
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        $0.setLeftPaddingPoints(10)
        $0.placeholderColor = .grayTwo
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.delegate = self
        return $0
    }(UITextField())
    
    private lazy var searchImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "search_icon")
        return $0
    }(UIImageView())
    
    let placeholder: String?
    
    var text: String? {
        return textField.isEmpty ? nil : textField.trim 
    }
    
    var textChanged: ((_ text: String?) -> Void)?
    var returnButtonTapped: (() -> Void)?
    
    override func setupAppearence() {
        layer.cornerRadius = 8.68
        layer.borderWidth = 1
        layer.borderColor = UIColor.neon.cgColor
        backgroundColor = .grayOne
    }
    
    override func setupLayout() {
        addSubview(textField)
        addSubview(searchImageView)
        
        snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().offset(-40)
        }
        
        searchImageView.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview().inset(8)
            $0.width.equalTo(32)
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        textField.becomeFirstResponder()
        return true
    }
    
    func setSearchReturnKey() {
        textField.returnKeyType = .search
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textChanged?(textField.isEmpty ? nil : textField.trim)
    }
    
    init(placeholder: String) {
        self.placeholder = placeholder
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
}


extension MainSearchView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        returnButtonTapped?()
        return true
    }

}
