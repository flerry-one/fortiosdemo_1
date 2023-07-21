import UIKit

enum GalleryModel {
    case single(urlString: String?, name: String?)
    case multy(items: [Asset], name: String?)
    
    var imagesURLsStrings: [String] {
        switch self {
        case .single(let urlString, _): return [urlString ?? ""]
        case .multy(let items, _): return items.map({$0.imageURL ?? ""})
        }
    }
    
    var items: [Asset] {
        switch self {
        case .single: return []
        case .multy(let items, _): return items
        }
    }
    
    var name: String? {
        switch self {
        case .single(_, let name): return name
        case .multy(_, _): return "Bundle"
        }
    }
    
    var isMulty: Bool {
        if case .multy = self {
            return true
        }
        return false
    }
    
}

protocol DetailsGalleryTableViewCellDelegate: AnyObject {
    func itemTapped(with id: String)
}

class DetailsGalleryTableViewCell: BaseTableViewCell<GalleryModel> {
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 240)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.sectionInsetReference = .fromContentInset
        let item = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        item.isPagingEnabled = true
        item.showsHorizontalScrollIndicator = false
        item.clipsToBounds = false
        item.register(BasaGalleryCollectionViewCell.self)
        item.backgroundColor = .clear
        item.dataSource = self
        item.delegate = self
        return item
    }()
    
    private lazy var leftButton:  UIButton = {
        $0.setImage(UIImage(named: "bundle_left_icon"), for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        $0.tag = 0
        return $0
    }(UIButton())
    
    private lazy var rightButton:  UIButton = {
        $0.setImage(UIImage(named: "bundle_right_icon"), for: .normal)
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        $0.tag = 1
        return $0
    }(UIButton())
    
    lazy var leftImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "bundle_left_image")
        return $0
    }(UIImageView())
    
    lazy var rightImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "bundle_right_image")
        return $0
    }(UIImageView())
    
    private lazy var nameLabel: UILabel = {
        $0.font = UIFont.Estrella.early(size: 67)
        $0.textColor = .neon
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    weak var delegate: DetailsGalleryTableViewCellDelegate?
    
    override func setupAppearence() {
        super.setupAppearence()
        backgroundColor = .clear
    }
    
    override func setupLayout() {
        contentView.addSubview(collectionView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        contentView.addSubview(leftImageView)
        contentView.addSubview(rightImageView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.width.equalTo(230)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.width.equalTo(14.24 + 20)
            $0.height.equalTo(17.02 + 20)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
        }
        
        rightButton.snp.makeConstraints {
            $0.width.equalTo(14.24 + 20)
            $0.height.equalTo(17.02 + 20)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
        
        leftImageView.snp.makeConstraints {
            $0.width.equalTo(105)
            $0.height.equalTo(118)
            $0.left.equalToSuperview().offset(4)
            $0.centerY.equalTo(nameLabel)
        }
        
        rightImageView.snp.makeConstraints {
            $0.width.equalTo(114)
            $0.height.equalTo(128)
            $0.right.equalToSuperview().offset(-4)
            $0.centerY.equalTo(nameLabel).offset(-10)
        }
    }
    
    
    override func updateData(with model: GalleryModel?) {
        nameLabel.text = model?.name
        leftButton.isHidden = !(model?.isMulty ?? false)
        rightButton.isHidden = !(model?.isMulty ?? false)
        leftImageView.isHidden = !(model?.isMulty ?? false)
        rightImageView.isHidden = !(model?.isMulty ?? false)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first else {
            return
        }
        
        let index = currentIndexPath.row

        let items = model?.items ?? []
        
        if sender.tag == 0 {
            let newIndex = index - 1
            if let _ = items.getElementIfExists(at: newIndex) {
                let previousIndexPath = IndexPath(row: currentIndexPath.row - 1, section: currentIndexPath.section)
                collectionView.scrollToItem(at: previousIndexPath, at: .left, animated: true)
            }
        }
        
        if sender.tag == 1 {
            let newIndex = index + 1
            if let _ = items.getElementIfExists(at: newIndex) {
                let nextIndexPath = IndexPath(row: currentIndexPath.row + 1, section: currentIndexPath.section)
                collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
            }
        }
        

    }
}

extension DetailsGalleryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.imagesURLsStrings.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.reuse(BasaGalleryCollectionViewCell.self, indexPath)
        cell.setup(with: model?.imagesURLsStrings[indexPath.row] ?? "")
        cell.leftImageView.isHidden = model?.isMulty ?? false
        cell.rightImageView.isHidden = model?.isMulty ?? false
        cell.delegate = self
        return cell
    }
    
}

extension DetailsGalleryTableViewCell: BasaGalleryCollectionViewCellDelegate {
    
    func itemTapped(with index: Int) {
        guard let model else {return}
        switch model {
        case .single: break
        case .multy( let items, _): delegate?.itemTapped(with: items[index].id ?? "")
        }
        
    }
    
}
