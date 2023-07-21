import Foundation

enum MainViewType: String, CaseIterable {
    case skins
    case items
    case emotes
    case bundles
    case stats
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    var activateActivityIndactorImmediatly: Bool {
        return self != .stats
    }
}

