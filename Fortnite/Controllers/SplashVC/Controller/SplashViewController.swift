import UIKit
import AppTrackingTransparency
import SnapKit

class SplashViewController: BaseViewController<SplashViewModel, SplashRouter> {
    
    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.image = viewModel.image
        return $0
    }(UIImageView())
    
    private lazy var logoImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        //$0.image = UIImage(named: "logo")
        return $0
    }(UIImageView())
    
    private lazy var loadingLabel: UILabel = {
        $0.text = "LOADING"
        $0.font = .Floripa.regular(size: 34)
        $0.textColor = .neon
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(1)
        router.route(to: .main, presentationStyle: .root(animated: true))
    }
    
    override func setupAppearence() {
        view.backgroundColor = .black
    }
    
    override func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(logoImageView)
        view.addSubview(loadingLabel)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(view).multipliedBy(0.5)
        }
        
        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(safeAreaBottomPadding + 40)
        }
        
    }
    
    init(viewModel: SplashViewModel = .init()) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.router = SplashRouter(sourceViewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
