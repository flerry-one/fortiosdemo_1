import UIKit
import SnapKit

class DetailsPriceTableViewCell: BaseTableViewCell<Price> {
    
    private lazy var containerView: UIView = {
        return $0
    }(UIView())
    
    private lazy var mainImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private lazy var titleLabel: UILabel = {
        $0.font = UIFont.Steppe.black(size: 15.45)
        $0.textColor = .white
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override func setupAppearence() {
        super.setupAppearence()
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainImageView)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.top.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints {
            $0.width.height.equalTo(25)
            $0.left.equalTo(containerView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.right.equalTo(containerView)
            $0.centerY.equalToSuperview().offset(1)
            $0.left.equalTo(mainImageView.snp.right).offset(7)

        }
    }
    
    override func updateData(with model: Price?) {
        mainImageView.kf.setImage(with: URL(string: model?.imageURL ?? ""))
        titleLabel.text = model?.text
    }
}
