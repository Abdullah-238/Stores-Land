import UIKit

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var clvCategories: UICollectionView!
    
    var categories: [String] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        clvCategories.dataSource = self
        clvCategories.delegate = self

        
        Task
        {
            await fetchCategories()
        }
        
      
    }

    private func fetchCategories() async
    {
        do
        {
            let fetchedCategories: [String]
            
            if let lang = Locale.current.language.languageCode?.identifier
            {
                switch lang
                {
                case "ar":
                    fetchedCategories = try await clsCategory.GetAllCategoryAvailableByNameAr()
                default:
                    fetchedCategories = try await clsCategory.GetAllCategoryAvailableByNameEn()
                }
            } else
            {
                fetchedCategories = try await clsCategory.GetAllCategoryAvailableByNameEn()
            }
            
            DispatchQueue.main.async
            {
                self.categories = fetchedCategories
                self.clvCategories.reloadData()
            }
            
        }
        catch
        {
            print("Failed to fetch categories:", error.localizedDescription)
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
                
        let category = categories[indexPath.row]
        
        cell.setData(data: category)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let category = categories[indexPath.row]
        
         let detailVC = storyboard?.instantiateViewController(identifier: "StoresVC") as! StoresViewController

        detailVC.categoryName = category
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
