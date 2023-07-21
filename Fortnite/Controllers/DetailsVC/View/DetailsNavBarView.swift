import UIKit
import SnapKit

protocol DetailsNavBarViewDelegate: AnyObject {
    func backButtonTapped()
}

class DetailsNavBarView: BaseView {
    
    private lazy var button: UIButton = {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "back_icon"), for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    weak var delegate: DetailsNavBarViewDelegate?
    
    override func setupAppearence() {
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        addSubview(button)
        
        snp.makeConstraints {
            $0.bottom.equalTo(button)
        }
        
        button.snp.makeConstraints {
            $0.width.equalTo(18.06 + 20)
            $0.height.equalTo(20.86 + 20)
            $0.top.equalToSuperview().offset(safeAreaTopPadding + 10)
            $0.left.equalToSuperview().offset(11)
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        delegate?.backButtonTapped()
    }
    
}
