import UIKit
import Foundation

public struct CategoryDTO: Codable
{
    var categoryID: Int?
    var categoryNameAr: String
    var categoryNameEn: String

    init(categoryID: Int?, categoryNameAr: String, categoryNameEn: String)
    {
        self.categoryID = categoryID
        self.categoryNameAr = categoryNameAr
        self.categoryNameEn = categoryNameEn
    }
}

public class clsCategory
{

    
    private static let  baseURL = URL(string: "https://storesland.com/api/api/Category/")!

    private init() {}

    static func getAllCategories() async throws -> [CategoryDTO]
   {
       let url = baseURL.appendingPathComponent("GetAllCategories")

       let (data, _) = try await URLSession.shared.data(from: url)

       let categories = try JSONDecoder().decode([CategoryDTO].self, from: data)
       
       return categories
   }
    
     static func getAllCategoriesAr() async throws -> [CategoryDTO]
    {
        let url = baseURL.appendingPathComponent("GetAllCategoryAvailableByNameAr/\(clsGlobal.typeID)")

        let (data, _) = try await URLSession.shared.data(from: url)

        let categories = try JSONDecoder().decode([CategoryDTO].self, from: data)
        
        return categories
    }
    
    static func getAllCategoriesEn() async throws -> [CategoryDTO]
   {
       let url = baseURL.appendingPathComponent("GetAllCategoryAvailableByNameEn/\(clsGlobal.typeID)")

       let (data, _) = try await URLSession.shared.data(from: url)

       let categories = try JSONDecoder().decode([CategoryDTO].self, from: data)
       
       return categories
   }
    
    static func GetAllCategoryAvailableByNameAr() async throws -> [String]
    {
        let url = baseURL.appendingPathComponent("GetAllCategoryAvailableByNameAr/\(clsGlobal.typeID)")

        let (data, _) = try await URLSession.shared.data(from: url)

        let categoryNames = try JSONDecoder().decode([String].self, from: data)
        
        return categoryNames
    }

    static func GetAllCategoryAvailableByNameEn() async throws -> [String]
    {
        let url = baseURL.appendingPathComponent("GetAllCategoryAvailableByNameEn/\(clsGlobal.typeID)")

        let (data, _) = try await URLSession.shared.data(from: url)

        let categoryNames = try JSONDecoder().decode([String].self, from: data)
        
        return categoryNames
    }
    
    
}
