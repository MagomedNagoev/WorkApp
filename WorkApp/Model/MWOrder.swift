import Foundation
import FirebaseFirestore

struct MWOrder:Equatable {
    
    var id: String
    var title: String
    var description: String
    var clientId: String
    var executorId: String
//    var date: Date? = nil
    var price: Int
    var status: String
    var category: String
    
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["title"] = title
        repres["description"] = description
        repres["clientId"] = clientId
        repres["executorId"] = executorId
        repres["price"] = price
        repres["status"] = status
        repres["category"] = category
        return repres
    }
    
    init(id: String,
             title: String,
             description: String,
             clientId: String,
             executorId: String,
             price: Int,
             category: String,
             status: String) {
            
            self.id = id
            self.title = title
            self.description = description
            self.clientId = clientId
            self.executorId = executorId
            self.price = price
            self.status = status
            self.category = category
            
        }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data["id"] as? String else {return nil}
        guard let title = data["title"] as? String else {return nil}
        guard let description = data["description"] as? String else {return nil}
        guard let clientId = data["clientId"] as? String else {return nil}
        guard let price = data["price"] as? Int else {return nil}
        guard let status = data["status"] as? String else {return nil}
        guard let executorId = data["executorId"] as? String else {return nil}
        guard let category = data["category"] as? String else {return nil}
        
        self.id = id
        self.title = title
        self.description = description
        self.clientId = clientId
        self.price = price
        self.status = status
        self.executorId = executorId
        self.category = category
    }
}


