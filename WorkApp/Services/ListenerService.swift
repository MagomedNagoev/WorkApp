
import Foundation
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()
    var notify = NotificationService()
    
    private let db = Firestore.firestore()
    private var ordersRef: CollectionReference {
        return db.collection("orders")
    }
    
    func ordersObderve(orders: [MWOrder], completion: @escaping (Result<[MWOrder], Error>) -> Void) -> ListenerRegistration? {
        var orders = orders
        let ordersListener = ordersRef.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (change) in
                guard let order = MWOrder (doc: change.document) else {
                    return
                }
                switch change.type {
                
                case .added:
                    guard !orders.contains(order) else {
                        print("проверка не пройдена")
                        return
                    }
                    orders.insert(order, at: 0)
                    self.notify.sheduleNotification(orderTitle: order.title)
                    
                case .modified:
                    let order1 = orders.filter({$0.id == order.id})[0]
                    
                    guard  let index = orders.firstIndex(of: order1) else {
                        print("проверка не пройдена")
                        return
                    }
                    orders[index] = order
                case .removed:
                    guard  let index = orders.firstIndex(of: order) else {
                        return
                    }
                    orders.remove(at: index)
                }
                
            }
            completion(.success(orders))
        }
        return ordersListener
    }
    
}
