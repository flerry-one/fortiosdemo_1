import UIKit

class ContainerViewController: UIViewController {
    
    // MARK: properties
    
    var nc: UINavigationController
    
    private var rootViewController: Presentable {
        didSet {
            nc.setViewControllers([rootViewController], animated: false)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
    }
    
    // MARK: setup
    
    private func setupView() {
        add(vc: nc, in: self.view)
    }
    
    private func setupNavigationController() {
        nc.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: init
    
    init(rootViewController: Presentable) {
        self.rootViewController = rootViewController
        self.nc = UINavigationController(rootViewController: rootViewController)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
