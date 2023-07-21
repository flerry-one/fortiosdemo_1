import Foundation
import SafariServices
import SnapKit

class MenuViewController: BaseViewController<MenuViewModel, MenuRouter> {
    
    private lazy var bluredView: CustomBlurEffectView = {
        $0.blurRadius = 4
        return $0
    }(CustomBlurEffectView())
    
    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "menu_background_image")
        return $0
    }(UIImageView())
    
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 13.5
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private lazy var menuBarButton:  UIButton = {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "menu_bar_button_icon"), for: .normal)
        $0.addTarget(self, action: #selector(menuBarButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
        
    var presentedFromViewType: MainViewType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupTapGesture()
    }
    
    func setupTapGesture() {
        self.view.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureSelector))
        self.view.addGestureRecognizer(tap)
    }
    
    override func setupAppearence() {
        view.backgroundColor = .clear
    }
    
    override func setupLayout() {
        view.addSubview(bluredView)
        view.addSubview(imageView)
        view.addSubview(stackView)
        view.addSubview(menuBarButton)
        
        bluredView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(234.5)
            $0.centerX.centerY.equalToSuperview()
        }
        
        menuBarButton.snp.makeConstraints {
            $0.width.equalTo(26.75 + 20)
            $0.height.equalTo(26.05 + 20)
            $0.top.equalToSuperview().offset(safeAreaTopPadding + 15)
            $0.right.equalToSuperview().offset(-10)
        }
        
    }
    
    private func setupStackView() {
        for i in viewModel.items {
            let view = MenuItemView(viewType: i)
            view.addHeightConstraint(value: 48)
            view.buttonTapped = { viewType in
                if self.presentedFromViewType == viewType {
                    self.dismiss(animated: true)
                }else{
                    if viewType == .stats {
                        self.router.route(to: nil, presentationStyle: .root(animated: true))
                    } else {
                        self.router.route(to: viewType, presentationStyle: .root(animated: true))
                    }
                   
                }
            }
            stackView.addArrangedSubview(view)
        }
    }
    
    @objc func menuBarButtonTapped(sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func tapGestureSelector() {
        dismiss(animated: true)
    }
    
    @objc func privacyPolicyButtonTapped(sender: UIButton) {
        showSFVC(with: "https://fortisapi.com/privacy")
    }
    
    @objc func termsOfUseButtonTapped(sender: UIButton) {
        showSFVC(with: "https://fortisapi.com/terms")
    }
    
    private func showSFVC(with urlString: String) {
        guard let url = URL(string: urlString) else {return}
        let vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
    
    init(viewModel: MenuViewModel = .init()) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.router = MenuRouter(sourceViewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
