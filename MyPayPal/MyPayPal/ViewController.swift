//
//  ViewController.swift
//  MyPayPal
//
//  Created by User on 10/10/16.
//  Copyright © 2016 TrangTu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    var environment:String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnectWithEnvironment(newEnvironment)
            }
        }
    }
    
    var resultText = "" // empty
    var payPalConfig = PayPalConfiguration() // default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cardInfo = CardIOCreditCardInfo()
        
        title = "PayPal SDK Demo"
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Awesome Shirts, Inc."
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
    
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0]
        
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        
        payPalConfig.payPalShippingAddressOption = .PayPal
        
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }
    
    @IBAction func openSinglePayment(sender: AnyObject) {
        resultText = ""
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        // Optional: include multiple items
        let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
        let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
        let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
        
        let items = [item1, item2, item3]
        let subtotal = PayPalItem.totalPriceForItems(items)
        
    
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "5.99")
        let tax = NSDecimalNumber(string: "2.50")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
        
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Hipster Clothing", intent: .Sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            presentViewController(paymentViewController!, animated: true, completion: {
//                self.jumpToMunualScan(paymentViewController!.view)
            })
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }
    }

    @IBAction func openCardIO(sender: AnyObject) {
            let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
            cardIOVC!.maskManualEntryDigits = true
            cardIOVC.modalPresentationStyle = .FormSheet
            cardIOVC.view.hidden = true
            cardIOVC.delegate = self
        presentViewController(cardIOVC, animated: true, completion: {
            self.jumpToMunualScan(cardIOVC.view)
            cardIOVC.view.hidden = false
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnectWithEnvironment(environment)

    }
    
    func jumpToMunualScan(view: UIView) {
            if view is UIButton {
                let button: UIButton = view as! UIButton
                let allTargets = button.allTargets()
                let allControlEvents: UInt = button.allControlEvents().rawValue
                let actions: Array = button.actionsForTarget(allTargets.first, forControlEvent: UIControlEvents(rawValue: allControlEvents))!
                
                if actions.count > 0 {
                    let action: String = actions[0] as String
                    if action.caseInsensitiveCompare("manualEntry:") == NSComparisonResult.OrderedSame {
                        button.sendAction(NSSelectorFromString(action as String), to: allTargets.first, forEvent: nil)
                        return
                    }
                }
            } else if view is UITableView {
              print("Table View Here")
                let cell = (view as! UITableView).visibleCells
                let viewCell = cell[2] as UITableViewCell
                viewCell.subviews[0].removeFromSuperview()
                viewCell.layoutSubviews()
        }
        let subviews = view.subviews
        for i in 0 ..< subviews.count {
            jumpToMunualScan(subviews[i])
        }
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if (navigationController.viewControllers.count > 1) {
            let buttonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(self.barButtonItemClicked(_:)))
            viewController.navigationItem.leftBarButtonItem = buttonItem
        }
    }
    
    func barButtonItemClicked(buttonItem: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController : CardIOPaymentViewControllerDelegate {
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        print(cardInfo)
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }

}

extension ViewController : PayPalPaymentDelegate {
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController, didCompletePayment completedPayment: PayPalPayment) {
        
    }
}

