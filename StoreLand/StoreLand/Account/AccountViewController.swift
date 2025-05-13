import UIKit


struct ProfileItem
{
    let imageName: String
    let title: String
    let description: String
}

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tbvProfile: UITableView!

    var profileData: [ProfileItem] =
    [
        ProfileItem(imageName: "person.circle",
                    title: NSLocalizedString("profile_title", comment: ""),
                    description: NSLocalizedString("profile_description", comment: "")),
        ProfileItem(imageName: "storefront",
                    title: NSLocalizedString("my_stores_title", comment: ""),
                    description: NSLocalizedString("my_stores_description", comment: "")),
        ProfileItem(imageName: "plus.circle",
                    title: NSLocalizedString("add_store_title", comment: ""),
                    description: NSLocalizedString("add_store_description", comment: "")),
        ProfileItem(imageName: "bookmark",
                    title: NSLocalizedString("saved_stores_title", comment: ""),
                    description: NSLocalizedString("saved_stores_description", comment: "")),
        ProfileItem(imageName: "gear",
                    title: NSLocalizedString("settings_title", comment: ""),
                    description: NSLocalizedString("settings_description", comment: "")),
        ProfileItem(imageName: "arrow.right.circle",
                    title: NSLocalizedString("logout_title", comment: ""),
                    description: NSLocalizedString("logout_description", comment: ""))
    ]


    
    override func viewDidLoad()
    {
        super.viewDidLoad()

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

        switch selectedItem.title
        {
            case NSLocalizedString("profile_title", comment: ""):
            let categoriesVC = storyboard?.instantiateViewController(identifier: "ProfileVS") as! ProfileViewController
            self.navigationController?.pushViewController(categoriesVC, animated: true)

            case NSLocalizedString("logout_title", comment: ""):
            print("Navigating to My Stores...") // Replace with actual navigation or logic

            case NSLocalizedString("my_stores_title", comment: ""):
                // Perform action for My Stores
                print("Navigating to My Stores...") // Replace with actual navigation or logic

            case NSLocalizedString("add_store_title", comment: ""):
            let NewStoreVc = storyboard?.instantiateViewController(identifier: "NewStoreVc") as! NewStoreViewController
            self.navigationController?.pushViewController(NewStoreVc, animated: true)

            case NSLocalizedString("saved_stores_title", comment: ""):
                // Perform action for Saved Stores
                print("Navigating to Saved Stores...") // Replace with actual navigation or logic

            case NSLocalizedString("settings_title", comment: ""):
           
               
            clsGlobal.person = nil
           
            let categoriesVC = storyboard?.instantiateViewController(identifier: "SignInVS") as! SignInViewController
            
            self.navigationController?.popToViewController(categoriesVC, animated: true)

            
            case "":
                // Handle case for empty title
                print("Selected item has an empty title. No action taken.") // Log the empty case or perform any other action

            default:
                // Default case for unrecognized titles
                print("Selected an unknown item.") // Handle unknown cases, if needed
        }
    }

}
