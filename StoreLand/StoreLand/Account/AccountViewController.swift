import UIKit


enum enSettings {
    case profile
    case myStores
    case addStore
    case savedStores
    case settings
    case logout
}


struct ProfileItem
{
    let imageName: String
    let title: String
    let esetting : enSettings?
    let description: String
}

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tbvProfile: UITableView!

    var profileData: [ProfileItem] = []

    var logoutTitle: String = ""
    var logoutImageName: String = ""
    var logoutDescription: String = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()
        Load()
    }

    func checkSignIn()
    {
        if clsGlobal.person == nil
        {
            logoutTitle       = NSLocalizedString("login_title",       comment: "Title shown when user is not logged in")
            logoutImageName   = "person.crop.circle.badge.questionmark"
            logoutDescription = NSLocalizedString("login_description", comment: "Description for the login option")
        }
        else
        {
            logoutTitle       = NSLocalizedString("logout_title",       comment: "Title shown when user is logged in")
            logoutImageName   = "arrow.right.circle"
            logoutDescription = NSLocalizedString("logout_description", comment: "Description for the logout option")
        }
    }


    func Load()
    {
        
        checkSignIn()
        
        profileData = [
            ProfileItem(
                imageName: "person.circle",
                title: NSLocalizedString("profile_title", comment: ""),
                esetting: .profile,
                description: NSLocalizedString("profile_description", comment: "")
            ),
            ProfileItem(
                imageName: "storefront",
                title: NSLocalizedString("my_stores_title", comment: ""),
                esetting: .myStores,
                description: NSLocalizedString("my_stores_description", comment: "")
            ),
            ProfileItem(
                imageName: "plus.circle",
                title: NSLocalizedString("add_store_title", comment: ""),
                esetting: .addStore,
                description: NSLocalizedString("add_store_description", comment: "")
            ),
            ProfileItem(
                imageName: "bookmark",
                title: NSLocalizedString("saved_stores_title", comment: ""),
                esetting: .savedStores,
                description: NSLocalizedString("saved_stores_description", comment: "")
            ),
            ProfileItem(
                imageName: "gear",
                title: NSLocalizedString("settings_title", comment: ""),
                esetting: .settings,
                description: NSLocalizedString("settings_description", comment: "")
            ),
            ProfileItem(
                imageName: logoutImageName,
                title: logoutTitle,
                esetting: .logout,
                description: logoutDescription
            )
        ]
        
        tbvProfile.delegate = self
        tbvProfile.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return profileData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? AccountTableViewCell else
        {
            return UITableViewCell()
        }

        let profileItem = profileData[indexPath.row]
        cell.configureCell(image: profileItem.imageName, title: profileItem.title, Desc: profileItem.description)

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedItem = profileData[indexPath.row]

        switch selectedItem.esetting
        {
        case .profile:
            Profile()
            break;
            
        case .logout:
            LogOut()
            break;
            
        case .myStores:
            MyStores()
            break;
            
        case .addStore:
            AddStore()
            break;
            
        case .savedStores:
            SavedStores()
            break;
            
        case .settings:
            print("Navigating to Settings...")
            break;
            
        case .none:
            print("Navigating to Settings...")
            break;
            
        }

    }
    
    
    func SavedStores()
    {
        if clsGlobal.person == nil
        {
            let alert = UIAlertController(
                title: NSLocalizedString("not_signed_in_title", comment: "Alert title when the user is not signed in"), message: NSLocalizedString("not_signed_in_message", comment: "Alert message when the user tries to access a feature while not signed in"),
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "OK button title"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let newStoreVC = storyboard?.instantiateViewController(identifier: "SavedStoreVc") as! SavedStoresViewController
            self.navigationController?.pushViewController(newStoreVC, animated: true)
        }
        
    }

    
    func AddStore()
    {
        if clsGlobal.person == nil
        {
            let alert = UIAlertController(
                title: NSLocalizedString("not_signed_in_title", comment: "Alert title when the user is not signed in"), message: NSLocalizedString("not_signed_in_message", comment: "Alert message when the user tries to access a feature while not signed in"),
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "OK button title"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let newStoreVC = storyboard?.instantiateViewController(identifier: "NewStoreVc") as! NewStoreViewController
            self.navigationController?.pushViewController(newStoreVC, animated: true)
        }
        
      
    }
    

    func Profile()
    {
        if clsGlobal.person == nil
        {
            let alert = UIAlertController(
                title: NSLocalizedString("not_signed_in_title", comment: "Alert title when the user is not signed in"),
                message: NSLocalizedString("not_signed_in_message", comment: "Alert message when the user tries to access a feature while not signed in"),
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "OK button title"), style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            let profileVC = storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        
    }
    
    
    func LogOut()
    {
        clsGlobal.person = nil
        clsGlobal.PersonId = nil
        UserDefaults.standard.removeObject(forKey:  "LoggingInPersonID")

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? UIWindowSceneDelegate,
              let window = sceneDelegate.window ?? nil
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signOptionVC = storyboard.instantiateViewController(withIdentifier: "SignOptionVC")
            
            window.rootViewController = UINavigationController(rootViewController: signOptionVC)
            window.makeKeyAndVisible()
        }
    }
    
    
    func MyStores()
    {
        if clsGlobal.person == nil
        {
            let alert = UIAlertController(
                title: NSLocalizedString("not_signed_in_title", comment: "Alert title when the user is not signed in"), message: NSLocalizedString("not_signed_in_message", comment: "Alert message when the user tries to access a feature while not signed in"),
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "OK button title"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let newStoreVC = storyboard?.instantiateViewController(identifier: "MyStoresVC") as! MyStoresViewController
            self.navigationController?.pushViewController(newStoreVC, animated: true)
        }
        
      
    }
    
}
