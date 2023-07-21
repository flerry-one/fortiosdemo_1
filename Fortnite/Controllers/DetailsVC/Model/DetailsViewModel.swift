import Foundation

class DetailsViewModel: BaseViewModel {
    
    enum ViewType {
        case regular(id: String)
        case bundle(id: String)
    }
    
    let viewType: ViewType
    
    @PostPublished var successItemResult: Item?
    @PostPublished var successBundleResult: Bundle?
    @PostPublished var errorResult: String?
    
    func loadData() {
        switch viewType {
        case .regular(let id):
            ApiQuery.getItem(id: id) { result in
                switch result {
                case .success(let success): self.successItemResult = success
                case .failure(let failure): self.errorResult = failure.localizedDescription
                }
            }
        case .bundle(let id):
            ApiQuery.getBundle(id: id) { result in
                switch result {
                case .success(let success): self.successBundleResult = success
                case .failure(let failure): self.errorResult = failure.localizedDescription
                }
            }
        }
    }
    
    
    init(viewType: ViewType) {
        self.viewType = viewType
    }
    
}
