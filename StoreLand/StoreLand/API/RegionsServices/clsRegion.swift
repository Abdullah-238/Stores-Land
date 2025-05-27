import Foundation

public struct RegionDTO: Codable {
    var regionID: Int?
    var code: String
    var regionNameAr: String
    var regionNameEn: String

    init(regionID: Int?, code: String, regionNameAr: String, regionNameEn: String) {
        self.regionID = regionID
        self.code = code
        self.regionNameAr = regionNameAr
        self.regionNameEn = regionNameEn
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
