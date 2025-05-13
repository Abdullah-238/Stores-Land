import Foundation

public struct OfferDTO: Codable
{
    public var OfferID: Int?
    public var Offer: String
    public var StoreID: Int?
    
    public init(OfferID: Int?, Offer: String, StoreID: Int?)
    {
        self.OfferID = OfferID
        self.Offer = Offer
        self.StoreID = StoreID
    }
}

public class clsOffers {
    private static let baseURL = URL(string: "https://storesland.com/api/api/Offer/")!

    public static func AddOffer(_ offer: OfferDTO) async throws -> OfferDTO {
        let url = baseURL.appendingPathComponent("AddOffer")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(offer)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(OfferDTO.self, from: data)
    }

    public static func UpdateOffer(offerID: Int, offer: OfferDTO) async throws -> Bool {
        let url = baseURL.appendingPathComponent("UpdateOffer/\(offerID)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(offer)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }

    public static func DeleteOffer(offerID: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("DeleteOffer/\(offerID)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }

    public static func GetOffer(offerID: Int) async throws -> OfferDTO {
        let url = baseURL.appendingPathComponent("GetOffer/\(offerID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(OfferDTO.self, from: data)
    }

    public static func GetAllOfferByStoreID(storeID: Int) async throws -> [String] {
        let url = baseURL.appendingPathComponent("GetAllOfferByStoreID/\(storeID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([String].self, from: data)
    }

    public static func GetAllOfferByStore(storeID: Int) async throws -> [OfferDTO] {
        let url = baseURL.appendingPathComponent("GetAllOfferByStore/\(storeID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([OfferDTO].self, from: data)
    }

    public static func IsOfferExists(offerID: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("Exists/\(offerID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Bool.self, from: data)
    }
}
