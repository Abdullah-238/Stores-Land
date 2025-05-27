import UIKit

class SignInViewController: UIViewController
{

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
              self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    @IBAction func btnSignIn(_ sender: Any)
    {
        guard let email = txtEmail.text, !email.isEmpty, let password = txtPassword.text, !password.isEmpty
        else
        {
            clsAlertHelper.showAlert(from: self,title: NSLocalizedString("error", comment: ""),
                      message: NSLocalizedString("error_empty_fields", comment: ""))
            return
        }

        guard clsUtil.isValidEmail(email)
        else
        {
            clsAlertHelper.showAlert(from: self,title: NSLocalizedString("error", comment: ""),
                      message: NSLocalizedString("error_invalid_email", comment: ""))
            return
        }

        Task
        {
            do
            {
                if let person = try await clsPerson.findPersonByEmailAndPassword(email: email, password: password)
                {
                    if person.isActive
                    {
                        clsGlobal.person = person
                        clsGlobal.PersonId = person.personID

                        UserDefaults.standard.set(person.personID, forKey: "LoggingInPersonID")

                        let categoriesVC = storyboard?.instantiateViewController(identifier: "HomeVs") as! HomeTabbedViewController
                        categoriesVC.modalPresentationStyle = .fullScreen
                        present(categoriesVC, animated: true)
                    }
                    else
                    {
                        clsAlertHelper.showAlert(from: self,title: NSLocalizedString("account_inactive", comment: ""),
                                  message: NSLocalizedString("contact_support", comment: ""))
                    }
                }
                else
                {
                    clsAlertHelper.showAlert(from: self, title: NSLocalizedString("login_failed", comment: ""),
                              message: NSLocalizedString("invalid_credentials", comment: ""))
                }
            }
            catch
            {
                clsAlertHelper.showAlert(from: self, title: NSLocalizedString("error", comment: ""),
                          message: NSLocalizedString("login_error", comment: ""))
                print("Login error: \(error)")
            }
        }
    }
    
    
    @objc func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
   
}
