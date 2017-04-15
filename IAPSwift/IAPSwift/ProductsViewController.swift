import UIKit
import StoreKit

class ProductsViewController : UITableViewController {
    // MARK: - Properties
    var products = [SKProduct]();
    var sections = ["Compra Única", "Assinaturas"];
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // InAppPurchases
        let restoreButton = UIBarButtonItem(title: "Restaurar",
                                            style: .plain,
                                            target: self,
                                            action: #selector(restoreInAppPurchases(sender:)));
        
        navigationItem.rightBarButtonItem = restoreButton;
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ProductsViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: InAppPurchasesHelper.IAPHelperPurchaseNotification),
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        reload();
    }
    
    // MARK: - In-App Purchases Methods
    func restoreInAppPurchases(sender: UIBarButtonItem) {
        IAPSwiftProducts.store.restorePurchases();
    }
    
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for (index, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
            let resultSection   = productID == IAPSwiftProducts.PushNotifications ? 0 : 1;
            let resultIndex     = productID == IAPSwiftProducts.PushNotifications ? 0 : index - 1;
            
            tableView.reloadRows(at: [IndexPath(row: resultIndex, section: resultSection)], with: .fade)
        }
    }
    
    func reload() {
        self.products = [];
        
        tableView.reloadData();
        
        IAPSwiftProducts.store.requestProducts{success, products in
            if (success) {
                self.products = products!;
                
                self.tableView.reloadData();
            }
        }
    }
    
    // MARK: - TableView methods
    internal override func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    internal override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section];
    }
    
    
    internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1;
        }
        else {
            return self.products.count - 1;
        }
    }
    
    internal override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width;
        
        switch screenWidth {
        // iPhone 5/5S/SE Vertical
        case 320:
            return 95;
        // iPhone 6/6S/7 Vertical
        case 375:
            return 75;
        // iPhone 6+/6S+/7+ Vertical
        case 414:
            return 70
        default:
            return 65
        }
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableIdentifier = "InAppPurchaseCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? InAppPurchaseCell;
        
        if (cell == nil)
        {
            tableView.register(UINib(nibName: reusableIdentifier, bundle: nil), forCellReuseIdentifier: reusableIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? InAppPurchaseCell
        }
        
        if (products.count > 0) {
            var product: SKProduct;
            
            if (indexPath.section == 0) {
                product = products[products.count - 1];
            }
            else {
                product = products[(indexPath as NSIndexPath).row];
            }
            
            cell?.product = product;
            
            cell?.buyButtonHandler = { product in
                IAPSwiftProducts.store.buyProduct(product);
            }
        }
        
        return cell!;
    }
}
