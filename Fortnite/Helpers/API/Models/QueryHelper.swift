import Foundation

class QueryHelper {
    
    static func getHeaders() -> [String: String]? {
        var result: [String: String] = .init()
        result["Content-Type"] = "application/json"
        result["X-Authorization"] = auth()
        return result
    }
    
    static private func auth() -> String {
        let baseDate = Date().dateInTimeZone(timeZoneIdentifier: "UTC", dateFormat: "dd.MM")
        let md5String = baseDate.md5()
        let md5range = md5String[0...9]
        let sha256 = md5range.sha256()
        return sha256
    }
    
    static func getParameters(from dictionary: [String: Any?]) -> [String: Any] {
        var data: [String: Any] = [:]
        for item in dictionary {
            if let value = item.value {
                data[item.key] = value
            }
        }
        return data
    }

}

