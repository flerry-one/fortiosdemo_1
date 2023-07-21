import UIKit
import StoreKit

class MainViewController: BaseViewController<MainViewModel, MainRouter> {
    
    private lazy var navBarView: MainNavigationBarView = {
        $0.updateTitle(viewModel.viewType.title)
        $0.delegate = self
        return $0
    }(MainNavigationBarView(viewType: viewModel.viewType == .stats ? .stats : .regular))
    
    
    private lazy var collectionView: UICollectionView = {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.register(MainCollectionViewCell.self)
        $0.register(MainErrorCollectionViewCell.self)
        $0.register(MainInfoCollectionViewCell.self)
        $0.register(MainTopStatisticCollectionViewCell.self)
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: createLayout()))
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        $0.style = .large
        $0.color = .white
        viewModel.viewType.activateActivityIndactorImmediatly ? $0.startAnimating() : ()
        return $0
    }(UIActivityIndicatorView())
    
    var dataSource = [Section]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    enum Section {
        case items([ItemShort])
        case error(String)
        case info(String)
    }
    
    let keyboardTracker = KeyboardTracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
        updateHorizontalListViewType()
    }
    
    override func setupAppearence() {
        view.setupTapGesture()
        view.backgroundColor = .black
    }
    
    override func setupLayout() {
        view.addSubview(navBarView)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        navBarView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navBarView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalTo(collectionView)
            $0.top.equalTo(collectionView).offset(150)
        }
    }
    
    override func bind() {
        viewModel.$viewStateWasUpdated.sink { [weak self] value in
            guard let self, value else {return}
            self.activityIndicator.stopAnimating()
            self.navBarView.updateTitle(self.viewModel.viewType.title)
            self.updateHorizontalListViewType()
            
        }.store(in: &viewModel.cancellables)
        viewModel.$successItemsResult.sink { [weak self] value in
            guard let self, let value else {return}
            self.activityIndicator.stopAnimating()
            updateDataSource(with: value)
        }.store(in: &viewModel.cancellables)
        viewModel.$successStatisticResult.sink { [weak self] value in
            guard let self, let value else {return}
            self.activityIndicator.stopAnimating()
            updateDataSource(with: value)
        }.store(in: &viewModel.cancellables)
        viewModel.$errorResult.sink { [weak self] value in
            guard let self, let value = value else {return}
            self.activityIndicator.stopAnimating()
            self.view.endEditing(true)
            self.updateDataSource(with: value)
        }.store(in: &viewModel.cancellables)
        keyboardTracker.trackChanges { [weak self] (keyboard, _) in
            self?.collectionView.contentInset = .init(top: 0, left: 0, bottom: keyboard.height, right: 0)
        }
        navBarView.textChanged = { [weak self] text in
            guard let self else {return}
            self.clearDataSource()
            self.viewModel.clear()
            self.viewModel.search = text
            if viewModel.viewType != .stats {
                self.activityIndicator.startAnimating()
                self.viewModel.loadData()
            }
        }
        navBarView.listTapped = { [weak self] item in
            guard let self else {return}
            self.clearDataSource()
            self.viewModel.clear()
            self.activityIndicator.startAnimating()
            if item == nil {
                self.viewModel.rarity = nil
            }
            
            if let rarity = item as? Rarity {
                self.viewModel.rarity = rarity
            }
            
            if let type = item as? ItemType {
                self.viewModel.type = type
            }
            self.viewModel.loadData()
        }
        navBarView.returnButtonTapped = { [weak self] in
            guard let self else {return}
            if self.viewModel.viewType == .stats {
                navBarView.text != nil ? activityIndicator.startAnimating() : ()
                self.viewModel.loadData()
            }
        }
    }
    
    func updateHorizontalListViewType() {
        switch viewModel.viewType {
        case .skins: navBarView.listViewType = .rarity
        case .items: navBarView.listViewType = .type
        case .stats: break
        case .emotes: navBarView.listViewType = .rarity
        case .bundles: navBarView.listViewType = .rarity
        }
    }
    
    init(viewModel: MainViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.router = MainRouter(sourceViewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch dataSource[section] {
        case .items(let items): return items.count
        case .error: return 1
        case .info: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = dataSource[indexPath.section]
        
        switch section {
        case .items(let items):
            let cell = collectionView.reuse(MainCollectionViewCell.self, indexPath)
            cell.setup(with: items[indexPath.row])
            cell.delegate = self
            let isLast = indexPath.row == items.count - 1
            
            if isLast && viewModel.hasMoreData {
                viewModel.loadMore()
            }
            return cell
        case .error(let text):
            let cell = collectionView.reuse(MainErrorCollectionViewCell.self, indexPath)
            cell.setup(with: text)
            cell.delegate = self
            return cell
        case .info(let text):
            let cell = collectionView.reuse(MainInfoCollectionViewCell.self, indexPath)
            cell.setup(with: text)
            return cell
        }
    }
    
}



private extension MainViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = self.dataSource[sectionIndex]
            switch section {
            case .items: return self.generateItemsLayout()
            case .error: return self.generateErrorLayout()
            case .info: return self.generateInfoLayout()
            }
        }
        return layout
    }
    
    
    func generateItemsLayout() -> NSCollectionLayoutSection {
        let itemWidth = (UIScreen.main.bounds.width - (21 * 2) - (14 * 2)) / 3
        let itemHeight = itemWidth / 0.73
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(itemHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(14)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 21, bottom: 0, trailing: 21)
        section.interGroupSpacing = 14
        
        return section
    }
    
    func generateErrorLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(collectionView.frame.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func generateInfoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
}

private extension MainViewController {
    
    func clearDataSource() {
        dataSource = []
    }
    
    func updateDataSource(with model: Any) {
        dataSource = createDataSource(with: model)
    }
    
    func createDataSource(with model: Any) -> [Section] {
        var sections = [Section]()
        
        if let items = model as? [ItemShort] {
            collectionView.isScrollEnabled = true
            if items.isEmpty {
                sections.append(.info("Nothing found"))
            } else {
                sections.append(.items(items))
            }
        }
        
        if let error = model as? BaseError {
            collectionView.isScrollEnabled = false
            switch error {
            case .regular: sections.append(.error(error.localizedDescription))
            case .custom(let decodedError):
                if decodedError.code == 404 && viewModel.viewType == .stats {
                    sections.append(.info("User not found"))
                } else {
                    sections.append(.error(error.localizedDescription))
                }
            }
        }
        
        return sections
    }
    
}

extension MainViewController: MainCollectionViewCellDelegate {
    
    func itemTapped(with model: ItemShort) {
        view.tapGestureSelector()
        
        switch viewModel.viewType {
        case .bundles: router.route(to: .bundle(id: model.id), presentationStyle: .push(animated: true))
        case .stats: break
        default: router.route(to: .item(id: model.id), presentationStyle: .push(animated: true))
        }
    }
    
}

extension MainViewController: MainNavigationBarViewDelegate {
    
    func menuBarButtonTapped() {
        router.route(to: .menu(viewType: viewModel.viewType), presentationStyle: .modalFade)
    }
    
}

extension MainViewController: MainErrorCollectionViewCellDelegate {
    
    func reloadButtonTapped() {
        clearDataSource()
        activityIndicator.startAnimating()
        viewModel.loadData()
    }
    
}
