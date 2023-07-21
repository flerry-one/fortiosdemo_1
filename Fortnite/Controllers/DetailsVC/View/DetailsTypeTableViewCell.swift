import UIKit
import SnapKit

class DetailsTypeTableViewCell: BaseTableViewCell<[TypeElement]> {
    
    private lazy var label: UILabel = {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override func setupAppearence() {
        super.setupAppearence()
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    
    override func setup(with model: [TypeElement]) {
        label.attributedText = Atributted.multiString(strings: [
            .init(text: ((model[0].text ?? "") + " ").capitalized, font: .Steppe.black(size: 24), color: .init(hexString: model[0].hexColor ?? ""), strike: false),
            .init(text: (model[1].text ?? "").uppercased(), font: .Steppe.black(size: 24), color: .init(hexString: model[1].hexColor ?? ""), strike: false)
        ], lineHeight: 1.3, aligment: .center)
    }
}
