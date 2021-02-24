import Foundation
import FirebaseAuth

class AuthService {
    
    static var shared = AuthService()
    
    let auth = Auth.auth()
    
    func register(email: String?,
                  password: String?,
                  completion: @escaping (Result<User, Error>) -> Void) {
        
        auth.createUser(withEmail: email!,
                        password: password!) { (result, error) in
            
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
            
        }

    }
    
    func login(email: String?,
               password: String?,
               completion: @escaping (Result<User, Error>) -> Void) {
        
        auth.signIn(withEmail: email!,
                    password: password!) {(result, error) in
                        guard let result = result else {
                            completion(.failure(error!))
                            return
                        }
            
            completion(.success(result.user))
        }
    }
}
