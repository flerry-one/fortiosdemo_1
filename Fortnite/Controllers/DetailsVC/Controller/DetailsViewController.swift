import UIKit

class DetailsViewController: BaseViewController<DetailsViewModel, DetailsRouter> {
    
    private lazy var navBarViewView: DetailsNavBarView = {
        $0.delegate = self
        return $0
    }(DetailsNavBarView())
    
    private lazy var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.register(DetailsGalleryTableViewCell.self)
        $0.register(DetailsTypeTableViewCell.self)
        $0.register(DetailsDetailTableViewCell.self)
        $0.register(DetailsPriceTableViewCell.self)
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        return $0
    }(UITableView.init(frame: CGRect.zero, style: .plain))
    
    private lazy var bottomView: DetailsBottomView = {
        $0.isHidden = true
        return $0
    }(DetailsBottomView())
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        $0.style = .large
        $0.color = .white
        $0.startAnimating()
        return $0
    }(UIActivityIndicatorView())
    
    enum Section {
        case gallery(model: GalleryModel)
        case space(value: CGFloat)
        case type(items: [TypeElement])
        case details(item: Detail)
        case price(item: Price)
    }
    
    var dataSource = [Section]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
        enableInteractivePopGesture()
    }
    
    override func setupAppearence() {
        view.backgroundColor = .black
    }
    
    override func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(bottomView)
        view.addSubview(activityIndicator)
        view.addSubview(navBarViewView)
        
        bottomView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(180)
            
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navBarViewView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    override func bind() {
        viewModel.$successItemResult.sink { [weak self] value in
            guard let self, let value else {return}
            self.bottomView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.updateDataSource(with: value)
        }.store(in: &viewModel.cancellables)
        viewModel.$successBundleResult.sink { [weak self] value in
            guard let self, let value else {return}
            self.bottomView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.updateDataSource(with: value)
        }.store(in: &viewModel.cancellables)
        viewModel.$errorResult.sink { [weak self] value in
            guard let self, let value else {return}
            self.activityIndicator.stopAnimating()
        }.store(in: &viewModel.cancellables)
    }
    
    init(viewModel: DetailsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.router = DetailsRouter(sourceViewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension DetailsViewController: DetailsNavBarViewDelegate {
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

private extension DetailsViewController {
    
    func updateDataSource(with model: Any?) {
        dataSource = createDataSource(with: model)
    }
    
    func createDataSource(with model: Any?) -> [Section] {
        var sections = [Section]()
        
        if let item = model as? Item {
            
            if isLongScreen {
                sections.append(.space(value: 40))
            }
            
            sections.append(.gallery(model: .single(urlString: item.img, name: item.name)))
            
            sections.append(.space(value: isLongScreen ? 30 : 20))
            
            sections.append(.type(items: item.type ?? []))
            
            if let price = item.price {
                sections.append(.space(value: 10))
                sections.append(.price(item: price))
                sections.append(.space(value: 10))
            }else{
                sections.append(.space(value: 30))
            }
            
            for detail in item.details ?? [] {
                sections.append(.details(item: detail))
            }
        }
        
        if let item = model as? Bundle {
            
            if isLongScreen {
                sections.append(.space(value: 40))
            }
            
            sections.append(.gallery(model: .multy(items: item.items ?? [], name: item.name)))
            
            sections.append(.space(value: isLongScreen ? 30 : 20))
            
            sections.append(.type(items: item.type ?? []))
            
            if let price = item.price {
                sections.append(.space(value: 10))
                sections.append(.price(item: price))
                sections.append(.space(value: 10))
            }else{
                sections.append(.space(value: 30))
            }
            
            for detail in item.details ?? [] {
                sections.append(.details(item: detail))
            }
        }
        
        return sections
    }
    
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.dataSource[section]
        switch section {
        case .gallery: return 1
        case .space:  return 1
        case .type:  return 1
        case .details: return 1
        case .price: return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.dataSource[indexPath.section]
        switch section {
        case .gallery(let model):
            let cell = tableView.reuse(DetailsGalleryTableViewCell.self, indexPath)
            cell.delegate = self
            cell.setup(with: model)
            return cell
        case .space:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        case .type(let items):
            let cell = tableView.reuse(DetailsTypeTableViewCell.self, indexPath)
            cell.setup(with: items)
            return cell
        case .details(let item):
            let cell = tableView.reuse(DetailsDetailTableViewCell.self, indexPath)
            cell.setup(with: item)
            return cell
        case .price(let item):
            let cell = tableView.reuse(DetailsPriceTableViewCell.self, indexPath)
            cell.setup(with: item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.dataSource[indexPath.section]
        switch section {
        case .gallery: return 285
        case .space(let value): return value
        case .type: return UITableView.automaticDimension
        case .details: return UITableView.automaticDimension
        case .price: return 25
        }
    }
    
}

extension DetailsViewController: DetailsGalleryTableViewCellDelegate {
    
    func itemTapped(with id: String) {
        switch viewModel.viewType {
        case .regular: break
        case .bundle: router.route(to: .item(id: id), presentationStyle: .push(animated: true))
        }
    }

}
