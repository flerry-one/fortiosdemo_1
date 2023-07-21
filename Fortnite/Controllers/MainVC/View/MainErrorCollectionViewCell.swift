import UIKit
import SnapKit

protocol MainErrorCollectionViewCellDelegate: AnyObject {
    func reloadButtonTapped()
}

class MainErrorCollectionViewCell: BaseCollectionViewCell<String> {
    
    private lazy var containerView: UIView = {
        return $0
    }(UIView())
    
    private lazy var titleLabel: UILabel = {
        $0.text = "Error"
        $0.font = .Steppe.black(size: 24)
        $0.textColor = .white
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.text = "Please reload or try later"
        $0.font = .Steppe.book(size: 15)
        $0.textColor = .grayTwo
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var reloadButton:  UIButton = {
        $0.setTitle("reload", for: .normal)
        $0.titleLabel?.font = .Floripa.regular(size: 13)
        $0.setTitleColor(.neon, for: .normal)
        $0.setTitleColor(.neon.withAlphaComponent(0.7), for: .highlighted)
        $0.backgroundColor = .black
        $0.layer.borderColor = UIColor.neon.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 15
        $0.layer.applyShadow(Shadow(color: .neon, alpha: 1, x: 0, y: 1.17, blur: 5.85, spread: 0))
        $0.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    weak var delegate: MainErrorCollectionViewCellDelegate?
    
    override func setupAppearence() {
        super.setupAppearence()
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(reloadButton)
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-40)
            $0.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview()
        }
        
        reloadButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(158)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func reloadButtonTapped(sender: UIButton) {
        delegate?.reloadButtonTapped()
    }
}
