import Foundation

class SplashImageManager {
    
    static let shared = SplashImageManager()
    
    private let imageNameKey = "ImageNameKey"
    private let imageNames = ["back_1", "back_2", "back_3", "back_4"]
    
    private init() {}
    
    func getNextImageName() -> String {
        var imageName = UserDefaults.standard.string(forKey: imageNameKey) ?? ""
        if imageName.isEmpty {
            imageName = imageNames.first ?? ""
        } else if let index = imageNames.firstIndex(of: imageName) {
            let nextIndex = (index + 1) % imageNames.count
            imageName = imageNames[nextIndex]
        }
        UserDefaults.standard.set(imageName, forKey: imageNameKey)
        return imageName
    }
    
}
