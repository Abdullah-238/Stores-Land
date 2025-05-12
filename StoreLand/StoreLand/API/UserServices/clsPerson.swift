import Foundation

public class Person: Codable
{
    var personID: Int?
    var name: String
    var phone: String
    var email: String
    var password: String
    var isActive: Bool

    init(personID: Int?, name: String, phone: String, email: String, password: String, isActive: Bool)
    {
        self.personID = personID
        self.name = name
        self.phone = phone
        self.email = email
        self.password = password
        self.isActive = isActive
    }
    
    init()
    {
        self.personID = nil
        self.name = ""
        self.phone = ""
        self.email = ""
        self.password = ""
        self.isActive = false
    }
}


public class clsPerson
{
    
    private static let  baseURL = URL(string: "https://storesland.com/api/api/Persons/")!
    
    
    static func addPerson(_ person: Person) async throws -> Person?
    {
        let url = baseURL.appendingPathComponent("AddPerson")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(person)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        return try JSONDecoder().decode(Person.self, from: data)
    }
    
    static func updatePerson(personID: Int?, person: Person) async throws -> Person? {
        guard let id = personID else { return nil }
        let url = baseURL.appendingPathComponent("UpdatePerson/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(person)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        return try JSONDecoder().decode(Person.self, from: data)
    }
    
    static func deletePerson(personID: Int?) async throws -> Bool {
        guard let id = personID else { return false }
        let url = baseURL.appendingPathComponent("DeletePerson/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    static func getPerson(personID: Int?) async throws -> Person? {
        guard let id = personID else { return nil }
        let url = baseURL.appendingPathComponent("GetPerson/\(id)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        return try JSONDecoder().decode(Person.self, from: data)
    }
    
    static func isPersonExists(personID: Int?) async throws -> Bool {
        guard let id = personID else { return false }
        let url = baseURL.appendingPathComponent("Exists/\(id)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return false }
        return try JSONDecoder().decode(Bool.self, from: data)
    }
    
    static func isPersonActive(personID: Int?) async throws -> Bool {
        guard let id = personID else { return false }
        let url = baseURL.appendingPathComponent("IsPersonActive/\(id)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return false }
        return try JSONDecoder().decode(Bool.self, from: data)
    }
    
    static func isPersonExistsByEmail(_ email: String) async throws -> Bool {
        let url = baseURL.appendingPathComponent("ExistsByEmail/\(email)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return false }
        return try JSONDecoder().decode(Bool.self, from: data)
    }
    
    static func isPersonActiveByEmail(_ email: String) async throws -> Bool {
        let url = baseURL.appendingPathComponent("IsPersonActiveByEmail/\(email)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return false }
        return try JSONDecoder().decode(Bool.self, from: data)
    }
    
    static func isPersonExistsByPhone(_ phone: String) async throws -> Bool {
        let url = baseURL.appendingPathComponent("ExistsByPhone/\(phone)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return false }
        return try JSONDecoder().decode(Bool.self, from: data)
    }
    
    static func findPersonByEmailAndPassword(email: String, password: String) async throws -> Person? {
        let url = baseURL.appendingPathComponent("FindPersonByEmailAndPassword/\(email)/\(password)")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        return try JSONDecoder().decode(Person.self, from: data)
    }
    
    static func updatePassword(email: String, password: String) async throws -> Bool {
        let url = baseURL.appendingPathComponent("UpdatePass/\(email)/\(password)")
        let (_, response) = try await URLSession.shared.data(from: url)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    
}

    

