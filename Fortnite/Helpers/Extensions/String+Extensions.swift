import Foundation
import CryptoKit

extension String {
    
    func md5() -> String {
        return Insecure.MD5.hash(data: self.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
    
    func sha256() -> String {
        let sha256 = SHA256.hash(data: Data(self.utf8))
        return sha256.compactMap { String(format: "%02x", $0) }.joined()
    }
    
}

extension String {
    
    subscript(range: ClosedRange<Int>) -> String {
        let start = String.Index(utf16Offset: range.lowerBound, in: self)
        let end = String.Index(utf16Offset: range.upperBound, in: self)
        return String(self[start...end])
    }
    
}

extension StringProtocol {
    subscript(_ offset: Int) -> Element { self[index(startIndex, offsetBy: offset)] }
}

extension String {
    
    public var trim: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
}
