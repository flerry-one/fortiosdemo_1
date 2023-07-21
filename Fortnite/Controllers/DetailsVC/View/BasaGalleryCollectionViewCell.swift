import Kingfisher
import UIKit

protocol BasaGalleryCollectionViewCellDelegate: AnyObject {
    func itemTapped(with index: Int)
}

class BasaGalleryCollectionViewCell: BaseCollectionViewCell<String> {
    
    private lazy var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var gradientView: UIView = {
        return $0
    }(UIView())
    
    private lazy var gradientLayer: CAGradientLayer = {
        $0.colors = [
            UIColor.black.cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        $0.startPoint = CGPoint(x: 0.5, y: 1.0)
        $0.endPoint = CGPoint(x: 0.5, y: 0.5)
        $0.locations = [0,1]
        return $0
    }(CAGradientLayer())
    
    lazy var leftImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "gallery_left_image")
        return $0
    }(UIImageView())
    
    lazy var rightImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "gallery_right_image")
        return $0
    }(UIImageView())
    
    weak var delegate: BasaGalleryCollectionViewCellDelegate?
    
    override func setupAppearence() {
        super.setupAppearence()
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(leftImageView)
        contentView.addSubview(rightImageView)
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(isLongScreen ? 210 : 191)
            $0.height.equalTo(isLongScreen ? 236 : 216)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(30)
        }
        
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftImageView.snp.makeConstraints {
            $0.width.equalTo(123.33)
            $0.height.equalTo(160.15)
            $0.left.equalToSuperview().offset(7)
            $0.top.equalToSuperview().offset(5)
        }
        
        rightImageView.snp.makeConstraints {
            $0.width.equalTo(137.57)
            $0.height.equalTo(151.12)
            $0.right.equalToSuperview().offset(-7)
            $0.top.equalToSuperview()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func updateData(with model: String?) {
        imageView.kf.setImage(with: URL(string: model ?? ""))
    }
    
    override func tapGestureSelector() {
        if let collectionView = superview as? UICollectionView,
            let indexPath = collectionView.indexPath(for: self) {
            let row = indexPath.row
            delegate?.itemTapped(with: row)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
    
    override func commonInit() {
        super.commonInit()
        setupTapGesture()
    }
    
}


