import Foundation

public struct RegionDTO : Codable
{
    public var RegionID  : Int
    public var Code  : String
    public var RegionNameAr  : String
    public var RegionNameEn  : String
    
    
    init(RegionID: Int, Code: String, RegionNameAr: String, RegionNameEn: String)
    {
        self.RegionID = RegionID
        self.Code = Code
        self.RegionNameAr = RegionNameAr
        self.RegionNameEn = RegionNameEn
    }
}


       
public class clsRegion
{
    private static let  baseURL = URL(string: "https://storesland.com/api/api/Region/")!
    
    static func GetAllRegions() async throws -> [RegionDTO]
    {
        let url = baseURL.appendingPathComponent("GetAllRegions")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let categories = try JSONDecoder().decode([RegionDTO].self, from: data)
        
        return categories
    }
    
}
