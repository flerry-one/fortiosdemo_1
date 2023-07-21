import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = []
}
