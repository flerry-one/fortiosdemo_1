import Moya
import Foundation

class ResponseWrapper<T: Decodable> {
    
    static func wrap(_ result: Result<Response, MoyaError>) -> Result<T, BaseError> {
        switch result {
            
        case .success(let response):
            
            if let decodedError = try? JSONDecoder().decode(CustomError.self, from: response.data) {
                return Result.failure(BaseError.custom(decodedError))
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: response.data)
                return Result.success(decodedObject)
            } catch {
                BaseLoggerPlugin.default.decodingError(error)
                return Result.failure(BaseError.regular(error))
            }
        case .failure(let error):
            return Result.failure(BaseError.regular(error))
        }
    }
}
