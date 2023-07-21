import SnapKit

// MARK: Gestures

extension UIView {
    
    func setupTapGesture() {
        self.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureSelector))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapGestureSelector() {
        self.endEditing(true)
    }
}

// MARK: Constraints

extension UIView {
    
    func addWidhtConstraint(value: CGFloat) {
        snp.makeConstraints {
            $0.width.equalTo(value)
        }
    }
    
    func addHeightConstraint(value: CGFloat) {
        snp.makeConstraints {
            $0.height.equalTo(value)
        }
    }
    
    func addConstraints(width: CGFloat?, height: CGFloat?) {
        if let width {
            addWidhtConstraint(value: width)
        }
        if let height {
            addHeightConstraint(value: height)
        }
    }
    
}
