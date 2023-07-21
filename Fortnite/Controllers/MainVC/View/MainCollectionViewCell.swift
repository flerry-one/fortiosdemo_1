import UIKit
import SnapKit
import Kingfisher

protocol MainCollectionViewCellDelegate: AnyObject {
    func itemTapped(with model: ItemShort)
}

class MainCollectionViewCell: BaseCollectionViewCell<ItemShort> {
    
    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    override func setupAppearence() {
        layer.masksToBounds = true
        layer.cornerRadius = 8.68
        layer.borderWidth = 1
        layer.borderColor = UIColor.neon.cgColor
    }
    
    weak var delegate: MainCollectionViewCellDelegate?
    
    override func setupLayout() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func updateData(with model: ItemShort?) {
        guard let model else {return}
        imageView.kf.setImage(with: model.imageURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
    
    override func tapGestureSelector() {
        guard let model else {return}
        delegate?.itemTapped(with: model)
    }
    
    override func commonInit() {
        super.commonInit()
        setupTapGesture()
    }
}
