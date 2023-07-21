import UIKit

class DetailsBottomView: BaseView {
    
    private lazy var bottomImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "bottom_image")
        return $0
    }(UIImageView())
    
    override func setupAppearence() {
        super.setupAppearence()
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        addSubview(bottomImageView)
        
        bottomImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
