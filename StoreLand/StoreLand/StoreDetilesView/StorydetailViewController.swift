import UIKit

class StorydetailViewController: UIViewController {
    
    var storeID: Int!
    var Store: StoreDetailsDTO!

    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var imgStore: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Store Details"
        
        FindStore()
    }

    func FindStore() {

        lblStoreName.text = Store.name
        lblRating.text = Store.rating != nil ? "\(Store.rating!)" : "N/A"
        lblLocation.text = Store.address ?? "No address available"
        
        if let imageUrlString = Store.photo, let url = URL(string: imageUrlString) {
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
}
