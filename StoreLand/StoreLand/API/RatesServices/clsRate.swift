import Foundation

public struct RateDTO: Codable {
    public var RateID: Int?
    public var StoreID: Int?
    public var Comment: String
    public var Rate: UInt8?
    public var PersonID: Int?

    public init(RateID: Int?, StoreID: Int?, Comment: String, Rate: UInt8?, PersonID: Int?) {
        self.RateID = RateID
        self.StoreID = StoreID
        self.Comment = Comment
        self.Rate = Rate
        self.PersonID = PersonID
    }
}

public class clsRate {
    private static let baseURL = URL(string: "https://storesland.com/api/api/Rates/")!

    public static func AddRate(_ rate: RateDTO) async throws -> RateDTO {
        let url = baseURL.appendingPathComponent("AddRate")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(rate)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(RateDTO.self, from: data)
    }

    public static func UpdateRate(rateID: Int, rate: RateDTO) async throws -> Bool {
        let url = baseURL.appendingPathComponent("UpdateRate/\(rateID)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(rate)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }

    public static func DeleteRate(rateID: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("DeleteRate/\(rateID)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }

    public static func GetRate(rateID: Int) async throws -> RateDTO {
        let url = baseURL.appendingPathComponent("GetRate/\(rateID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(RateDTO.self, from: data)
    }

    public static func GetAllRates() async throws -> [RateDTO] {
        let url = baseURL.appendingPathComponent("GetAllRates")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([RateDTO].self, from: data)
    }

    public static func IsRateExists(rateID: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("Exists/\(rateID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Bool.self, from: data)
    }

    public static func IsRateExistsByStoreAndPerson(storeID: Int, personID: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("ExistsByStoreAndPerson/\(storeID)/\(personID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Bool.self, from: data)
    }

    public static func GetRateByStoreAndPerson(storeID: Int, personID: Int) async throws -> RateDTO {
        let url = baseURL.appendingPathComponent("GetRateByStoreAndPerson/\(storeID)/\(personID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(RateDTO.self, from: data)
    }
}
