import Foundation

import Moya
import Foundation

enum Rarity: String, Codable, CaseIterable {
    case legendary
    case epic
    case rare
    case uncommon
    case common
    case dc
    case frozen
    case gaming
    case icon
    case lava
    case marvel
    case shadow
    case slurp
    case starwars
    
    var title: String {
        return self.rawValue.capitalized
    }
}

enum ItemType: String, Codable, CaseIterable {
    case pickaxe, backpack, glider, wrap, contrail
    
    var title: String {
        return self.rawValue.capitalized
    }
}

enum APITarget {
    case getSkins(limit: Int?, offset: Int?, search: String?, rarity: Rarity?)
    case getEmotes(limit: Int?, offset: Int?, search: String?, rarity: Rarity?)
    case getItems(limit: Int?, offset: Int?, search: String?, type: ItemType)
    case getBundles(limit: Int?, offset: Int?, search: String?, rarity: Rarity?)
    case getItem(id: String)
    case getBundle(id: String)
    case getStatistic(name: String, showAllMatches: Bool)
}

extension APITarget: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://fortisapi.com")!
    
    }
    
    var path: String {
        switch self {
        case .getSkins: return "skins"
        case .getEmotes: return "emotes"
        case .getItems: return "items"
        case .getBundles: return "bundles"
        case .getItem: return "cosmetics"
        case .getBundle: return "bundle"
        case .getStatistic: return "stats"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        switch self {
        case .getSkins(let limit, let offset, let search, let rarity):
            var parameters: [String: Any?] = .init()
            parameters["limit"] = limit
            parameters["offset"] = offset
            parameters["search"] = search
            parameters["rarity"] = rarity
            return .requestParameters(parameters: QueryHelper.getParameters(from: parameters), encoding: URLEncoding.queryString)
        case .getEmotes(let limit, let offset, let search, let rarity):
            var parameters: [String: Any?] = .init()
            parameters["limit"] = limit
            parameters["offset"] = offset
            parameters["search"] = search
            parameters["rarity"] = rarity
            return .requestParameters(parameters: QueryHelper.getParameters(from: parameters), encoding: URLEncoding.queryString)
        case .getItems(let limit, let offset, let search, let type):
            var parameters: [String: Any?] = .init()
            parameters["limit"] = limit
            parameters["offset"] = offset
            parameters["search"] = search
            parameters["type"] = type
            return .requestParameters(parameters: QueryHelper.getParameters(from: parameters), encoding: URLEncoding.queryString)
        case .getBundles(let limit, let offset, let search, let rarity):
            var parameters: [String: Any?] = .init()
            parameters["limit"] = limit
            parameters["offset"] = offset
            parameters["search"] = search
            parameters["rarity"] = rarity
            return .requestParameters(parameters: QueryHelper.getParameters(from: parameters), encoding: URLEncoding.queryString)
        case .getItem(id: let id):
            var parameters: [String: Any?] = .init()
            parameters["id"] = id
            return .requestParameters(parameters: QueryHelper.getParameters(from: parameters), encoding: URLEncoding.queryString)
        case .getBundle(id: let id):
            var parameters: [String: Any?] = .init()
            parameters["id"] = id
            return .requestParameters(parameters: QueryHelper.getParameters(from: parameters), encoding: URLEncoding.queryString)
        case .getStatistic(let name, let showAllMatches):
            var parameters: [String: Any?] = .init()
            parameters["all_matches"] = showAllMatches
            parameters["search"] = name
            return .requestParameters(parameters: QueryHelper.getParameters(from: parameters), encoding: URLEncoding.queryString)
        }
    
        
    }
    
    var headers: [String: String]? {
        return QueryHelper.getHeaders()
    }
    
    var validationType: Moya.ValidationType {
        return .successCodes
    }
    
}
    
