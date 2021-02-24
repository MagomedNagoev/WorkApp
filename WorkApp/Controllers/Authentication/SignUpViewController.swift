//
//  SignUpViewController.swift
//  WorkApp
//
//  Created by Нагоев Магомед on 03.11.2020.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let regLabel = UILabel(text: "Регистрация", font: UIFont.boldSystemFont(ofSize: 30))
    
    let emailTF = UITextField(backgroundColor: .white,
                              cornerRadius: 5,
                              placeholder: "Email")
    
    let passwdTF = UITextField(backgroundColor: .white,
                               cornerRadius: 5,
                               placeholder: "Пароль")
    
    let confirmTF = UITextField(backgroundColor: .white,
                               cornerRadius: 5,
                               placeholder: "Подтвердите пароль")
    
    let regButton = UIButton(title: "Регистрация",
                             backgroundColor: .buttonBlue(),
                             cornerRadius: 5,
                             tintColor: .buttonWhite())

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        interfaceConfig()
        addTargets()
    }

}


//MARK: InterfaceConfig

extension SignUpViewController {
    
    func interfaceConfig() {
        passwdTF.isSecureTextEntry = true
        confirmTF.isSecureTextEntry = true
        regLabel.textAlignment = .center
        regLabel.textColor = .white
        Helper.tamicOff(views: [regLabel,
                                emailTF,
                                passwdTF,
                                regButton,
                                confirmTF])
        

        Helper.addSubviews(superView: view, subViews: [regLabel,emailTF, passwdTF, regButton, confirmTF])
        
        NSLayoutConstraint.activate([regLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     regLabel.topAnchor.constraint(equalTo: emailTF.topAnchor, constant: -100)])
        
        NSLayoutConstraint.activate([emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     emailTF.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     emailTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                                     emailTF.heightAnchor.constraint(equalToConstant: 40)])
      
        NSLayoutConstraint.activate([passwdTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 20),
                                     passwdTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     passwdTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                                     passwdTF.heightAnchor.constraint(equalToConstant: 40)])

        NSLayoutConstraint.activate([confirmTF.topAnchor.constraint(equalTo: passwdTF.bottomAnchor, constant: 20),
                                     confirmTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     confirmTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                                     confirmTF.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([regButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     regButton.topAnchor.constraint(equalTo: confirmTF.bottomAnchor, constant: 20),
                                     regButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                                     regButton.heightAnchor.constraint(equalToConstant: 40)])



        
    }

}

//MARK: AddTargets
extension SignUpViewController {
    
    func addTargets() {
        regButton.addTarget(self, action: #selector(regTapped), for: .touchUpInside)
        
    }

    @objc func regTapped() {
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        guard passwdTF.text == confirmTF.text else {
            self.showAlert(title: "Ошибка!", message: "Пароли не совпадают", buttons: [okAction])
            return
        }
        
        AuthService.shared.register(email: emailTF.text!,
                                    password: passwdTF.text!) { (result) in
            switch result {
            
            case .success(let user):
                
                FirestoreService.shared.saveProfile(id: user.uid, phone: "", userName: "", description: "", avatarImg: nil, gender: "", email: user.email!) { (result) in
                    
                    switch result {
                    
                    case .success(_):
                        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        self.showAlert(title: "Успех!", message: "Вы зарегистрированы!", buttons: [alertAction])
                        print("Регистрация пройдена!")
                    case .failure(let error):
                        self.showAlert(title: "Ошибка", message: error.localizedDescription, buttons: [okAction])
                    }
                }
                
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: error.localizedDescription, buttons: [okAction])
            }
        }
        
        
        
    }
    
}
