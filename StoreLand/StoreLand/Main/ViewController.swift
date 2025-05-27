//
//  ViewController.swift
//  StoreLand
//
//  Created by Abdullah on 11/11/1446 AH.
//

import UIKit



class ViewController: UIViewController
{
   
    @IBOutlet weak var vwOnline: UIView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }
    
   
    
    
    @IBAction func btnFamilesStores(_ sender: Any)
    {
         let categoriesVC = storyboard?.instantiateViewController(identifier: "categoriesVC") as! CategoryViewController
        
        clsGlobal.typeID = 3
        
        categoriesVC.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(categoriesVC, animated: true)
        
    }
    
    
  
    
    @IBAction func btnOnlineStores(_ sender: Any)
    {
        let categoriesVC = storyboard?.instantiateViewController(identifier: "categoriesVC") as! CategoryViewController
       
       clsGlobal.typeID = 1
       
       categoriesVC.modalPresentationStyle = .fullScreen
       
       self.navigationController?.pushViewController(categoriesVC, animated: true)
       
    }
    

    @IBAction func btnLocalStores(_ sender: Any)
    {
        let categoriesVC = storyboard?.instantiateViewController(identifier: "categoriesVC") as! CategoryViewController
       
       clsGlobal.typeID = 2
       
       categoriesVC.modalPresentationStyle = .fullScreen
       
       self.navigationController?.pushViewController(categoriesVC, animated: true)
       
    }
}

