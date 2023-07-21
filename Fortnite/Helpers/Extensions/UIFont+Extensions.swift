import UIKit

extension UIFont {
    
    static func getNames() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
    enum Names {
        static let Floripa = "Floripa"
        static let Steppe = "Steppe"
        static let Estrella = "Estrella"
    }
    
    class Floripa {
        
        static func regular(size: CGFloat) -> UIFont {
            return  UIFont(name: Names.Floripa, size: size)!
        }
        
    }
    
    class Steppe {
        
        static func book(size: CGFloat) -> UIFont {
            return  UIFont(name: Names.Steppe + "-" + "Book", size: size)!
        }
        
        static func semibold(size: CGFloat) -> UIFont {
            return  UIFont(name: Names.Steppe + "-" + "SemiBold", size: size)!
        }
        
        static func black(size: CGFloat) -> UIFont {
            return  UIFont(name: Names.Steppe + "-" + "Black", size: size)!
        }
    }
    
    class Estrella {
        
        static func early(size: CGFloat) -> UIFont {
            return  UIFont(name: Names.Estrella + "Early", size: size)!
        }
        
    }
    
}
