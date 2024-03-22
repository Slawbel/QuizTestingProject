import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var realmConfig: Realm.Configuration!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                }
            })

        Realm.Configuration.defaultConfiguration = config

        do {
            let realm = try Realm()
        } catch {
            print("Failed to open Realm: \(error)")
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: WelcomeScreen())

        // Enable IQKeyboardManager
        IQKeyboardManager.shared.enable = true

        window?.makeKeyAndVisible()

        return true
    }
}


