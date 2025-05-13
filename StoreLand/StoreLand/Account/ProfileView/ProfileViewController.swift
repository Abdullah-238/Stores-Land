import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let person = clsGlobal.person
        {
            txtName.text = person.name
            txtEmail.text = person.email
            txtPhone.text = person.phone
            txtPassword.text = person.password
        }
        
        txtPassword.delegate = self
        txtEmail.delegate = self
        txtPhone.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxPasswordLength = 20, maxEmailLength = 50, maxPhoneLength = 9
        
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        if textField == txtPassword {
            return newText.count <= maxPasswordLength
        } else if textField == txtEmail {
            return newText.count <= maxEmailLength
        } else if textField == txtPhone {
            return newText.count <= maxPhoneLength
        }
        return true
    }
    
    @IBAction func btnUpdateProfile(_ sender: Any) {
        guard let name = txtName.text, !name.isEmpty,
              let email = txtEmail.text, !email.isEmpty,
              let phone = txtPhone.text, !phone.isEmpty,
              let password = txtPassword.text, !password.isEmpty else {
            clsAlertHelper.showAlert(from: self, title: "Error", message: "Please fill in all fields.")
            return
        }
        
        guard clsUtil.isValidEmail(email) else {
            clsAlertHelper.showAlert(from: self, title: "Error", message: "Invalid email format.")
            return
        }
        
        guard phone.count == 9 else {
            clsAlertHelper.showAlert(from: self, title: "Error", message: "Phone number must be 9 digits.")
            return
        }
        
        guard clsUtil.isValidPassword(password) else {
            clsAlertHelper.showAlert(from: self, title: "Error", message: "Password is too weak.")
            return
        }
        
        guard let currentPerson = clsGlobal.person else { return }
        
        let updatedPerson = Person(
            personID: currentPerson.personID,
            name: name,
            phone: phone,
            email: email,
            password: password,
            isActive: true
        )
        
        Task
        {
            do {
                if let result = try await clsPerson.updatePerson(personID: currentPerson.personID, person: updatedPerson) {
                    clsGlobal.person = result
                    clsAlertHelper.showAlert(from: self, title: "Success", message: "Profile updated successfully.")
                } else {
                    clsAlertHelper.showAlert(from: self, title: "Error", message: "Failed to update profile.")
                }
            } catch {
                print("Update error: \(error)")
                clsAlertHelper.showAlert(from: self, title: "Error", message: "An error occurred while updating.")
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
        view.endEditing(true)
    }
}
