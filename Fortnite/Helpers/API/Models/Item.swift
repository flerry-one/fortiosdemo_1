import Foundation

// MARK: - Item
struct Bundle: Codable {
    var name: String?
    var type: [TypeElement]?
    var price: Price?
    var details: [Detail]?
    var items: [Asset]?
}



// MARK: - Item
struct Item: Codable {
    var name: String?
    var img: String?
    var type: [TypeElement]?
    var price: Price?
    var details: [Detail]?
    var assets: [Asset]?
}

// MARK: - Asset
struct Asset: Codable {
    var id: String?
    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
    }
}

// MARK: - Detail
struct Detail: Codable {
    var label, value: String?
}

// MARK: - Price
struct Price: Codable {
    var text: String?
    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case text
        case imageURL = "image_url"
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    var text, hexColor: String?

    enum CodingKeys: String, CodingKey {
        case text
        case hexColor = "hex_color"
    }
}
