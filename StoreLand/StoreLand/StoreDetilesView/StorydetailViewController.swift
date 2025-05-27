import UIKit

class StorydetailViewController: UIViewController {
    
    var Store: StoreDetailsDTO!

    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var imgStore: UIImageView!

    @IBOutlet weak var btnSave: UIButton!
    
    var IsSaved : Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
           
        
        FindStore()
        
        Task
        {
            await Load()
        }
    }
    
    
    func Load() async
    {
        do
        {
            IsSaved = try await clsSavedStore.IsSavedStoreExistsByStoreAndPerson(storeID: Store.storeID, personID: clsGlobal.person?.personID)
        }
       catch
        {
           
       }
        
        if IsSaved
        {
            btnSave.setTitle("Remove from saved", for: .normal)
        }
        else
        {
            btnSave.setTitle("Save to saved", for: .normal)
        }
    }

    func FindStore()
    {
        lblStoreName.text = Store.name
        lblRating.text = Store.rating != nil ? "\(Store.rating!)" : "N/A"
        lblLocation.text = Store.address ?? "No address available"
        
        if let imageUrlString = Store.photo, let url = URL(string: imageUrlString)
        {
            loadImage(from: url)
        } else {
            imgStore.image = UIImage(systemName: "photo")
        }
    }

    private func loadImage(from url: URL)
    {
        DispatchQueue.global().async
        {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imgStore.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.imgStore.image = UIImage(systemName: "photo")
                }
            }
        }
    }
    
   
    @IBAction func btnSaveStore(_ sender: Any)
    {
        let savedstore = SavedStoreDTO(StoreSavedId: nil, StoreID: Store?.storeID, PersonID: clsGlobal.person?.personID)

        if !IsSaved
        {
            Task
            {
                do
                {
                   if  try await clsSavedStore.AddSavedStore(savedstore) != nil
                    {
                       btnSave.setTitle("Save to saved", for: .normal)
                       
                   }
                }
                catch
                {
                    print("Error: \(error)")
                }
            }
        }
        else
        {
            
            Task
            {
                do
                {
                    try await clsSavedStore.DeleteSavedStoreByStoreID(storeSavedId: Store.storeID!, personID: clsGlobal.person?.personID)
                    btnSave.setTitle("Save to saved", for: .normal)
                }
                catch
                {
                    print("Error: \(error)")
                }
            }
            
            
           
        }
        
        
       

    }
    
    @IBAction func btnRateStore(_ sender: Any)
    {
        let categoriesVC = storyboard?.instantiateViewController(identifier: "RatesVC") as! RateViewController

        categoriesVC.storeId = Store.storeID
        present(categoriesVC, animated: true)

      
    }
}
