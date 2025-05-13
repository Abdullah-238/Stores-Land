import Foundation

public struct DistrictDTO: Codable {
    public var DistrictsID: Int?
    public var CityID: Int?
    public var DistrictsNameAr: String
    public var DistrictsNameEn: String
    
    init(DistrictsID: Int?, CityID: Int?, DistrictsNameAr: String, DistrictsNameEn: String) {
        self.DistrictsID = DistrictsID
        self.CityID = CityID
        self.DistrictsNameAr = DistrictsNameAr
        self.DistrictsNameEn = DistrictsNameEn
    }
}

public class clsDistrict
{
    private static let baseURL = URL(string: "https://storesland.com/api/api/District/")!
    
    
    static func GetAllDistricts() async throws -> [DistrictDTO]? {
        let url = baseURL.appendingPathComponent("GetAllDistricts")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        
        return try JSONDecoder().decode([DistrictDTO].self, from: data)
    }
}
