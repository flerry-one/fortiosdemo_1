import Foundation
import SnapKit

enum HorizontalListViewType {
    case rarity
    case type
    
    var items: [String?] {
        switch self {
        case .rarity:
            var mapped: [String?]  = Rarity.allCases.map({$0.title})
            mapped.insert(nil, at: 0)
            return mapped
        case .type: return ItemType.allCases.map({$0.title})
        }
    }
    
}

class MainNavBarHorizontalListView: BaseView {
    
    private lazy var scrollView: UIScrollView = {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
        return $0
    }(UIScrollView())
    
    private lazy var stackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 7
        $0.distribution = .fillProportionally
        return $0
    }(UIStackView())
    
    private lazy var rarityLabel: UILabel = {
        $0.text = "Rarity"
        $0.font = .Steppe.semibold(size: 14)
        $0.textColor = .grayTwo
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    var viewType: HorizontalListViewType?  {
        didSet {
            guard let _ = viewType else {return}
            selectedIndex = 0
            updateStackViewData()
            updateSelectedIndex()
        }
    }
    
    var selectedIndex = 0
    var tapped: ((Any?) -> Void)?
    
    private func updateStackViewData() {
        guard let viewType else {return}
        stackView.removeAllArrangedSubviews()
        
        if viewType == .rarity {
            stackView.addArrangedSubview(rarityLabel)
        }
        
        for (index, value) in viewType.items.enumerated() {
            
            
            let item = MainNavBarHorizontalItemView(text: value ?? "All", index: index)
            item.addHeightConstraint(value: 30)
            item.tapped = { [weak self] tappedIndex in
                self?.selectedIndex = tappedIndex
                self?.updateSelectedIndex()
                
                switch viewType {
                case .rarity:
                    guard tappedIndex != 0 else {
                        self?.tapped?(nil)
                        return
                    }
                    self?.tapped?(Rarity.allCases[tappedIndex - 1])
                case .type: self?.tapped?(ItemType.allCases[tappedIndex])
                }
            }
            
            stackView.addArrangedSubview(item)
        }
        
    }
    
    private func updateSelectedIndex() {
        for view in stackView.arrangedSubviews {
            guard let view =  view as? MainNavBarHorizontalItemView else { continue }
            let isSelected = view.tag == selectedIndex
            view.layer.borderColor = UIColor.neon.withAlphaComponent(isSelected ? 1 : 0.4).cgColor
            view.label.textColor = .white.withAlphaComponent(isSelected ? 1 : 0.4)
            if isSelected {
                view.layer.applyShadow(Shadow(color: .neon.withAlphaComponent(0.2), alpha: 1, x: 0, y: 5, blur: 25, spread: 0 ))
            } else {
                view.layer.applyShadow(Shadow(color: .clear))
            }
        }
    }
    
    override func setupAppearence() {
        backgroundColor = .black
    }
    
    override func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        snp.makeConstraints{
            $0.height.equalTo(40)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }
}


private class MainNavBarHorizontalItemView: BaseView {
    
    lazy var label: UILabel = {
        $0.text = text
        $0.font = .Steppe.semibold(size: 14)
        $0.textColor = .white.withAlphaComponent(0.4)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    let text: String?
    var tapped: ((Int) -> Void)?
    
    override func setupAppearence() {
        layer.cornerRadius = 11
        layer.borderWidth = 1
        layer.borderColor = UIColor.neon.withAlphaComponent(0.4).cgColor
        backgroundColor = .black
        
    }
    
    override func setupLayout() {
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    override func tapGestureSelector() {
        tapped?(tag)
    }
    
    init(text: String, index: Int) {
        self.text = text
        super.init()
        self.tag = index
        setupTapGesture()
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
}
