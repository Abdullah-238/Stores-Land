//
//  SceneDelegate.swift
//  StoreLand
//
//  Created by Abdullah on 11/11/1446 AH.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    internal func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
       
      Task
        {
            clsGlobal.Categories  =  try await clsCategory.getAllCategories()
            
            clsGlobal.Types  =  try await clsType.GetAllTypes() ?? []
            
            print(clsGlobal.Types)
            print(clsGlobal.Categories)

        }

        
        if clsRegionsSQLite.isRegionsTableExists()
        {
            clsGlobal.Regions = clsRegionsSQLite.getAllRegions()
            clsGlobal.Districts = clsDistrictsSqLite.getAllDistricts()
            clsGlobal.Cities = clsCitiesSQLite.getAllCities()
            
        }
        else
        {
            Task
            {
                do
                {
                    let fetchedRegions = try await clsRegion.GetAllRegions()
                    clsGlobal.Regions = fetchedRegions
                    clsRegionsSQLite.saveRegions(fetchedRegions)
                    
                    let fetchedCities = try await clsCity.GetAllCities()
                    clsGlobal.Cities = fetchedCities
                    clsCitiesSQLite.saveCities(fetchedCities)
                    
                    let fetchedDistricts = try await clsDistrict.GetAllDistricts() ?? []
                    clsGlobal.Districts = fetchedDistricts
                    clsDistrictsSqLite.saveDistricts(fetchedDistricts)
                    
                }
                catch
                {
                    print("Error fetching Regions: \(error)")
                }
            }
            
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

