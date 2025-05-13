import Foundation

public struct CityDTO: Codable {
    public var CityID: Int?
    public var CityNameAr: String
    public var CityNameEn: String
    public var RegionID: Int?
    
    init(CityID: Int?, CityNameAr: String, CityNameEn: String, RegionID: Int?) {
        self.CityID = CityID
        self.CityNameAr = CityNameAr
        self.CityNameEn = CityNameEn
        self.RegionID = RegionID
    }
}

public class clsCity {
    private static let baseURL = URL(string: "https://storesland.com/api/api/City/")!
    
    
    
    static func GetAllCities() async throws -> [CityDTO] {
        let url = baseURL.appendingPathComponent("GetAllCities")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let cities = try JSONDecoder().decode([CityDTO].self, from: data)
        
        return cities
    }
}
