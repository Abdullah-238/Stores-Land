import SQLite
import Foundation

class clsDistrictsSqLite {

    static var db: Connection!
    static let table = Table("districts")

    static let districtsID = Expression<Int>("districtsID")
    static let cityID = Expression<Int>("cityID")
    static let districtsNameAr = Expression<String>("districtsNameAr")
    static let districtsNameEn = Expression<String>("districtsNameEn")

    static func setupDatabase() {
        do {
            let dbPath = DatabaseConfig.dbPath
            db = try Connection(dbPath)
            createTable()
        } catch {
            print("Error setting up SQLite database: \(error)")
        }
    }

    static func createTable() {
        do {
            try db.run(table.create(ifNotExists: true) { t in
                t.column(districtsID, primaryKey: true)
                t.column(cityID)
                t.column(districtsNameAr)
                t.column(districtsNameEn)
            })
        } catch {
            print("Error creating districts table: \(error)")
        }
    }

    static func saveDistricts(_ districts: [DistrictDTO]) {
        setupDatabase()
        do {
            for district in districts {
                let insert = table.insert(or: .replace,
                    districtsID <- (district.districtsID ?? 0),
                    cityID <- (district.cityID ?? 0),
                    districtsNameAr <- (district.districtsNameAr),
                    districtsNameEn <- (district.districtsNameEn)
                )
                try db.run(insert)
            }
        } catch {
            print("Error inserting districts: \(error)")
        }
    }

    static func getAllDistricts() -> [DistrictDTO] {
        setupDatabase()
        var list = [DistrictDTO]()
        do {
            for row in try db.prepare(table) {
                list.append(DistrictDTO(
                    DistrictsID: row[districtsID],
                    CityID: row[cityID],
                    DistrictsNameAr: row[districtsNameAr],
                    DistrictsNameEn: row[districtsNameEn]
                ))
            }
        } catch {
            print("Error fetching districts: \(error)")
        }
        return list
    }

    static func getDistrictsByCityID(_ id: Int) -> [DistrictDTO] {
        var list = [DistrictDTO]()
        do {
            for row in try db.prepare(table.filter(cityID == id)) {
                list.append(DistrictDTO(
                    DistrictsID: row[districtsID],
                    CityID: row[cityID],
                    DistrictsNameAr: row[districtsNameAr],
                    DistrictsNameEn: row[districtsNameEn]
                ))
            }
        } catch {
            print("Error fetching districts by city ID: \(error)")
        }
        return list
    }

    static func isDistrictsTableExists() -> Bool {
        setupDatabase()
        do {
            let count = try db.scalar(table.count)
            return count > 0
        } catch {
            print("Error checking row count in districts table: \(error)")
            return false
        }
    }
}
