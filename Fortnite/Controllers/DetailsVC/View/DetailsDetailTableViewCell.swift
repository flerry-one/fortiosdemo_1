import UIKit
import SnapKit

class DetailsDetailTableViewCell: BaseTableViewCell<Detail> {
    
    private lazy var label: UILabel = {
        $0.font = UIFont.Steppe.book(size: 17)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    override func setupAppearence() {
        super.setupAppearence()
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(isLongScreen ? 8 : 5)
        }
    }
    
    override func updateData(with model: Detail?) {
        label.attributedText = Atributted.multiString(strings: [
            .init(text: (model?.label ?? "") + ": " , font: UIFont.Steppe.book(size: 15.29), color: .grayTwo, strike: false),
            .init(text:  (model?.value ?? ""), font: UIFont.Steppe.book(size: 15.29), color: .white, strike: false)
        ], lineHeight: 1.2, aligment: .center)
    }
    
}
