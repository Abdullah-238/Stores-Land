import SQLite
import Foundation

class clsRegionsSQLite {
    
    static var db: Connection!
    static let table = Table("regions")
    
    static let regionID = Expression<Int>("regionID")
    static let code = Expression<String>("code")
    static let regionNameAr = Expression<String>("regionNameAr")
    static let regionNameEn = Expression<String>("regionNameEn")
    
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
            try db.run(table.create(ifNotExists: true) { t in
                t.column(regionID, primaryKey: true)
                t.column(code)
                t.column(regionNameAr)
                t.column(regionNameEn)
            })
        }
        catch
        {
            print("Error creating regions table: \(error)")
        }
    }
    
    static func saveRegions(_ regions: [RegionDTO])
    {
        setupDatabase()

        do
        {
            for region in regions
            {
                let insert = table.insert(or: .replace,
                    regionID <- (region.regionID ?? 0),
                    code <- (region.code),
                    regionNameAr <- (region.regionNameAr),
                    regionNameEn <- (region.regionNameEn)
                )
                try db.run(insert)
            }
        }
        catch
        {
            print("Error inserting regions: \(error)")
        }
    }

    static func saveRegionsAsync(_ regions: [RegionDTO], completion: @escaping (Error?) -> Void)
    {
        setupDatabase()

        DispatchQueue.global().async
        {
            do
            {
                saveRegions(regions)
                DispatchQueue.main.async { completion(nil) }
            }
            catch
            {
                DispatchQueue.main.async { completion(error) }
            }
        }
    }
    
    static func getAllRegions() -> [RegionDTO]
    {
        var list = [RegionDTO]()
        do {
            for row in try db.prepare(table)
            {
                list.append(RegionDTO(
                    regionID: row[regionID],
                    code: row[code],
                    regionNameAr: row[regionNameAr],
                    regionNameEn: row[regionNameEn]
                ))
            }
        }
        catch
        {
            print("Error fetching regions: \(error)")
        }
        return list
    }
    
    static func getAllRegionsByNameAr() -> [String]
    {
        do
        {
            return try db.prepare(table.select(regionNameAr)).map { $0[regionNameAr] }
        }
        catch
        {
            print("Error fetching Arabic region names: \(error)")
            return []
        }
    }

    static func getAllRegionsByNameEn() -> [String]
    {
        do
        {
            return try db.prepare(table.select(regionNameEn)).map { $0[regionNameEn] }
        }
        catch
        {
            print("Error fetching English region names: \(error)")
            return []
        }
    }
    
    static func getRegionById(_ id: Int) -> RegionDTO?
    {
        let query = table.filter(regionID == id)
        do
        {
            if let row = try db.pluck(query)
            {
                return RegionDTO(
                    regionID: row[regionID],
                    code: row[code],
                    regionNameAr: row[regionNameAr],
                    regionNameEn: row[regionNameEn]
                )
            }
        }
        catch
        {
            print("Error getting region by ID: \(error)")
        }
        return nil
    }

    static func getRegionsByCode(_ searchCode: String) -> [RegionDTO]
    {
        var list = [RegionDTO]()
        let query = table.filter(code == searchCode)
        do
        {
            for row in try db.prepare(query)
            {
                list.append(RegionDTO(
                    regionID: row[regionID],
                    code: row[code],
                    regionNameAr: row[regionNameAr],
                    regionNameEn: row[regionNameEn]
                ))
            }
        }
        catch
        {
            print("Error getting regions by code: \(error)")
        }
        return list
    }
    
    static func getRegionNameEnByRegionID(_ id: Int) -> String?
    {
        do
        {
            return try db.pluck(table.select(regionNameEn).filter(regionID == id))?[regionNameEn]
        }
        catch
        {
            print("Error getting regionNameEn by regionID: \(error)")
            return nil
        }
    }
    
    static func getRegionNameArByRegionID(_ id: Int) -> String?
    {
        do
        {
            return try db.pluck(table.select(regionNameAr).filter(regionID == id))?[regionNameAr]
        }
        catch
        {
            print("Error getting regionNameAr by regionID: \(error)")
            return nil
        }
    }
    
    static func isRegionsTableExists() -> Bool
    {
        setupDatabase()
        do
        {
            let count = try db.scalar(table.count)
            return count > 0
        }
        catch
        {
            print("Error checking row count in regions table: \(error)")
            return false
        }
    }
}
