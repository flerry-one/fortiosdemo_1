import Foundation
import Moya

class ApiQuery {
    
    private static let provider = MoyaProvider<APITarget>(plugins: [BaseLoggerPlugin.default])
    
    static func getSkins(limit: Int?, offset: Int?, search: String?, rarity: Rarity?, completion: @escaping (Result<ListResponse<ItemShort>, BaseError>) -> Void) {
        provider.request(.getSkins(limit: limit, offset: offset, search: search, rarity: rarity), completion: { result in
            completion(ResponseWrapper<ListResponse<ItemShort>>.wrap(result))
        })
    }
    
    static func getEmotes(limit: Int?, offset: Int?, search: String?, rarity: Rarity?, completion: @escaping (Result<ListResponse<ItemShort>, BaseError>) -> Void) {
        provider.request(.getEmotes(limit: limit, offset: offset, search: search, rarity: rarity), completion: { result in
            completion(ResponseWrapper<ListResponse<ItemShort>>.wrap(result))
        })
    }
    
    static func getBundles(limit: Int?, offset: Int?, search: String?, rarity: Rarity?, completion: @escaping (Result<ListResponse<ItemShort>, BaseError>) -> Void) {
        provider.request(.getBundles(limit: limit, offset: offset, search: search, rarity: rarity), completion: { result in
            completion(ResponseWrapper<ListResponse<ItemShort>>.wrap(result))
        })
    }
    
    static func getItems(limit: Int?, offset: Int?, search: String?, type: ItemType, completion: @escaping (Result<ListResponse<ItemShort>, BaseError>) -> Void) {
        provider.request(.getItems(limit: limit, offset: offset, search: search, type: type), completion: { result in
            completion(ResponseWrapper<ListResponse<ItemShort>>.wrap(result))
        })
    }
    
    static func getItem(id: String, completion: @escaping (Result<Item, BaseError>) -> Void) {
        provider.request(.getItem(id: id), completion: { result in
            completion(ResponseWrapper<Item>.wrap(result))
        })
    }
    
    static func getBundle(id: String, completion: @escaping (Result<Bundle, BaseError>) -> Void) {
        provider.request(.getBundle(id: id), completion: { result in
            completion(ResponseWrapper<Bundle>.wrap(result))
        })
    }
    
    static func getStatistic(name: String, showAllMatches: Bool, completion: @escaping (Result<Statistic, BaseError>) -> Void) {
        provider.request(.getStatistic(name: name, showAllMatches: showAllMatches), completion: { result in
            completion(ResponseWrapper<Statistic>.wrap(result))
        })
    }
    
}


