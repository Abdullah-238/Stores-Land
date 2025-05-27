import Foundation

public struct TypeDTO: Codable {
    public var typeID: Int?
    public var typeNameAr: String?
    public var typeNameEn: String?

    public init(TypeID: Int?, TypeNameAr: String?, TypeNameEn: String?) {
        self.typeID = TypeID
        self.typeNameAr = TypeNameAr
        self.typeNameEn = TypeNameEn
    }
}

public class clsType {
    private static let baseURL = URL(string: "https://storesland.com/api/api/Types/")!

    public static func GetAllTypes() async throws -> [TypeDTO]? {
        let url = baseURL.appendingPathComponent("GetAllTypes")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([TypeDTO].self, from: data)
    }

    public static func GetTypeNameArByTypeID(TypeID: Int?) async throws -> String? {
        guard let id = TypeID else { return nil }
        let url = baseURL.appendingPathComponent("GetTypeNameArByTypeID/\(id)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(data: data, encoding: .utf8)
    }

    public static func GetTypeNameEnByTypeID(TypeID: Int?) async throws -> String? {
        guard let id = TypeID else { return nil }
        let url = baseURL.appendingPathComponent("GetTypeNameEnByTypeID/\(id)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(data: data, encoding: .utf8)
    }

    public static func GetTypeIDByTypeNameAr(TypeNameAr: String?) async throws -> Int? {
        guard let name = TypeNameAr else { return nil }
        let url = baseURL.appendingPathComponent("GetTypeIDByTypeNameAr/\(name)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Int?.self, from: data)
    }

    public static func GetTypeIDByTypeNameEn(TypeNameEn: String?) async throws -> Int? {
        guard let name = TypeNameEn else { return nil }
        let url = baseURL.appendingPathComponent("GetTypeIDByTypeNameEn/\(name)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Int?.self, from: data)
    }

    public static func FindTypeAr(typeNameAr: String) async throws -> TypeDTO? {
        let url = baseURL.appendingPathComponent("FindTypeAr/\(typeNameAr)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TypeDTO?.self, from: data)
    }

    public static func FindTypeEn(typeNameEn: String) async throws -> TypeDTO? {
        let url = baseURL.appendingPathComponent("FindTypeEn/\(typeNameEn)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TypeDTO?.self, from: data)
    }
}
