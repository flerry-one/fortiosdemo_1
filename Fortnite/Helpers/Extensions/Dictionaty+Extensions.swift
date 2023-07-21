import Foundation

extension Dictionary {
    
    func jsonData() -> Data {
        return try! JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
    
}

extension Dictionary {
    
    func stringAsJSON() -> String? {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.utf8) {
            return theJSONText
        }
        return nil
    }
}
