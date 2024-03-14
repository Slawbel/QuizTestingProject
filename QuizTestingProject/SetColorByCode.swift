import UIKit

// this structure was needed for defining and setting collor due to code RGB
struct SetColorByCode {
    static func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func applyGradientBackground(to view: UIView, colorsHex: [String]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]

        // Convert hex color codes to UIColors
        let colors = colorsHex.map { hexStringToUIColor(hex: $0) }

        // Convert UIColors to CGColor
        let cgColors = colors.map { $0.cgColor }

        gradientLayer.colors = cgColors
        gradientLayer.frame = view.bounds
        view.backgroundColor = nil
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
