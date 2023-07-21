import Foundation

struct ItemShort: Codable {
    let id: String
    private let img: String
    
    var imageURL: URL? {
        return URL(string: img)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case img
    }
}
