import UIKit

class MenuItemView: BaseView {
    
    private lazy var button: UIButton = {
        $0.setTitle(viewType.title, for: .normal)
        $0.titleLabel?.font = .Floripa.regular(size: 19.45)
        $0.setTitleColor(.neon, for: .normal)
        $0.setTitleColor(.neon.withAlphaComponent(0.7), for: .highlighted)
        $0.backgroundColor = .black
        $0.addTarget(self, action: #selector(buttonTappedSelector), for: .touchUpInside)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.neon.cgColor
        $0.layer.cornerRadius = 23
        $0.layer.applyShadow(Shadow(color: .neon, alpha: 1, x: 0, y: 1.76, blur: 8.68, spread: 0))
        return $0
    }(UIButton())
    
    let viewType: MainViewType
    var buttonTapped: ((_ viewType: MainViewType) -> Void)?
    
    override func setupAppearence() {
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        addSubview(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func buttonTappedSelector(sender: UIButton) {
        buttonTapped?(viewType)
    }
    
    init(viewType: MainViewType) {
        self.viewType = viewType
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
