//
//  StoresViewController.swift
//  StoreLand
//
//  Created by Abdullah on 13/11/1446 AH.
//

import UIKit

class StoresViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate
{
    @IBOutlet weak var clvAllStores: UICollectionView!
    var Stores: [StoreDetailsDTO] = []
    public var categoryName : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        clvAllStores.dataSource = self
        clvAllStores.delegate = self

        Task
        {
            await fetchCategories()
        }

    }
    
    private func fetchCategories() async
    {
        do
        {
            let language = Locale.current.language.languageCode?.identifier
            
            let fetchedStores: [StoreDetailsDTO]

            switch language
            {
            case "ar":
                fetchedStores = try await clsStore.getAllStoresByCategoryNameAr(categoryNameAr: categoryName)
            case "en":
                fetchedStores = try await clsStore.getAllStoresByCategoryNameEn(categoryNameEn: categoryName)
            default:
                fetchedStores = try await clsStore.getAllStoresByCategoryNameEn(categoryNameEn: categoryName)
            }

            DispatchQueue.main.async
            {
                self.Stores = fetchedStores
                self.clvAllStores.reloadData()
            }

        }
        catch
        {
            print("Failed to fetch stores:", error.localizedDescription)
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Stores.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCell", for: indexPath) as? StoresCollectionViewCell else
        {
            fatalError("Unable to dequeue categoryCell")
        }

        let category = Stores[indexPath.row]
        cell.SetCell(name: category.name, location: category.address ?? "", rating: String(category.rating ?? 0), image: category.photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let Store = Stores[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(identifier: "StorydetailVC") as! StorydetailViewController
        detailVC.Store = Store
        
        detailVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }

}


   
