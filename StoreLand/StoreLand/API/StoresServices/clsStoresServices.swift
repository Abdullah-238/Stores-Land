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

public class clsStores
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
    
    
}
