import UIKit

class AccountTableViewCell: UITableViewCell
{

    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    func configureCell(image: String, title: String,Desc : String)
    {
        lblTitle.text = title
        
        imgCell.image = UIImage(systemName: image)

        lblDesc.text = Desc
    }
   

}
