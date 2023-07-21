import Foundation

extension Collection {
    func getElementIfExists(at index: Index) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}
