
import UIKit

class SignInViewController: UIViewController {

    let nameLabel = UILabel(text: "WorkApp", font: UIFont.boldSystemFont(ofSize: 30))
    
    let emailTF = UITextField(backgroundColor: .white,
                              cornerRadius: 5,
                              placeholder: "Email")
    
    let passwdTF = UITextField(backgroundColor: .white,
                               cornerRadius: 5,
                               placeholder: "Пароль")
    
    let signInButton = UIButton(title: "Войти",
                                backgroundColor: .buttonBlue(),
                                cornerRadius: 5,
                                tintColor:.buttonWhite())
    
    let regButton = UIButton(title: "Ещё не с нами?",
                             backgroundColor: .clear,
                             cornerRadius: 5,
                             tintColor: .buttonBlue())
    
    var stackView: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundBlue()
        interfaceConfig()
        addTargets()
    }

    

}

//MARK: InterfaceConfig

extension SignInViewController {
    
    func interfaceConfig() {
        passwdTF.isSecureTextEntry = true
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        Helper.tamicOff(views: [nameLabel,
                                emailTF,
                                passwdTF,
                                signInButton,
                                regButton,
                                stackView])
        

        Helper.addSubviews(superView: view, subViews: [nameLabel,emailTF, passwdTF, signInButton, regButton])
        NSLayoutConstraint.activate([nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     nameLabel.topAnchor.constraint(equalTo: emailTF.topAnchor, constant: -100)])

        NSLayoutConstraint.activate([emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     emailTF.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     emailTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                                     emailTF.heightAnchor.constraint(equalToConstant: 40)])
      
        NSLayoutConstraint.activate([passwdTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 20),
                                     passwdTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     passwdTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                                     passwdTF.heightAnchor.constraint(equalToConstant: 40)])

        NSLayoutConstraint.activate([signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     signInButton.topAnchor.constraint(equalTo: passwdTF.bottomAnchor, constant: 20),
                                     signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                                     signInButton.heightAnchor.constraint(equalToConstant: 40)])

        NSLayoutConstraint.activate([regButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     regButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
                                     regButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                                     regButton.heightAnchor.constraint(equalToConstant: 40)])

        
    }

}

//MARK: AddTargets
extension SignInViewController {
    
    func addTargets() {
        
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        regButton.addTarget(self, action: #selector(regTapped), for: .touchUpInside)
        
    }
    
    @objc func signInTapped() {
        
        AuthService.shared.login(email: emailTF.text!,
                                 password: passwdTF.text!) { (result) in
            switch result {
            
            case .success(let user):
                
                let mwUser = MWUser(username: "",
                                    id: user.uid,
                                    email: user.email!,
                                    avatarUrl: "String",
                                    description: "String",
                                    gender: "String",
                                    phone: "String")
                let vc = MainTabBarController(currentUser: mwUser)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            case .failure(let error):
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                self.showAlert(title: "Ошибочка!", message: error.localizedDescription, buttons: [okAction])
            }
        }
        
//        print("Авторизация прошла успешно!")

    }
    
    @objc func regTapped() {
        self.present(SignUpViewController(), animated: true, completion: nil)
    }
    
}
