import UIKit

class BaseViewController<ViewModelType: BaseViewModel, RouterType: BaseRouter>: UIViewController, Presentable {
    
    // MARK: - properties
    
    var presentationStyle: BasePresentationStyle = .none
    
    var viewModel: ViewModelType!
    var router: RouterType!
    
    // MARK: - overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        setupLayout()
        bind()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - setup
    
    internal func setupAppearence() {}
    internal func setupLayout() {}
    
    // MARK: - bind
    
    internal func bind() {}
    
}
