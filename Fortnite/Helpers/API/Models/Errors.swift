import Foundation

// MARK: - CustomError
struct CustomError: Codable {
    var code: Int
    var message: String
}

enum BaseError: Error {
    case regular(Error)
    case custom(CustomError)
}

extension BaseError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .regular(let error): return error.localizedDescription
        case .custom(let error): return error.message
        }
    }
    
}
