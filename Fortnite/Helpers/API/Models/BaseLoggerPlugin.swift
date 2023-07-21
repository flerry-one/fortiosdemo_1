import Foundation
import Moya

enum BaseLoggerLevel {
    case off
    case debug
}

class BaseLoggerPlugin {
    
    private let level: BaseLoggerLevel
    
    init(level: BaseLoggerLevel = .debug) {
        self.level = level
    }
    
}

extension BaseLoggerPlugin: PluginType {
    
    public func willSend(_ request: RequestType, target: TargetType) {
        makeOutput(from: prepareRequest(request))
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response): makeOutput(from: prepareResponse(response))
        case let .failure(error): makeOutput(from: prepareError(error))
        }
    }
}

extension BaseLoggerPlugin {
    
    private func prepareRequest(_ request: RequestType) -> [String] {
        guard let request = request.request, level != .off else {return []}
        
        var result = [String]()
        
        let method = request.method?.rawValue ?? "🟡Unknown method"
        let urlString = request.url?.absoluteString ?? "🟡Empty URL"
        
        result.append(makeSingleLine(from: [
            "🔵 Request",
            method,
            urlString
        ]))
        
        result.append("▪️ Headers")
        result.append(makeHeadersString(items: request.allHTTPHeaderFields))
        result.append("▪️ END Headers")
        
        result.append("▪️ Body")
        result.append(makeBodyString(from: request.httpBody))
        result.append("▪️ END Body")
        
        result.append(makeSingleLine(from: [
            "🔵 END Request",
            method,
            urlString
        ]))
        
        result.append("\n")
        
        return result
    }
    
    private func prepareResponse(_ response: Response) -> [String] {
        guard level != .off else {return []}
        var result = [String]()
        
        let statusCode = String(response.statusCode)
        let method = response.request?.method?.rawValue ?? "🟡Unknown method"
        let urlString = response.request?.url?.absoluteString ?? "🟡Empty URL"
        
        result.append(makeSingleLine(from: [
            "🟢 Response",
            statusCode,
            method,
            urlString
        ]))
        
        result.append("▪️ Headers")
        result.append(makeHeadersString(items: response.response?.allHeaderFields))
        result.append("▪️ END Headers")
        
        result.append("▪️ Body")
        result.append(makeBodyString(from: response.data))
        result.append("▪️ END Body")
        
        result.append(makeSingleLine(from: [
            "🟢 END Response",
            statusCode,
            method,
            urlString
        ]))
        
        result.append("\n")
        
        return result
    }
    
    private func prepareError(_ error: MoyaError) -> [String] {
        guard level != .off else {return []}
        var result = [String]()
        
        let statusCode = String(Int(error.response?.statusCode ?? 0))
        let method = error.response?.request?.method?.rawValue ?? "🟡Unknown method"
        let urlString = error.response?.response?.url?.absoluteString ?? "🟡Empty URL"
        
        result.append(makeSingleLine(from: [
            "🔴 Error",
            statusCode,
            method,
            urlString
        ]))
        
        result.append("▪️ Headers")
        result.append(makeHeadersString(items: error.response?.response?.allHeaderFields))
        result.append("▪️ END Headers")
        
        result.append("▪️ Body")
        result.append(makeBodyString(from: error.response?.data))
        result.append("▪️ END Body")
        
        result.append(makeSingleLine(from: [
            "🔴 END Error",
            statusCode,
            method,
            urlString
        ]))
        
        result.append("\n")
        
        return result
    }
    
}

extension BaseLoggerPlugin {
    
    private func makeOutput(from items: [String]) {
        for item in items {
            print(item, separator: ",", terminator: "\n")
        }
    }
    
    private func makeSingleLine(from items: [String]) -> String {
        var result = ""
        
        for item in items {
            result += item
            result += " "
        }
        
        return result
    }
    
}

extension BaseLoggerPlugin {
    
    private func makeBodyString(from data: Data?) -> String {
        guard let data else {return "Body data is nil"}
        
        var result = ""
        
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let string = dataDict.stringAsJSON() {
                result = string
            } else {
                result = String(describing: dataDict)
            }
        } else if let resultString = String(data: data, encoding: .utf8) {
            result = resultString
        } else {
            result = "🟡Serilization faild"
        }
        
        return result
    }
    
    private func makeHeadersString(items: [AnyHashable: Any]?) -> String {
        guard let items else {return "Headers in nil"}
        
        func anyToString(any: Any?) -> String {
            if let string = any as? String {
                return string
            } else if let number = any as? Double {
                return String(number)
            }
            return "🟡Header value decode from any faild"
        }
        
        var result = ""
        
        for (index, key) in items.keys.enumerated() {
            
            if let key = key as? String {
                result += ("✶ " + key + " ✶ " + anyToString(any: items[key]))
            }
            
            if index != items.count - 1 {
                result += "\n"
            }
            
        }
        
        return result
    }
    
}

extension BaseLoggerPlugin {
    
    class var `default`: BaseLoggerPlugin {
        return BaseLoggerPlugin(level: .debug)
    }
}

extension BaseLoggerPlugin {
    
    func decodingError(_ error: Error) {
        print("🆘 Decoding Error")
        dump(error)
        print("🆘 END Decoding Error")
    }
    
}
