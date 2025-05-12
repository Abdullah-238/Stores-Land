

import UIKit

class StoresCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgStore: UIImageView!
    
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    private func setupAppearance()
    {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }
    public func SetCell(name: String, location: String, rating: String, image: String?)
    {
        
        setupAppearance()
        
        lblName.text = name
        lblLocation.text = location
        lblStar.text = rating

        if let image = image, let url = URL(string: image) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let loadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imgStore.image = loadedImage
                    }
                } else {
                    DispatchQueue.main.async {
                        self.imgStore.image = UIImage(systemName: "photo")
                    }
                }
            }
        } else {
            imgStore.image = UIImage(systemName: "photo")
        }
    }


}
