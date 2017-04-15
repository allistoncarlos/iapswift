import Foundation

public struct IAPSwiftProducts {

    public static let PushNotifications         = "com.alliston.iapswift.pushnotifications";
    public static let Subscription              = "com.alliston.iapswift.noticesubscriptions";
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [
        IAPSwiftProducts.PushNotifications,
        IAPSwiftProducts.Subscription
    ];
    
    public static let store = InAppPurchasesHelper(productIds: IAPSwiftProducts.productIdentifiers)
    
    public static func canReceiveNotifications() -> Bool {
        return  IAPSwiftProducts.store.isProductPurchased(IAPSwiftProducts.PushNotifications) &&
                IAPSwiftProducts.store.isProductPurchased(IAPSwiftProducts.Subscription);
    }
    
    public static func hasActiveSubscription() -> Bool {
        return IAPSwiftProducts.store.isProductPurchased(IAPSwiftProducts.Subscription);
    }
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
