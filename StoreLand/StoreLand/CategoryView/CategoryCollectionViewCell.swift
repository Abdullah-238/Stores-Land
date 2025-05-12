import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    

    private func setupAppearance()
    {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }
    
    public func setData(_ data: String)
    {
        setupAppearance()
        
        lblTitle.text = data
    }
}
