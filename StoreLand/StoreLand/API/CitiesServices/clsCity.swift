import Foundation



public struct CityDTO: Codable
{
    var cityID: Int?
    var cityNameAr: String
    var cityNameEn: String
    var regionID: Int?
    
    init(CityID: Int?, CityNameAr: String, CityNameEn: String, RegionID: Int?) {
        self.cityID = CityID
        self.cityNameAr = CityNameAr
        self.cityNameEn = CityNameEn
        self.regionID = RegionID
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

