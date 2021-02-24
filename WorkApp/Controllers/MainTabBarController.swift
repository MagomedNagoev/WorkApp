//
//  MainTabBarController.swift
//  WorkApp
//
//  Created by Нагоев Магомед on 23.11.2020.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let currentUser: MWUser
    
    init(currentUser: MWUser){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainVC = MainViewController(mwUser: currentUser)
        let myOrdersVC = MyOrdersViewController(currentUser: currentUser)
        let myWorkVC = MyWorksViewController(currentUser: currentUser)
        let usersVC = UsersViewController()

        navigationController?.navigationBar.isHidden = true
        
        viewControllers = [
            generateTabBarItem(rootVC: mainVC, title: "Главный", image: UIImage(systemName: "circles.hexagonpath")!),
            generateTabBarItem(rootVC: myOrdersVC, title: "Мои заказы", image: UIImage(systemName: "scroll")!),
            generateTabBarItem(rootVC: myWorkVC, title: "В работе", image: UIImage(systemName: "hammer")!),
            generateTabBarItem(rootVC: usersVC, title: "Специалисты", image: UIImage(systemName: "person.2")!)
        ]

        view.backgroundColor = .white
    }
    
    private func generateTabBarItem(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        let vc = UINavigationController(rootViewController: rootVC)
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        
        return vc
    }

    

}
