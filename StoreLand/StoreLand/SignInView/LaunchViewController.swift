import UIKit

class LaunchViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Task
        {
           await Load()
        }
    }
    

    func Load() async
    {
        let personID = UserDefaults.standard.integer(forKey: "LoggingInPersonID")

        if personID != 0
        {
            do
            {
                let person : Person  = try await clsPerson.getPerson(personID: personID)!
                
                clsGlobal.person =  person
                
                let categoriesVC = storyboard?.instantiateViewController(identifier: "HomeVs") as! HomeTabbedViewController
                categoriesVC.modalPresentationStyle = .fullScreen
                
                present(categoriesVC, animated: false)
            }
            catch
            {
                print("Failed to load person: \(error)")
            }
        }
        else
        {
            let categoriesVC = storyboard?.instantiateViewController(identifier: "SignOptionVC") as! Pre_SignViewController
            categoriesVC.modalPresentationStyle = .fullScreen
            
            present(categoriesVC, animated: false)
        }
        
    }

}
