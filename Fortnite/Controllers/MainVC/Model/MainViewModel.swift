import Foundation

class MainViewModel: BaseViewModel {
    
    var viewType: MainViewType {
        didSet {
            viewStateWasUpdated = true
            clear()
            loadData()
        }
    }
    
    var hasMoreData = false

    private var limit = 51
    private var offset: Int?
    
    var rarity: Rarity?
    var type: ItemType = .pickaxe
    var search: String?
    var showAllMatches = false
    
    @PostPublished var viewStateWasUpdated = false
    @PostPublished var successItemsResult: [ItemShort]?
    @PostPublished var successStatisticResult: Statistic?
    @PostPublished var errorResult: BaseError?
    
    func loadData(loadMore: Bool = false) {
        switch viewType {
        case .skins:
            ApiQuery.getSkins(limit: limit, offset: offset, search: search, rarity: rarity) { result in
                self.prepareResult(result: result, loadMore: loadMore)
            }
        case .items:
            ApiQuery.getItems(limit: limit, offset: offset, search: search, type: type) { result in
                self.prepareResult(result: result, loadMore: loadMore)
            }
        case .emotes:
            ApiQuery.getEmotes(limit: limit, offset: offset, search: search, rarity: rarity) { result in
                self.prepareResult(result: result, loadMore: loadMore)
            }
        case .bundles:
            ApiQuery.getBundles(limit: limit, offset: offset, search: search, rarity: rarity) { result in
                self.prepareResult(result: result, loadMore: loadMore)
            }
        case .stats:
            guard let search else {return}
            ApiQuery.getStatistic(name: search, showAllMatches: showAllMatches) { result in
                switch result {
                case .success(let success): self.successStatisticResult = success
                case .failure(let failure): self.errorResult = failure
                }
            }
        }
    }
    
    private func prepareResult(result: Result<ListResponse<ItemShort>, BaseError>, loadMore: Bool) {
        switch result {
        case .success(let success):
            self.hasMoreData = success.hasMore
            if loadMore {
                self.successItemsResult = (self.successItemsResult ?? []) + (success.data ?? [])
            } else {
                self.successItemsResult = (success.data ?? [])
            }
        case .failure(let failure): self.errorResult = failure
        }
        
    }
    
    func loadMore() {
        offset = (offset ?? 0) +  limit
        loadData(loadMore: true)
    }
    
    func clear() {
        hasMoreData = false
        offset = nil
    }
    
    init(viewType: MainViewType) {
        self.viewType = viewType
    }
    
}
