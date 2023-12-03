import UIKit

extension UIView {
    
    func roundCorners(radius: CGFloat = Constants.UIViewExtension.radius) {
        return self.layer.cornerRadius = radius
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Constants.UIViewExtension.shadowOpacity
        layer.shadowOffset = Constants.UIViewExtension.shadowOffset
        layer.shadowRadius = Constants.UIViewExtension.shadowRadius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
}
