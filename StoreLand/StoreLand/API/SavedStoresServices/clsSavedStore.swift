import Foundation

public struct SavedStoreDTO: Codable
{
    public var StoreSavedId: Int?
    public var StoreID: Int?
    public var PersonID: Int?

    public init(StoreSavedId: Int?, StoreID: Int?, PersonID: Int?) {
        self.StoreSavedId = StoreSavedId
        self.StoreID = StoreID
        self.PersonID = PersonID
    }
}


public class clsSavedStore {
    
    private static let baseURL = URL(string: "https://storesland.com/api/api/SavedStores/")!

    public static func AddSavedStore(_ dto: SavedStoreDTO) async throws -> SavedStoreDTO
    {
        let url = baseURL.appendingPathComponent("AddSavedStore")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(dto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(SavedStoreDTO.self, from: data)
    }

    public static func UpdateSavedStore(storeSavedId: Int, dto: SavedStoreDTO) async throws -> Bool {
        let url = baseURL.appendingPathComponent("UpdateSavedStore/\(storeSavedId)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(dto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }

    public static func DeleteSavedStore(storeSavedId: Int?) async throws -> Bool {
        guard let id = storeSavedId else { return false }
        let url = baseURL.appendingPathComponent("DeleteSavedStore/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }

    public static func DeleteSavedStoreByStoreID(storeSavedId: Int, personID: Int?) async throws -> Bool {
        guard let pid = personID else { return false }
        let url = baseURL.appendingPathComponent("DeleteSavedStoreByStoreID/\(storeSavedId)/\(pid)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }

    public static func GetSavedStore(storeSavedId: Int?) async throws -> SavedStoreDTO? {
        guard let id = storeSavedId else { return nil }
        let url = baseURL.appendingPathComponent("GetSavedStore/\(id)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(SavedStoreDTO?.self, from: data)
    }

    public static func GetAllSavedStores() async throws -> [SavedStoreDTO]? {
        let url = baseURL.appendingPathComponent("GetAllSavedStores")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([SavedStoreDTO].self, from: data)
    }

    public static func GetSavedStoreByPersonIDAr(personID: Int?, pageNumber: Int?) async throws -> [StoreDetailsDTO]? {
        guard let pid = personID, let page = pageNumber else { return nil }
        let url = baseURL.appendingPathComponent("GetSavedStoreByPersonIDAr/\(pid)/\(page)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
    }

    public static func GetSavedStoreByPersonIDEn(personID: Int?, pageNumber: Int?) async throws -> [StoreDetailsDTO]? {
        guard let pid = personID, let page = pageNumber else { return nil }
        let url = baseURL.appendingPathComponent("GetSavedStoreByPersonIDEn/\(pid)/\(page)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([StoreDetailsDTO].self, from: data)
    }

    public static func IsSavedStoreExists(storeSavedId: Int?) async throws -> Bool {
        guard let id = storeSavedId else { return false }
        let url = baseURL.appendingPathComponent("Exists/\(id)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Bool.self, from: data)
    }

    public static func IsSavedStoreExistsByStoreAndPerson(storeID: Int?, personID: Int?) async throws -> Bool {
        guard let sid = storeID, let pid = personID else { return false }
        let url = baseURL.appendingPathComponent("ExistsByStoreAndPerson/\(sid)/\(pid)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Bool.self, from: data)
    }
}
