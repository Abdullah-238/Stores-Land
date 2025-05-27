import UIKit

class NewStoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    
    var IsUpdate : Bool = false
    var store : StoreDTO? = nil
    
    
    @IBOutlet weak var txtCommericalNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var lblWebsite: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var pkDistrict: UIPickerView!
    @IBOutlet weak var pkCites: UIPickerView!
    @IBOutlet weak var pkRegion: UIPickerView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    var imageLocalPath: URL?
    var imagePublicURL: String?
    
    @IBOutlet weak var pkCategories: UIPickerView!
    @IBOutlet weak var pkTypes: UIPickerView!
    
    var selectedRegionID: Int? = clsGlobal.Regions[0].regionID
    var selectedCityID: Int?  = clsGlobal.Cities[0].cityID

    
    var selectedTypeID: Int?
    var selectedCategoryID: Int?
    var selecteddistrictsID : Int?
 
    
    var isEnglish: Bool
    {
        return Locale.current.language.languageCode?.identifier == "en"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _assignPickers()
        _load()
    }
    
    func _assignPickers()
    {
        let pickers: [UIPickerView] =  [pkRegion, pkCites, pkDistrict, pkTypes, pkCategories]
        
        for item in pickers
        {
            item.delegate = self
            item.dataSource = self
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func _load()
    {
        if IsUpdate && store != nil
        {
            lblWebsite.text = store?.website
            
            txtName.text = store?.name
            txtEmail.text = store?.email
            txtPhone.text = store?.phone
            txtAddress.text = store?.address
            txtCommericalNumber.text = store?.commercialNumber
            clsUtil.loadImage(into: imgPhoto, from: store?.photo)
            
            selectedCityID = store?.cityID
            selectedTypeID = store?.typeID
            selectedCategoryID = store?.categoryID
            selectedRegionID = clsCitiesSQLite.getCityById(selectedCityID!)?.regionID
            selecteddistrictsID = store?.districtsID
            
            
            pkTypes.selectRow(selectedTypeID! - 1, inComponent: 0, animated: false)
            pkCategories.selectRow(selectedTypeID! - 1, inComponent: 0, animated: false)

        }
        
        
        if !clsGlobal.Regions.isEmpty
        {
            clsGlobal.Cities = clsCitiesSQLite.getCitiesByRegionID(selectedRegionID!)
        }
        else
        {
            clsGlobal.Cities = []
        }
        
        if !clsGlobal.Cities.isEmpty
        {
            clsGlobal.Districts = clsDistrictsSqLite.getDistrictsByCityID(selectedCityID!)
        }
        else
        {
            clsGlobal.Districts = []
        }
    
        pkRegion.reloadAllComponents()
        pkCites.reloadAllComponents()
        pkDistrict.reloadAllComponents()
        pkCategories.reloadAllComponents()
        pkTypes.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch pickerView
        {
        case pkRegion:
            return clsGlobal.Regions.count
        case pkCites:
            return clsGlobal.Cities.count
        case pkDistrict:
            return clsGlobal.Districts.count
        case pkCategories:
            return clsGlobal.Categories.count
        case pkTypes:
            return clsGlobal.Types.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch pickerView
        {
        case pkRegion:
            return isEnglish ? clsGlobal.Regions[row].regionNameEn : clsGlobal.Regions[row].regionNameAr
        case pkCites:
            return isEnglish ? clsGlobal.Cities[row].cityNameEn : clsGlobal.Cities[row].cityNameAr
        case pkDistrict:
            return isEnglish ? clsGlobal.Districts[row].districtsNameEn : clsGlobal.Districts[row].districtsNameAr
        case pkCategories:
            return isEnglish ? clsGlobal.Categories[row].categoryNameEn : clsGlobal.Categories[row].categoryNameAr
        case pkTypes:
            return isEnglish ? clsGlobal.Types[row].typeNameEn : clsGlobal.Types[row].typeNameAr
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch pickerView
        {
        case pkRegion:
            let region = clsGlobal.Regions[row]
            selectedRegionID = region.regionID
            clsGlobal.Cities = clsCitiesSQLite.getCitiesByRegionID(selectedRegionID!)
            pkCites.reloadAllComponents()
            
            if !clsGlobal.Cities.isEmpty
            {
                selectedCityID = clsGlobal.Cities[0].cityID
                pkCites.selectRow(0, inComponent: 0, animated: true)
                clsGlobal.Districts = clsDistrictsSqLite.getDistrictsByCityID(selectedCityID!)
            }
            else
            {
                selectedCityID = nil
                clsGlobal.Districts = []
            }
            pkDistrict.reloadAllComponents()
            
        case pkCites:
            let city = clsGlobal.Cities[row]
            selectedCityID = city.cityID
            clsGlobal.Districts = clsDistrictsSqLite.getDistrictsByCityID(selectedCityID!)
            pkDistrict.reloadAllComponents()
            
        default:
            break
        }
    }
    
    
    @IBAction func btnAddNewStorre(_ sender: Any)
    {
        Task
        {
            guard let name = txtName.text, !name.isEmpty,
                  let email = txtEmail.text, !email.isEmpty,
                  let phone = txtPhone.text, !phone.isEmpty,
                  let address = txtAddress.text, !address.isEmpty,
                  let commercialNumber = txtCommericalNumber.text, !commercialNumber.isEmpty
            else
            {
                let alert = UIAlertController(
                    title: NSLocalizedString("missing_fields_title", comment: "Alert title for missing fields"),
                    message: NSLocalizedString("missing_fields_message", comment: "Alert message for missing fields"),
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(
                    title: NSLocalizedString("ok", comment: "OK button title"),
                    style: .default
                ))
                
                present(alert, animated: true)
                return
            }
            
            let regionIndex = pkRegion.selectedRow
            let cityIndex = pkCites.selectedRow(inComponent: 0)
            let districtIndex = pkDistrict.selectedRow(inComponent: 0)
            let categoryIndex = pkCategories.selectedRow(inComponent: 0)
            let typeIndex = pkTypes.selectedRow(inComponent: 0)
            
            let cityID = clsGlobal.Cities[cityIndex].cityID
            
            let districtsID: Int? = (districtIndex >= 0 && districtIndex < clsGlobal.Districts.count)
            ? clsGlobal.Districts[districtIndex].districtsID
            : nil
            let categoryID = clsGlobal.Categories[categoryIndex].categoryID
            let typeID = clsGlobal.Types[typeIndex].typeID
            
            
            
           
                    if let localPath = imageLocalPath
            {
                        try await uploadImageToFTP(fileURL: localPath)
                    }
            
            
            let store = StoreDTO(
                storeID: nil,
                name: name,
                commercialNumber: commercialNumber,
                districtsID: districtsID,
                website: lblWebsite.text,
                address: address,
                categoryID: categoryID,
                typeID: typeID,
                rating: 0,
                numberOfRates: 0,
                status: 1,
                numbersOfClick: 0,
                photo: imagePublicURL,
                peronID: clsGlobal.person?.personID,
                phone: phone,
                cityID: cityID,
                email: email
            )
            
            do
            {
                let isAddedd: Bool = try await clsStore.AddStore(store)
                
                if isAddedd {
                    let alert = UIAlertController(
                        title: NSLocalizedString("success_title", comment: "Success alert title"),
                        message: NSLocalizedString("store_created_message", comment: "Success message when store is created"),
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(
                        title: NSLocalizedString("ok", comment: "OK button title"),
                        style: .default
                    ))
                    present(alert, animated: true)
                }
                
            }
            catch
            {
                print("Error adding store: \(error)")
                
                let alert = UIAlertController(
                    title: NSLocalizedString("error_title", comment: "Error alert title"),
                    message: NSLocalizedString("store_creation_failed", comment: "Error message when store creation fails"),
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: NSLocalizedString("ok", comment: "OK button title"),
                    style: .default
                ))
                present(alert, animated: true)
            }
            
        }
    }
    
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func btnUploadImage(_ sender: Any)
    {
        let alert = UIAlertController(
            title: NSLocalizedString("upload_image_title", comment: "Upload Image title"),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("camera", comment: "Camera option"),
            style: .default,
            handler: { _ in self.getPhoto(type: .camera) }
        ))
        
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("photo_library", comment: "Photo Library option"),
            style: .default,
            handler: { _ in self.getPhoto(type: .photoLibrary) }
        ))
        
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("cancel", comment: "Cancel button"),
            style: .cancel
        ))
        
        present(alert, animated: true)
    }
    
    
    func getPhoto(type: UIImagePickerController.SourceType)
    {
        guard UIImagePickerController.isSourceTypeAvailable(type) else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(  _ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        var selectedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage
        {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage
        {
            selectedImage = originalImage
        }
        
        if let image = selectedImage
        {
            imgPhoto.image = image
            Task
            {
                await self.handlePickedImage(image)
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    
    func handlePickedImage(_ image: UIImage) async
    {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do
        {
            try data.write(to: fileURL)
            self.imageLocalPath = fileURL
            try await self.uploadImageToFTP(fileURL: fileURL)
            
            self.imagePublicURL = "https://storesland.com/Images/\(fileName)"
            print("Public image URL: \(self.imagePublicURL!)")
          
            
        } catch {
            print("Error handling image: \(error)")
        }
    }
    
    
    func uploadImageToFTP(fileURL: URL) async throws
    {
        let ftpServer = "ftp://win6057.site4now.net"
        let remoteFolder = "storesplace/Images"
        let ftpUsername = "abdullah0-001"
        let ftpPassword = "Qq-12341234"
        
        let fileName = fileURL.lastPathComponent
        guard let ftpUrl = URL(string: "\(ftpServer)/\(remoteFolder)/\(fileName)")
        else
        {
            throw NSError(domain: "Invalid FTP URL", code: 0)
        }
        
        var request = URLRequest(url: ftpUrl)
        request.httpMethod = "PUT"
        
        let credentials = "\(ftpUsername):\(ftpPassword)"
        guard let loginData = credentials.data(using: .utf8)
        else
        {
            throw NSError(domain: "Encoding error", code: 0)
        }
        let base64Login = loginData.base64EncodedString()
        request.setValue("Basic \(base64Login)", forHTTPHeaderField: "Authorization")
        
        let fileData = try Data(contentsOf: fileURL)
        let (_, response) = try await URLSession.shared.upload(for: request, from: fileData)
        
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode)
        else
        {
            throw NSError(domain: "FTP upload failed", code: 0)
        }
        
        print("FTP upload succeeded with status code: \(httpResponse.statusCode)")
    }
    
    
   // func deleteFileFromFTP(fileName: String)
   // {
   //     let ftpServer = "ftp://win6057.site4now.net"
   //     let remoteFolder = "storesplace/Images"
   //     let ftpUsername = "abdullah0-001"
   //     let ftpPassword = "Qq-12341234"
   //
   //     guard let ftpUrl = URL(string: "\(ftpServer)/\(remoteFolder)/\(fileName)")
   //     else
   //     {
   //         print("Invalid FTP URL")
   //         return
   //     }
   //
   //     var request = URLRequest(url: ftpUrl)
   //     request.httpMethod = "DELETE"
   //
   //     let login = "\(ftpUsername):\(ftpPassword)"
   //     guard let loginData = login.data(using: .utf8) else { return }
   //     let base64Login = loginData.base64EncodedString()
   //     request.setValue("Basic \(base64Login)", forHTTPHeaderField: "Authorization")
   //
   //     URLSession.shared.dataTask(with: request) { _, response, error in
   //         if let error = error
   //         {
   //             print("FTP Delete failed: \(error)")
   //         } else if let httpResponse = response as? HTTPURLResponse
   //         {
   //             print("FTP delete finished with status code: \(httpResponse.statusCode)")
   //         }
   //     }.resume()
   // }
}
