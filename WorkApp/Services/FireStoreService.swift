import FirebaseAuth
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService() //Синглтон
    
    private let db = Firestore.firestore() //Ссылка на базу данных
    
    //Ссылка на коллекцию пользователей
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    //Ссылка на коллекцию zakazov
    private var ordersRef: CollectionReference {
        return db.collection("orders")
    }
    

    func saveProfile(id: String,
                     phone: String,
                     userName: String,
                     description: String,
                     avatarImg: UIImage?,
                     gender: String,
                     email: String,
                     completion: @escaping (Result<MWUser, Error>) -> Void) {
        
        var mwUser = MWUser(username: userName,
                            id: id,
                            email: email,
                            avatarUrl: "",
                            description: description,
                            gender: gender,
                            phone: phone)
        
        if let image = avatarImg {
                    StorageService.shared.upload(image: image) { (result) in
                        
                        switch result {
                        case .success(let url):
                            mwUser.avatarUrl = url.absoluteString
                            self.usersRef.document(mwUser.id).setData(mwUser.representation) { (error) in
                                if let error = error {
                                    completion(.failure(error))
                                } else {
                                    completion(.success(mwUser))
                                }
                            }
         
                        case .failure(let error):
                            print(error.localizedDescription)
                            print("не удалось загрузить картинку")
                        }
                    }
                } else {
                    self.usersRef.document(mwUser.id).setData(mwUser.representation) { (error) in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(mwUser))
                        }
                    }
                }
        

        
        self.usersRef.document(mwUser.id).setData(mwUser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(mwUser))
            }
        }
    }
    //MARK: Get User Data
    func getUserData(user: User,
                     completion: @escaping (Result<MWUser, Error>) -> Void) {
        
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { (docSnap, error) in
            
            if let docSnap = docSnap, docSnap.exists {
                guard let mwuser = MWUser(doc: docSnap) else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(mwuser))
                
            }
            else {
                completion(.failure(error!))
            }
        }
    }
    
    //Mark: Save Order
    
    func saveOrder (id: String,
        title: String,
        description: String,
        clientId: String,
        executorId: String?,
//      date: Date? = nil,
        price: Int,
        category: String,
        status: String,
        completion: @escaping (Result<MWOrder, Error>) -> Void) {
        
        let order = MWOrder(id: id, title: title, description: description, clientId: clientId, executorId: executorId ?? "", price: price, category: category, status: status)
        
        self.ordersRef.document(order.id).setData(order.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(order))
            }
        }
        
    }
    

    
    //MARK: Get Orders
    
    func getOrders(completion: @escaping (Result<[MWOrder], Error>) -> Void) {
        
        let reference = ordersRef
        
        var orders = [MWOrder]()
        
        reference.getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            for doc in snapshot!.documents {
                guard let order = MWOrder(doc: doc) else {return}
                orders.append(order)
            }
            
            completion(.success(orders))
            
        }
        
    }
    
    func getUsers(completion: @escaping (Result<[MWUser], Error>) -> Void) {
        
        let reference = usersRef
        
        var users = [MWUser]()
        
        reference.getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            for doc in snapshot!.documents {
                guard let user = MWUser(doc: doc) else {return}
                users.append(user)
            }
            
            completion(.success(users))
            
        }
        
    }
    
    func getUserForId(userId: String, completion: @escaping (Result<MWUser, Error>) -> Void) {
        
        let docRef = usersRef.document(userId)
        docRef.getDocument { (docSnap, error) in
            
            if let docSnap = docSnap, docSnap.exists {
                guard let mwuser = MWUser(doc: docSnap) else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(mwuser))
                
            }
            else {
                completion(.failure(error!))
            }
        }
        
    }
    
    
    func removeOrder(orderId: String,completion: @escaping (Result<String, Error>) -> Void) {

        let docRef = ordersRef.document(orderId)
        docRef.delete { (error) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        
        completion(.success(orderId))
    }
    
}

