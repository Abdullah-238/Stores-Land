import Foundation

public struct DistrictDTO: Codable {
    var districtsID: Int?
       var cityID: Int?
       var districtsNameAr: String
       var districtsNameEn: String

    
    init(DistrictsID: Int?, CityID: Int?, DistrictsNameAr: String, DistrictsNameEn: String) {
        self.districtsID = DistrictsID
        self.cityID = CityID
        self.districtsNameAr = DistrictsNameAr
        self.districtsNameEn = DistrictsNameEn
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
