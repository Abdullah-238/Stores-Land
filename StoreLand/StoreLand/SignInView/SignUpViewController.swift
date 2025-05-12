import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtReTypePassword: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        
        txtPass.delegate = self
        txtReTypePassword.delegate = self
        txtEmail.delegate = self
        txtPhoneNumber.delegate = self
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxPasswordLength = 20, maxEmailLength = 50, maxPhoneLength = 9
        
        guard let currentText = textField.text as NSString? else { return true }
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        if textField == txtPass || textField == txtReTypePassword
        {
            return newText.count <= maxPasswordLength
        }
        else if textField == txtEmail
        {
            return newText.count <= maxEmailLength
        }
        else if textField == txtPhoneNumber
        {
            return newText.count <= maxPhoneLength
        }
        
        return true
    }
    
    
    @IBAction func btnSignUp(_ sender: Any)
    {
        guard let name = txtName.text, !name.isEmpty,
              let phone = txtPhoneNumber.text, !phone.isEmpty,
              let email = txtEmail.text, !email.isEmpty,
              let password = txtPass.text, !password.isEmpty,
              let confirmPassword = txtReTypePassword.text, !confirmPassword.isEmpty else
        {
            clsAlertHelper.showAlert(from: self,
                                     title: NSLocalizedString("error", comment: ""),
                                     message: NSLocalizedString("missing_fields", comment: ""))
            return
        }
        
        guard clsUtil.isValidEmail(email) else
        {
            clsAlertHelper.showAlert(from: self,
                                     title: NSLocalizedString("error", comment: ""),
                                     message: NSLocalizedString("invalid_email_format", comment: ""))
            return
        }
        
        guard let phoneNumber = txtPhoneNumber.text, phoneNumber.count == 9 else
        {
            clsAlertHelper.showAlert(from: self,
                                     title: NSLocalizedString("error", comment: ""),
                                     message: NSLocalizedString("invalid_phone_number_format", comment: ""))
            return
        }
        
        guard clsUtil.isValidPassword(password) else
        {
            clsAlertHelper.showAlert(from: self,
                                     title: NSLocalizedString("error", comment: ""),
                                     message: NSLocalizedString("weak_password", comment: ""))
            return
        }
        
        guard password == confirmPassword else
        {
            clsAlertHelper.showAlert(from: self,
                                     title: NSLocalizedString("error", comment: ""),
                                     message: NSLocalizedString("password_mismatch", comment: ""))
            return
        }
        
        Task
        {
            do
            {
                let emailExists = try await clsPerson.isPersonExistsByEmail(email)
                if emailExists
                {
                    clsAlertHelper.showAlert(from: self, title: NSLocalizedString("error", comment: ""),
                                             message: NSLocalizedString("email_exists", comment: ""))
                    return
                }
                
                let phoneExists = try await clsPerson.isPersonExistsByPhone(phone)
                
                if phoneExists
                {
                    clsAlertHelper.showAlert(from: self, title: NSLocalizedString("error", comment: ""),message: NSLocalizedString("phone_exists", comment: ""))
                    return
                }
                
                let newPerson = Person(personID: nil, name: name, phone: phone, email: email, password: password, isActive: true)
                
                if let person = try await clsPerson.addPerson(newPerson)
                {
                    clsGlobal.person = person
                    
                    let categoriesVC = storyboard?.instantiateViewController(identifier: "HomeVs") as! HomeTabbedViewController
                    categoriesVC.modalPresentationStyle = .fullScreen
                    present(categoriesVC, animated: true)
                    
                }
                else
                {
                    clsAlertHelper.showAlert(from: self,
                                             title: NSLocalizedString("error", comment: ""),
                                             message: NSLocalizedString("signup_error", comment: ""))
                }
                
            }
            catch
            {
                print("Signup error: \(error)")
                clsAlertHelper.showAlert(from: self,  title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("signup_error", comment: ""))
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
}
