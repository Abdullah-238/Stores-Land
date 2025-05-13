import Foundation

public struct CouponDTO: Codable {
    public var CouponID: Int?
    public var Coupon: String
    public var StoreID: Int?
    public var ExpiryDate: Date
    public var IsActive: Bool
}


public class clsCoupon {
    private static let baseURL = URL(string: "https://storesland.com/api/api/Coupons/")!
    
    static func AddCoupon(_ coupon: CouponDTO) async throws -> CouponDTO?
    {
        var request = URLRequest(url: baseURL.appendingPathComponent("AddCoupon"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(coupon)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        return try JSONDecoder().decode(CouponDTO.self, from: data)
    }

    static func UpdateCoupon(couponID: Int?, coupon: CouponDTO) async throws -> CouponDTO?
    {
        guard let id = couponID else { return nil }
        var request = URLRequest(url: baseURL.appendingPathComponent("UpdateCoupon/\(id)"))
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(coupon)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        return try JSONDecoder().decode(CouponDTO.self, from: data)
    }

    static func GetCoupon(couponID: Int?) async throws -> CouponDTO?
    {
        guard let id = couponID else { return nil }
        let url = baseURL.appendingPathComponent("GetCoupon/\(id)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        return try JSONDecoder().decode(CouponDTO.self, from: data)
    }

    static func DeleteCoupon(couponID: Int?) async throws -> Bool
    {
        guard let id = couponID else { return false }
        var request = URLRequest(url: baseURL.appendingPathComponent("DeleteCoupon/\(id)"))
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            return false
        }
        return httpResponse.statusCode == 200
    }

    static func GetCouponsByStoreID(storeID: Int?) async throws -> [CouponDTO]?
    {
        guard let id = storeID else { return nil }
        let url = baseURL.appendingPathComponent("GetCouponsByStore/\(id)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        return try JSONDecoder().decode([CouponDTO].self, from: data)
    }

    static func GetAllCouponsByStoreID(storeID: Int?) async throws -> [String]?
    {
        guard let id = storeID else { return nil }
        let url = baseURL.appendingPathComponent("GetCouponCodesByStore/\(id)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        return try JSONDecoder().decode([String].self, from: data)
    }
}
