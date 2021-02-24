import UIKit

extension UIFont {
    
    static func avenir(size: CGFloat) -> UIFont? {
        return UIFont.init(name: "avenir", size: size)
    }
    
    static func avenir24() -> UIFont? {
        return UIFont.init(name: "avenir", size: 24)
    }
    
    static func avenir20() -> UIFont? {
        return UIFont.init(name: "avenir", size: 20)
    }
    
    static func avenir18() -> UIFont? {
        return UIFont.init(name: "avenir", size: 20)
    }
    
    static let avenir30: UIFont? = UIFont.init(name: "avenir", size: 30)
    
    static func avenirBold18() -> UIFont? {
        return UIFont.init(name: "avenir-black", size: 18)
    }
    
    static func avenir26() -> UIFont? {
        return UIFont.init(name: "avenir", size: 26)
    }
    
    static func avenirBold28() -> UIFont? {
        return UIFont.init(name: "avenir-black", size: 28)
    }
    
    
}

extension UIFont {
var bold: UIFont {
return with(.traitBold)
}

var italic: UIFont {
return with(.traitItalic)
}

var boldItalic: UIFont {
return with([.traitBold, .traitItalic])
}



func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
return self
}
return UIFont(descriptor: descriptor, size: 0)
}

func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
return self
}
return UIFont(descriptor: descriptor, size: 0)
}
}
