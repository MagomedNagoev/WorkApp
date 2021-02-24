import Foundation
import FirebaseFirestore

struct MWUser: Hashable, Decodable {
    
    var username: String
    var avatarUrl: String
    var id: String
    var email: String
    var description: String
    var gender: String
    var phone: String
    
    init(username: String, id: String, email: String, avatarUrl: String, description: String, gender: String, phone: String) {
        
        self.username = username
        self.id = id
        self.email = email
        self.gender = gender
        self.phone = phone
        self.description = description
        self.avatarUrl = avatarUrl
        
    }
    
    var representation: [String: String] {
        var repres = [String: String]()
        repres["id"] = id
        repres["email"] = email
        repres["gender"] = gender
        repres["phone"] = phone
        repres["description"] = description
        repres["avatarUrl"] = avatarUrl
        repres["username"] = username
        
        return repres
    }
    
    init?(doc: DocumentSnapshot)  {
        
        guard let data = doc.data() else { return nil }
        
        guard let id = data["id"] as? String else { return nil }
        guard let username = data["username"] as? String else { return nil }
        guard let email = data["email"] as? String else { return nil }
        guard let gender = data["gender"] as? String else { return nil }
        guard let phone = data["phone"] as? String else { return nil }
        guard let description = data["description"] as? String else { return nil }
        guard let avatarUrl = data["avatarUrl"] as? String else { return nil }
        
        self.username = username
        self.id = id
        self.email = email
        self.gender = gender
        self.phone = phone
        self.description = description
        self.avatarUrl = avatarUrl
        
    }
    
}

