import UIKit

class Coordinator {
    static func openAnotherScreen (from: UIViewController, to: UIViewController) {
        to.modalPresentationStyle = .fullScreen
        from.present(to, animated: true)
    }
    
    static func closeAnotherScreen (from: UIViewController) {
        from.dismiss(animated: true)
    }
}
