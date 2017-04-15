import Foundation
import UIKit
import StoreKit


@IBDesignable class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSFontAttributeName: font],
                                                                    context: nil).size
            super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}

class InAppPurchaseCell : UITableViewCell {
    @IBOutlet weak var name:            UILabel!
    @IBOutlet weak var detail:          TopAlignedLabel!
    @IBOutlet weak var price:           UILabel!
    
    static let priceFormatter: NumberFormatter = {
        let formatter                                       = NumberFormatter();
        
        formatter.formatterBehavior                         = .behavior10_4;
        formatter.numberStyle                               = .currency;
        
        return formatter;
    }();
    
    var buyButtonHandler: ((_ product: SKProduct) -> ())?
    
    var product: SKProduct? {
        didSet {
            guard let product                               = product else { return; }
            
            name?.text                                      = product.localizedTitle;
            detail?.text                                    = product.localizedDescription;
            
            if IAPSwiftProducts.store.isProductPurchased(product.productIdentifier) {
                accessoryType                               = .checkmark;
                accessoryView                               = nil;
                detailTextLabel?.text                       = "";
            }
            else if InAppPurchasesHelper.canMakePayments() {
                InAppPurchaseCell.priceFormatter.locale     = product.priceLocale;
                price?.text                                 = InAppPurchaseCell.priceFormatter.string(from: product.price)!;
                
                accessoryType                               = .none;
                accessoryView                               = self.newBuyButton();
            }
            else {
                detailTextLabel?.text                       = "Indisponível";
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        name?.text                                          = "";
        detail?.text                                        = "";
        price?.text                                         = "";
        accessoryView                                       = nil;
    }
    
    func newBuyButton() -> UIButton {
        let button = UIButton(type: .system);
        button.setTitleColor(tintColor, for: UIControlState());
        button.setTitle("Comprar", for: UIControlState());
        button.addTarget(self, action: #selector(InAppPurchaseCell.buyButtonTapped(_:)), for: .touchUpInside);
        button.sizeToFit();
        
        return button;
    }
    
    func buyButtonTapped(_ sender: AnyObject) {
        buyButtonHandler?(product!);
    }
}
