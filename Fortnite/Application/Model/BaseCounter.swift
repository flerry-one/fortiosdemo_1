import Foundation

class BaseCounter {
    
    private let time: Int
    
    private var timer: Timer?
    private lazy var counter = time
    
    var updated: ((Int) -> Void)?
    var completed: (() -> Void)?
    var stopped: (() -> Void)?
    
    @objc private func updateCounter() {
        if counter > 1 {
            counter -= 1
            updated?(counter)
        } else {
            completed?()
            invalidateTimer()
            stopped?()
        }
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        updateCounter()
    }
    
    func invalidateTimer() {
        counter = time
        timer?.invalidate()
        timer = nil
    }
    
    init(time: Int) {
        self.time = time
    }
    
}
