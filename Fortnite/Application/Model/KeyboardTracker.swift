import UIKit

public class KeyboardTracker {

    // MARK: - Properties.

    private var completion: ((_ keyboard: Keyboard, _ isFirstChange: Bool) -> Void)?
    private var isFirstChange = true

    // MARK: - Observed Properties.

    private var keyboard: Keyboard? {
        didSet {
            guard let keyboard = keyboard else {
                return
            }

            guard keyboard.isSufficientlyDifferent(fromKeyboard: oldValue) else {
                return
            }

            completion?(keyboard, isFirstChange)
            isFirstChange = false
        }
    }
    
    // MARK: - Initialization.
    
    public init() {}
    
    // MARK: - Public Methods.

    public func trackChanges(then completion: @escaping (_ keyboard: Keyboard, _ isFirstChange: Bool) -> Void) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        self.completion = completion
    }
    
    // MARK: - Notifications.

    @objc
    private func keyboardDidChange(_ notification: Notification) {
        guard let keyboard = Keyboard(notification: notification) else {
            return
        }

        self.keyboard = keyboard
    }

}
