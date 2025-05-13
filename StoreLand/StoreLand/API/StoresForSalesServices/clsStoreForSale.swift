import Foundation

public struct StoresForSaleDTO: Codable {
    public var StoreForSaleID: Int?
    public var StoreID: Int?
    public var Price: Decimal?
    public var Status: Int?

    public init(StoreForSaleID: Int?, StoreID: Int?, Price: Decimal?, Status: Int?) {
        self.StoreForSaleID = StoreForSaleID
        self.StoreID = StoreID
        self.Price = Price
        self.Status = Status
    }
}

public struct StoresForSaleDetailsDTO: Codable {
    public var Name: String?
    public var RegionName: String?
    public var CityName: String?
    public var DistrictsName: String?
    public var CommercialNumber: String?
    public var Website: String?
    public var Address: String?
    public var CategoryName: String?
    public var TypeName: String?
    public var Rating: Int?
    public var NumberOfRates: Decimal?
    public var StoreStatus: String?
    public var NumbersOfClick: Decimal?
    public var Photo: String?
    public var PersonName: String?
    public var StoreID: Int?
    public var Email: String?
    public var Phone: String?
    public var Price: Decimal?
    public var StoresForSaleStatus: String?

    public init(Name: String?, RegionName: String?, CityName: String?, DistrictsName: String?, CommercialNumber: String?,
                Website: String?, Address: String?, CategoryName: String?, TypeName: String?, Rating: Int?,
                NumberOfRates: Decimal?, StoreStatus: String?, NumbersOfClick: Decimal?, Photo: String?,
                PersonName: String?, StoreID: Int?, Email: String?, Phone: String?, Price: Decimal?,
                StoresForSaleStatus: String?) {
        self.Name = Name
        self.RegionName = RegionName
        self.CityName = CityName
        self.DistrictsName = DistrictsName
        self.CommercialNumber = CommercialNumber
        self.Website = Website
        self.Address = Address
        self.CategoryName = CategoryName
        self.TypeName = TypeName
        self.Rating = Rating
        self.NumberOfRates = NumberOfRates
        self.StoreStatus = StoreStatus
        self.NumbersOfClick = NumbersOfClick
        self.Photo = Photo
        self.PersonName = PersonName
        self.StoreID = StoreID
        self.Email = Email
        self.Phone = Phone
        self.Price = Price
        self.StoresForSaleStatus = StoresForSaleStatus
    }
}

public class StoresForSaleService {
    private static let baseURL = URL(string: "https://storesland.com/api/api/StoresForSale/")!

    public static func addStoresForSale(_ dto: StoresForSaleDTO) async throws -> StoresForSaleDTO {
        let url = baseURL.appendingPathComponent("AddStoresForSale")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(dto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(StoresForSaleDTO.self, from: data)
    }

    public static func updateStoresForSale(storeForSaleID: Int, dto: StoresForSaleDTO) async throws -> StoresForSaleDTO {
        let url = baseURL.appendingPathComponent("UpdateStoresForSale/\(storeForSaleID)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(dto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(StoresForSaleDTO.self, from: data)
    }

    public static func deleteStoresForSale(storeForSaleID: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("DeleteStoresForSale/\(storeForSaleID)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }

    public static func getStoresForSale(storeID: Int) async throws -> StoresForSaleDTO? {
        let url = baseURL.appendingPathComponent("GetStoresForSale/\(storeID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(StoresForSaleDTO?.self, from: data)
    }

    public static func getAllStoresForSaleAr() async throws -> [StoresForSaleDetailsDTO]? {
        let url = baseURL.appendingPathComponent("GetAllStoresForSaleAr")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([StoresForSaleDetailsDTO].self, from: data)
    }

    public static func getAllStoresForSaleEn() async throws -> [StoresForSaleDetailsDTO]? {
        let url = baseURL.appendingPathComponent("GetAllStoresForSaleEn")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([StoresForSaleDetailsDTO].self, from: data)
    }

    public static func isStoresForSaleExists(storeID: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("Exists/\(storeID)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Bool.self, from: data)
    }
}
