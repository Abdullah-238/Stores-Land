import Foundation


public class clsUtil
{
    static func  isValidEmail(_ email: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool
    {
           let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !$%&?._-])[A-Za-z\\d !$%&?._-]{8,}$"
           return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
       }
}
