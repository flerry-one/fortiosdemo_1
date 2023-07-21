import UIKit
import SnapKit

class MainInfoCollectionViewCell: BaseCollectionViewCell<String> {
    
    private lazy var titleLabel: UILabel = {
        $0.font = .Steppe.black(size: 24)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    override func setupAppearence() {
        super.setupAppearence()
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(21)
            $0.bottom.equalToSuperview()
        }
    
    }
    
    override func updateData(with model: String?) {
        titleLabel.text = model
    }
    
}
