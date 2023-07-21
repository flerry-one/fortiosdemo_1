import Foundation

struct ListResponse<T: Codable>: Codable {
    let data: [T]?
    let total: Int
    let hasMore: Bool

    enum CodingKeys: String, CodingKey {
        case data
        case total
        case hasMore = "has_more"
    }
}
