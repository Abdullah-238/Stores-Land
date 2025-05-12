import UIKit


class clsAlertHelper
{
    static func showAlert(from viewController: UIViewController , title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default))
        viewController.present(alert, animated: true)
    }
}

