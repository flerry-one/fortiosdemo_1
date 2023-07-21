import UIKit

protocol PageIndicatorDelegate: AnyObject {
    func didSelectPageAtIndex(_ index: Int)
}

class PageIndicatorView: UIView {
    
    weak var delegate: PageIndicatorDelegate?
    
    var selectedColor = UIColor(red: 0.584, green: 0.055, blue: 1, alpha: 1)
    var defaultColor = UIColor(red: 0.584, green: 0.055, blue: 1, alpha: 0.3)
    
    var itemsCount: Int = 0 {
        didSet {
            self.updateIndicatorSubviews()
        }
    }
    
    var selectedItemIndex: Int = 0 {
        didSet {
            self.updateSelectedItem()
        }
    }
    
    private let itemSize: CGSize = CGSize(width: 10.0, height: 10.0)
    private let itemSpacing: CGFloat = 10.0
    private let selectedItemScale: CGFloat = 1.5
    
    private var indicatorSubviews: [UIView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    private func updateIndicatorSubviews() {
        self.indicatorSubviews.forEach({ $0.removeFromSuperview() })
        self.indicatorSubviews = []
        
        let totalWidth = CGFloat(self.itemsCount) * (self.itemSize.width + self.itemSpacing) - self.itemSpacing
        var itemOrigin = CGPoint(x: (self.bounds.width - totalWidth) / 2, y: (self.bounds.height - self.itemSize.height) / 2)
        
        for index in 0..<self.itemsCount {
            let itemView = UIView(frame: CGRect(origin: itemOrigin, size: self.itemSize))
            itemView.layer.cornerRadius = self.itemSize.width / 2
            
            if index == self.selectedItemIndex {
                itemView.backgroundColor = selectedColor
                itemView.transform = CGAffineTransform(scaleX: self.selectedItemScale, y: self.selectedItemScale)
            } else {
                itemView.backgroundColor = defaultColor
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapItem(_:)))
            itemView.addGestureRecognizer(tapGesture)
            
            self.addSubview(itemView)
            self.indicatorSubviews.append(itemView)
            
            itemOrigin.x += self.itemSize.width + self.itemSpacing
        }
    }
    
    private func updateSelectedItem() {
        guard self.indicatorSubviews.count > 0 else { return }
        let sitems =  self.indicatorSubviews
        //let selectedItem = self.indicatorSubviews[self.selectedItemIndex]
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            sitems.forEach({ $0.backgroundColor = self.defaultColor })
            
            for (i,v) in sitems.enumerated() {
                if i == self.selectedItemIndex {
                    v.backgroundColor = self.selectedColor
                    v.transform = CGAffineTransform(scaleX: self.selectedItemScale, y: self.selectedItemScale)
                } else {
                    v.backgroundColor = self.defaultColor
                    v.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
            
            
            
        }, completion: nil)
    }
    
    @objc private func didTapItem(_ sender: UITapGestureRecognizer) {
        guard let tappedItemIndex = self.indicatorSubviews.firstIndex(where: { $0 == sender.view }) else { return }
        self.delegate?.didSelectPageAtIndex(tappedItemIndex)
    }
    
}

extension PageIndicatorView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentItemIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        self.selectedItemIndex = currentItemIndex
    }
    
}

