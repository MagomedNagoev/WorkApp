import FirebaseAuth
import FirebaseStorage

class StorageService {
    
    static let shared = StorageService()
    
    let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    private var userId = Auth.auth().currentUser!.uid
    
    func upload(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarsRef.child(userId).putData(imageData, metadata: metadata) {(metadata, error) in
            
            guard let _ = metadata else { completion(.failure(error!))
                return
            }
            
            self.avatarsRef.child(self.userId).downloadURL { (url, error) in
                guard let downloadUrl = url else { completion(.failure(error!))
                    return
                }
                completion(.success(downloadUrl))
            }
        }
    }
    
    func download(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let fileRef = storageRef.child("avatars/\(url)")
        
        fileRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
            
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(data))
        }
    }
    

}

