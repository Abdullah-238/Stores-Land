import UIKit
import Foundation


public struct StoreDTO: Codable {
    var storeID: Int?
    var name: String
    var commercialNumber: String?
    var districtsID: Int?
    var website: String?
    var address: String?
    var categoryID: Int?
    var typeID: Int?
    var rating: UInt8?
    var numberOfRates: Decimal?
    var status: UInt8?
    var numbersOfClick: Decimal?
    var photo: String?
    var peronID: Int?
    var phone: String?
    var cityID: Int?
    var email: String?
}

public struct StoreDetailsDTO: Codable {
    var storeID: Int?
    var name: String
    var regionName: String?
    var cityName: String?
    var districtsName: String?
    var commercialNumber: String?
    var website: String?
    var address: String?
    var categoryName: String?
    var typeName: String?
    var rating: UInt8?
    var numberOfRates: Decimal?
    var storeStatus: String?
    var numbersOfClick: Decimal?
    var photo: String?
    var personName: String?
    var email: String?
    var phone: String?
}

public class clsStore
{
    
    
    private static let  baseURL = URL(string: "https://storesland.com/api/api/Stores/")!
    
    private init() {}
    
    public static func getAllStoresByCategoryNameAr(categoryNameAr : String , pageNumber : Int = 1) async throws -> [StoreDetailsDTO]
    {
        let path = "GetStoresByCategoryNameAr/\(categoryNameAr)/\(clsGlobal.typeID)/\(pageNumber)"
        let url =  baseURL.appendingPathComponent(path)
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let AllStores = try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
        
        return AllStores
    }
    
    public static func getAllStoresByCategoryNameEn(categoryNameEn : String , pageNumber : Int = 1) async throws -> [StoreDetailsDTO]
    {
        let path = "GetStoresByCategoryNameEn/\(categoryNameEn)/\(clsGlobal.typeID)/\(pageNumber)"
        let url =  baseURL.appendingPathComponent(path)
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let AllStores = try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
        
        return AllStores
    }
    
    public static func FindStoreAr( storeID : Int ) async throws -> [StoreDetailsDTO]
    {
        let path = "FindStoreAr/\(storeID)"
        let url =  baseURL.appendingPathComponent(path)
        
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let AllStores = try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
        
        return AllStores
    }
    
    public static func AddStore(_ store: StoreDTO) async throws -> Bool {
        let url = baseURL.appendingPathComponent("AddStore")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(store)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    public static func UpdateStore(_ store: StoreDTO) async throws -> Bool {
        let url = baseURL.appendingPathComponent("UpdateStore")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(store)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    public static func GetStore(storeID: Int) async throws -> StoreDTO? {
        let url = baseURL.appendingPathComponent("GetStore/\(storeID)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        return try JSONDecoder().decode(StoreDTO.self, from: data)
    }
    
   
    
    public static func FindStoreEn(storeID: Int) async throws -> [StoreDetailsDTO] {
        let url = baseURL.appendingPathComponent("FindStoreEn/\(storeID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
    }
    
    public static func DeleteStore(storeID: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("DeleteStore/\(storeID)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    
    
    
      public static func getStore(storeID: Int) async throws -> StoreDTO {
          let url = baseURL.appendingPathComponent("GetStore/\(storeID)")
          let (data, _) = try await URLSession.shared.data(from: url)
          return try JSONDecoder().decode(StoreDTO.self, from: data)
      }

      public static func findStoreAr(storeID: Int?) async throws -> StoreDetailsDTO {
          let url = baseURL.appendingPathComponent("FindStoreAr/\(storeID ?? 0)")
          let (data, _) = try await URLSession.shared.data(from: url)
          return try JSONDecoder().decode(StoreDetailsDTO.self, from: data)
      }

      // Find store (English)
      public static func findStoreEn(storeID: Int?) async throws -> StoreDetailsDTO {
          let url = baseURL.appendingPathComponent("FindStoreEn/\(storeID ?? 0)")
          let (data, _) = try await URLSession.shared.data(from: url)
          return try JSONDecoder().decode(StoreDetailsDTO.self, from: data)
      }

      // Delete store
      public static func deleteStore(storeID: Int) async throws -> Bool {
          let url = baseURL.appendingPathComponent("DeleteStore/\(storeID)")
          var request = URLRequest(url: url)
          request.httpMethod = "DELETE"
          let (_, response) = try await URLSession.shared.data(for: request)
          return (response as? HTTPURLResponse)?.statusCode == 200
      }

      // Get stores by category name (Arabic)
      public static func getStoresByCategoryNameAr(_ categoryNameAr: String, typeID: Int?, pageNumber: Int?) async throws -> [StoreDetailsDTO] {
          let url = baseURL.appendingPathComponent("GetStoresByCategoryNameAr/\(categoryNameAr)/\(typeID ?? 0)/\(pageNumber ?? 1)")
          let (data, _) = try await URLSession.shared.data(from: url)
          return try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
      }

      // Get stores by category name (English)
      public static func getStoresByCategoryNameEn(_ categoryNameEn: String, typeID: Int?, pageNumber: Int?) async throws -> [StoreDetailsDTO] {
          let url = baseURL.appendingPathComponent("GetStoresByCategoryNameEn/\(categoryNameEn)/\(typeID ?? 0)/\(pageNumber ?? 1)")
          let (data, _) = try await URLSession.shared.data(from: url)
          return try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
      }

      // Get all stores by person ID (Arabic)
      public static func getAllStoresInDetailsByPersonIDAr(_ personID: Int?) async throws -> [StoreDetailsDTO] {
          let url = baseURL.appendingPathComponent("GetAllStoresInDetailsByPersonIDAr/\(personID ?? 0)")
          let (data, _) = try await URLSession.shared.data(from: url)
          return try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
      }

      public static func getAllStoresInDetailsByPersonIDEn(_ personID: Int?) async throws -> [StoreDetailsDTO] {
          let url = baseURL.appendingPathComponent("GetAllStoresInDetailsByPersonIDEn/\(personID ?? 0)")
          let (data, _) = try await URLSession.shared.data(from: url)
          return try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
      }

      public static func updateStoreRating(rate: UInt8?, storeID: Int?) async throws -> Bool {
          let url = baseURL.appendingPathComponent("UpdateStoreRating/\(rate ?? 0)/\(storeID ?? 0)")
          var request = URLRequest(url: url)
          request.httpMethod = "PUT"
          let (_, response) = try await URLSession.shared.data(for: request)
          return (response as? HTTPURLResponse)?.statusCode == 200
      }

      public static func updateStoreRatingWithOldRate(rate: UInt8?, oldRate: UInt8?, storeID: Int?) async throws -> Bool {
          let url = baseURL.appendingPathComponent("UpdateStoreRatingWithOldRate/\(rate ?? 0)/\(oldRate ?? 0)/\(storeID ?? 0)")
          var request = URLRequest(url: url)
          request.httpMethod = "PUT"
          let (_, response) = try await URLSession.shared.data(for: request)
          return (response as? HTTPURLResponse)?.statusCode == 200
      }

}



