
import UIKit

class SpecViewController: UIViewController {
    
    var currentUser: MWUser
    var isEdit: Bool

    var nameTextField = UITextField(backgroundColor: .buttonWhite(),
    cornerRadius: 4,
    placeholder: "Ваше имя")
    var avatarImageView = AvatarView()
    var descriptionTextView = UITextView()
    var genderSegmentControl = UISegmentedControl()
    var phoneTextField = UITextField(backgroundColor: .buttonWhite(),
                                    cornerRadius: 4,
                                    placeholder: "Номер телефона")
    
    
    
    
    var saveButton = UIButton(title: "Сохранить",
                              backgroundColor: .buttonBlue(),
                              cornerRadius: 4,
                              tintColor: .buttonWhite())
    
    var closeButton = UIButton(title: "Закрыть",
                               backgroundColor: .buttonRed(),
                               cornerRadius: 4,
                               tintColor: .white)
    
    var editButton = UIButton(title: "",
                              backgroundColor: .buttonBlue(),
                              cornerRadius: 16,
                              tintColor: .white)
    
    init(currentUser: MWUser, isEdit: Bool) {
        self.currentUser = currentUser
        self.isEdit = isEdit
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceConfig()
        addTargets()


    }
    
    
}

//MARK: AddConstraints

extension SpecViewController {
    
    func interfaceConfig() {
        
        
        StorageService.shared.download(url: currentUser.id) { (result) in
            switch result {
            
            case .success(let data):
                self.avatarImageView.image.image = UIImage(data: data)
            case .failure(let error):
                self.avatarImageView.image.image = UIImage(named: "avatars")
                print(error.localizedDescription)
            }
        }
        
        
        view.backgroundColor = .white
        
        nameTextField.isUserInteractionEnabled = false
        phoneTextField.isUserInteractionEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
        genderSegmentControl.isUserInteractionEnabled = false
        avatarImageView.isUserInteractionEnabled = false
        saveButton.isHidden = true
        
        nameTextField.standardTF()
        phoneTextField.standardTF()
        descriptionTextView.standardTF()
        nameTextField.text = currentUser.username
        phoneTextField.text = currentUser.phone
        descriptionTextView.text = currentUser.description
        
        genderSegmentControl.insertSegment(withTitle: "М", at: 0, animated: false)
        genderSegmentControl.insertSegment(withTitle: "Ж", at: 1, animated: false)
        
        switch currentUser.gender {
        case "М":
            genderSegmentControl.selectedSegmentIndex = 0
        case "Ж":
            genderSegmentControl.selectedSegmentIndex = 1
        default:
            genderSegmentControl.selectedSegmentIndex = 0
        }
        
        Helper.tamicOff(views: [nameTextField,
                                avatarImageView,
                                descriptionTextView,
                                genderSegmentControl,
                                phoneTextField,
                                saveButton,
                                closeButton,
                                editButton])
        
        Helper.addSubviews(superView: view, subViews: [nameTextField,
                                                       avatarImageView,
                                                       descriptionTextView,
                                                       genderSegmentControl,
                                                       phoneTextField,
                                                       saveButton,
                                                       closeButton,
                                                       editButton])
        
        
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        
        avatarImageView.backgroundColor = .white
        
//        nameTextField.isEnabled = false
//        nameTextField.backgroundColor = .clear
//        descriptionTextView.isEditable = false
        
//        nameTextField.backgroundColor = .buttonWhite()
//        phoneTextField.backgroundColor = .buttonWhite()
//        descriptionTextView.backgroundColor = .buttonWhite()
        

        
        NSLayoutConstraint.activate([avatarImageView.topAnchor.constraint(equalTo: view.topAnchor),
                                     avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     avatarImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     avatarImageView.heightAnchor.constraint(equalToConstant: 200)])
        
        NSLayoutConstraint.activate([nameTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
                                     nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                     nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                                     nameTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
                                     phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                     phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                                     phoneTextField.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([genderSegmentControl.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 15),
                                     genderSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                     genderSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     genderSegmentControl.heightAnchor.constraint(equalToConstant: 40)])
        
        
        NSLayoutConstraint.activate([closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
                                     closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                     closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                                     closeButton.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([editButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                                     editButton.widthAnchor.constraint(equalToConstant: 50),
                                     editButton.heightAnchor.constraint(equalToConstant: 50),
                                     editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
        
        NSLayoutConstraint.activate([descriptionTextView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -15),
                                     descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                     descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                                     descriptionTextView.topAnchor.constraint(equalTo: genderSegmentControl.bottomAnchor, constant: 15)])
        NSLayoutConstraint.activate([saveButton.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -15),
                                     saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                                     saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                                     saveButton.heightAnchor.constraint(equalToConstant: 40)])
        if isEdit {
            editButton.isHidden = false

            

            
            closeButton.setTitle("Закрыть", for: .normal)
            
            
        } else {
            
            editButton.isHidden = true
            saveButton.isHidden = true
            closeButton.setTitle("Закрыть", for: .normal)
        }
    }
}

extension SpecViewController {
    
    func addTargets() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        if isEdit {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
            avatarImageView.addGestureRecognizer(gesture)
            
            saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
            editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        }
        
    }
    @objc func editTapped() {

        nameTextField.isUserInteractionEnabled = !nameTextField.isUserInteractionEnabled
        phoneTextField.isUserInteractionEnabled = !phoneTextField.isUserInteractionEnabled
        descriptionTextView.isUserInteractionEnabled = !descriptionTextView.isUserInteractionEnabled
        genderSegmentControl.isUserInteractionEnabled = !genderSegmentControl.isUserInteractionEnabled
        avatarImageView.isUserInteractionEnabled = !avatarImageView.isUserInteractionEnabled
        if nameTextField.isUserInteractionEnabled {
            nameTextField.backgroundColor = .buttonWhite()
            phoneTextField.backgroundColor = .buttonWhite()
            descriptionTextView.backgroundColor = .buttonWhite()
            saveButton.isHidden = false
            closeButton.setTitle("Отмена", for: .normal)
        } else {
            nameTextField.standardTF()
            phoneTextField.standardTF()
            descriptionTextView.standardTF()
            saveButton.isHidden = true
            closeButton.setTitle("Закрыть", for: .normal)
        }
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func saveTapped() {
        
        var gender: String = ""
        switch genderSegmentControl.selectedSegmentIndex {
        case 0:
            gender = "М"
        case 1:
            gender = "Ж"
        default:
            gender = "unknown"
        }
        
        print(self.currentUser.id)
        print(currentUser.email)
        print(phoneTextField.text!)
        print(descriptionTextView.text!)
        print(gender)
        print(nameTextField.text!)
        
        FirestoreService.shared.saveProfile(id: self.currentUser.id,
                                            phone: phoneTextField.text!,
                                            userName: nameTextField.text!,
                                            description: descriptionTextView.text!,
                                            avatarImg: avatarImageView.image.image!,
                                            gender: gender,
                                            email: currentUser.email) { (result) in
            
            print(self.currentUser.representation)
            
            
            
            
            switch result {
            
            case .success(let user):
                
                let alert = UIAlertController(title: "Поздравляю Вас, \(user.username)!", message: "Можете откликаться на задания", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                

                
            case .failure(let error):
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.showAlert(title: "Ошибочка", message: error.localizedDescription, buttons: [okAction])
            }
        }
    }
    
    @objc func avatarTapped() {
        print("AvatarViewTapped")
        
        let actionSheet = UIAlertController(title: "Откуда взять фотографию?", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "С камеры", style: .default) { (action) in
            print("Camera")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.cameraDevice = .front
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let galleryAction = UIAlertAction(title: "Из галереи", style: .default) { (action) in
            print("Gallery")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive) { (action) in
            print("Cancel")
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension SpecViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageFromPicker = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        avatarImageView.image.image = imageFromPicker
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
