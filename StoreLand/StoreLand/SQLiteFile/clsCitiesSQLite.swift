import SQLite
import Foundation

class clsCitiesSQLite
{
    
    static var db: Connection!
    static let table = Table("cities")

    static let cityID = Expression<Int>("cityID")
    static let regionID = Expression<Int>("regionID")
    static let cityNameAr = Expression<String>("cityNameAr")
    static let cityNameEn = Expression<String>("cityNameEn")

    static func setupDatabase()
    {
        do
        {
            let dbPath = DatabaseConfig.dbPath
            db = try Connection(dbPath)
            createTable()
        }
        catch
        {
            print("Error setting up SQLite database: \(error)")
        }
    }

    static func createTable()
    {
        do {
            try db.run(table.create(ifNotExists: true)
                       { t in
                t.column(cityID, primaryKey: true)
                t.column(regionID)
                t.column(cityNameAr)
                t.column(cityNameEn)
            })
        }
        catch
        {
            print("Error creating cities table: \(error)")
        }
    }

    static func saveCities(_ cities: [CityDTO])
    {
        setupDatabase()
        do {
            for city in cities
            {
                let insert = table.insert(or: .replace,
                    cityID <- (city.cityID ?? 0),
                    regionID <- (city.regionID ?? 0),
                    cityNameAr <- (city.cityNameAr),
                    cityNameEn <- (city.cityNameEn)
                )
                try db.run(insert)
            }
        } catch {
            print("Error inserting cities: \(error)")
        }
    }

    static func saveCitiesAsync(_ cities: [CityDTO], completion: @escaping (Error?) -> Void)
    {
        DispatchQueue.global().async
        {
            do {
                saveCities(cities)
                DispatchQueue.main.async { completion(nil) }
            } catch {
                DispatchQueue.main.async { completion(error) }
            }
        }
    }

    static func getAllCities() -> [CityDTO] {
        
        setupDatabase()
        var list = [CityDTO]()
        do {
            for row in try db.prepare(table) {
                list.append(CityDTO(
                    CityID: row[cityID],
                    CityNameAr: row[cityNameAr],
                    CityNameEn: row[cityNameEn],
                    RegionID: row[regionID]
                ))
            }
        } catch {
            print("Error fetching cities: \(error)")
        }
        return list
    }

    static func getCityById(_ id: Int) -> CityDTO?
    {
        let query = table.filter(cityID == id)
        do {
            if let row = try db.pluck(query) {
                return CityDTO(
                    CityID: row[cityID],
                    CityNameAr: row[cityNameAr],
                    CityNameEn: row[cityNameAr],
                    RegionID: row[regionID],
                )
            }
        } catch {
            print("Error getting city by ID: \(error)")
        }
        return nil
    }

    static func getCitiesByRegionID(_ id: Int) -> [CityDTO]
    {
        var list = [CityDTO]()
        let query = table.filter(regionID == id)
        do {
            for row in try db.prepare(query) {
                list.append(CityDTO(
                    CityID: row[cityID],
                    CityNameAr: row[cityNameAr],
                    CityNameEn: row[cityNameEn],
                    RegionID: row[regionID]
                ))
            }
        } catch {
            print("Error getting cities by regionID: \(error)")
        }
        return list
    }

    static func getCityNameEnByCityID(_ id: Int) -> String?
    {
        do {
            return try db.pluck(table.select(cityNameEn).filter(cityID == id))?[cityNameEn]
        } catch {
            print("Error getting cityNameEn by cityID: \(error)")
            return nil
        }
    }

    static func getCityNameArByCityID(_ id: Int) -> String? {
        do {
            return try db.pluck(table.select(cityNameAr).filter(cityID == id))?[cityNameAr]
        } catch {
            print("Error getting cityNameAr by cityID: \(error)")
            return nil
        }
    }
}
