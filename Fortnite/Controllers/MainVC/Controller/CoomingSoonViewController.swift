import UIKit

class CoomingSoonViewController: BaseViewController<MainViewModel, MainRouter> {
    
    private lazy var menuClassicButton:  UIButton = {
        $0.backgroundColor = .black
        $0.layer.borderColor = UIColor.neon.cgColor
        $0.layer.borderWidth = 1
        $0.setTitle("back", for: .normal)
        $0.titleLabel?.font = .Floripa.regular(size: 11)
        $0.setTitleColor(.neon, for: .normal)
        $0.setTitleColor(.neon.withAlphaComponent(0.7), for: .highlighted)
        $0.addTarget(self, action: #selector(menuBarButtonTapped), for: .touchUpInside)
        $0.layer.applyShadow(.init(color: .neon, alpha: 1, x: 0, y: 1.75, blur: 8.68, spread: 0))
        return $0
    }(UIButton())
    
    private lazy var imageView1: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "coming_soon_1_image")
        return $0
    }(UIImageView())
    
    private lazy var imageView2: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "coming_soon_2_image")
        return $0
    }(UIImageView())
    
    private lazy var imageView3: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "coming_soon_3_image")
        return $0
    }(UIImageView())
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupAppearence() {
        view.setupTapGesture()
        view.backgroundColor = .black
    }
    
    override func setupLayout() {
        view.addSubview(imageView1)
        view.addSubview(menuClassicButton)
        view.addSubview(imageView2)
        view.addSubview(imageView3)
        
        menuClassicButton.snp.makeConstraints {
            $0.width.equalTo(112)
            $0.height.equalTo(27)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(safeAreaTopPadding + 15)
        }
        
        imageView1.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.51)
        }
        
        imageView2.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.9)
        }
        
        imageView3.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.45)
        }
       
    }
    
    @objc func menuBarButtonTapped(sender: UIButton) {
        router.route(to: .menu(viewType: viewModel.viewType), presentationStyle: .modalFade)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuClassicButton.layer.cornerRadius = menuClassicButton.frame.height / 2
    }
    
    init(viewModel: MainViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.router = MainRouter(sourceViewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

