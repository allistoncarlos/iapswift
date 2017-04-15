import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // In-App Purchases
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AppDelegate.productPurchased(_:)),
                                               name: NSNotification.Name(rawValue: InAppPurchasesHelper.IAPHelperPurchaseNotification),
                                               object: nil);
        
        if (IAPSwiftProducts.canReceiveNotifications()) {
            didFinishPurchasing();
        }
        
        return true
    }

    // MARK: - In-App Purchases
    func productPurchased(_ notification: Notification) {
        didFinishPurchasing();
    }
    
    // Registrar para notificações
    private func didFinishPurchasing() {
        if (IAPSwiftProducts.canReceiveNotifications()) {
            // Registrar notificações
        }
    }
}

