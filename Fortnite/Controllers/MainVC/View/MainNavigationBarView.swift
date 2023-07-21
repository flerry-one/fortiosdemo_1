import UIKit
import SnapKit

protocol MainNavigationBarViewDelegate: AnyObject {
    func menuBarButtonTapped()
}

class MainNavigationBarView: BaseView {
    
    private lazy var titleLabel: UILabel = {
        $0.font = .Floripa.regular(size: 20)
        $0.textColor = .neon
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var leftImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: viewType.leftImageName)
        return $0
    }(UIImageView())
    
    private lazy var rightImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: viewType.rightImageName)
        return $0
    }(UIImageView())
    
    private lazy var menuBarButton:  UIButton = {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "menu_bar_button_icon"), for: .normal)
        $0.addTarget(self, action: #selector(menuBarButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var menuClassicButton:  UIButton = {
        $0.backgroundColor = .black
        $0.layer.borderColor = UIColor.neon.cgColor
        $0.layer.borderWidth = 1
        $0.setTitle("MENU", for: .normal)
        $0.titleLabel?.font = .Floripa.regular(size: 11)
        $0.setTitleColor(.neon, for: .normal)
        $0.setTitleColor(.neon.withAlphaComponent(0.7), for: .highlighted)
        $0.addTarget(self, action: #selector(menuBarButtonTapped), for: .touchUpInside)
        $0.layer.applyShadow(.init(color: .neon, alpha: 1, x: 0, y: 1.75, blur: 8.68, spread: 0))
        return $0
    }(UIButton())
    
    private lazy var listView: MainNavBarHorizontalListView = {
        return $0
    }(MainNavBarHorizontalListView())
    
    private lazy var searchView: MainSearchView = {
        return $0
    }(MainSearchView(placeholder: viewType.placeholder))
    
    enum ViewType {
        case stats
        case regular
        
        var placeholder: String {
            switch self {
            case .stats: return "Enter your EPIC name..."
            case .regular: return "Search"
            }
        }
        
        var height: CGFloat {
            switch self {
            case .stats: return 155
            case .regular: return 180
            }
        }
        
        var searchTopPadding: CGFloat {
            switch self {
            case .stats: return 10
            case .regular: return 29
            }
        }
        
        var titleTopPadding: CGFloat {
            switch self {
            case .stats: return 55
            case .regular: return 33
            }
        }
        
        var leftImageName: String {
            switch self {
            case .stats: return "" //"main_navbar_stats_left_image"
            case .regular: return "main_navbar_left_image"
            }
        }
        
        var rightImageName: String {
            switch self {
            case .stats: return "" //"main_navbar_stats_right_image"
            case .regular: return "main_navbar_right_image"
            }
        }
    }
    
    var viewType: ViewType {
        didSet {
            setupViewType()
        }
    }
    
    weak var delegate: MainNavigationBarViewDelegate?
    
    var textChanged: ((_ text: String?) -> Void)?
    var listTapped: ((Any?) -> Void)?
    var returnButtonTapped: (() -> Void)?
    
    var listViewType: HorizontalListViewType?  {
        didSet {
            listView.viewType = listViewType
        }
    }
    
    var text: String? {
        return searchView.text
    }
    
    override func setupAppearence() {
        backgroundColor = .black
    }
    
    override func setupLayout() {
        addSubview(leftImageView)
        addSubview(rightImageView)
        addSubview(titleLabel)
        addSubview(searchView)
        addSubview(menuBarButton)
        addSubview(menuClassicButton)
        addSubview(listView)
        
        snp.makeConstraints {
            $0.height.equalTo(safeAreaTopPadding + viewType.height)
        }
        
        leftImageView.snp.makeConstraints {
            $0.width.equalTo(68.09)
            $0.height.equalTo(61.49)
            $0.right.equalTo(titleLabel.snp.left)
            $0.centerY.equalTo(titleLabel)
        }
        
        rightImageView.snp.makeConstraints {
            $0.width.equalTo(71.22)
            $0.height.equalTo(72.95)
            $0.left.equalTo(titleLabel.snp.right).offset(-14)
            $0.centerY.equalTo(titleLabel).offset(10)
        }
        
        menuClassicButton.snp.makeConstraints {
            $0.width.equalTo(112)
            $0.height.equalTo(27)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-15)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(viewType.titleTopPadding + safeAreaTopPadding)
            $0.centerX.equalToSuperview()
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(viewType.searchTopPadding)
            $0.left.right.equalToSuperview().inset(21)
        }
        
        menuBarButton.snp.makeConstraints {
            $0.width.equalTo(26.75 + 20)
            $0.height.equalTo(26.05 + 20)
            $0.top.equalToSuperview().offset(safeAreaTopPadding + 15)
            $0.right.equalToSuperview().offset(-10)
        }
        
        listView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func setupViewType() {
        switch viewType {
        case .stats:
            listView.isHidden = true
            menuBarButton.isHidden = true
            menuClassicButton.isHidden = false
            _ = searchView.becomeFirstResponder()
            searchView.setSearchReturnKey()
        case .regular:
            listView.isHidden = false
            menuBarButton.isHidden = false
            menuClassicButton.isHidden = true
        }
    }
    
    @objc func menuBarButtonTapped(sender: UIButton) {
        delegate?.menuBarButtonTapped()
    }
    
    func updateTitle(_ title: String) {
        switch viewType {
        case .stats: titleLabel.text = "FIND\nYOUR STATS"
        case .regular: titleLabel.text = title
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        _ = searchView.becomeFirstResponder()
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        menuClassicButton.layer.cornerRadius = menuClassicButton.frame.height / 2
    }
    
    override func commonInit() {
        super.commonInit()
        setupViewType()
    }
    
    init(viewType: ViewType) {
        self.viewType = viewType
        super.init()
        searchView.textChanged = { text in
            self.textChanged?(text)
        }
        searchView.returnButtonTapped = {
            self.returnButtonTapped?()
        }
        listView.tapped = { item in
            self.listTapped?(item)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
