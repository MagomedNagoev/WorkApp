
import UIKit

class UsersViewController: UIViewController {
    
    var users = [MWUser]()
    var avatars = [UIImage?]()
    
    enum Section: Int, CaseIterable {
        case users
    }
    var usersLabel = UILabel(text: "Специалисты", font: .avenir(size: 18)!)
    var menuBar = UIView()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MWUser>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        createDataSource()
        navigationController?.navigationBar.isHidden = true
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsers ()
        for _ in users {
            avatars.append(nil)
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MWUser>()
        snapshot.appendSections([.users])
        snapshot.appendItems(users, toSection: .users)
        
        dataSource.apply(snapshot)
    }
    
    private func setupCollectionView() {
        menuBar.backgroundColor = .buttonBlue()
        usersLabel.textColor = .white
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .white
        collectionView.register(UsersCell.self, forCellWithReuseIdentifier: UsersCell.reuseId)
        
        Helper.addSubviews(superView: view, subViews: [menuBar,usersLabel, collectionView])
        Helper.tamicOff(views: [menuBar, usersLabel,collectionView])
       
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([menuBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
                                     menuBar.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
                                     menuBar.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
                                     menuBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
                                        usersLabel.centerXAnchor.constraint(equalTo: menuBar.centerXAnchor),
                                        usersLabel.centerYAnchor.constraint(equalTo: menuBar.centerYAnchor) ])
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: 10),
                                     collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
    }
    
    private func downloadAvatars() {
        
        for user in users {
            StorageService.shared.download(url: user.id) { (result) in
                switch result {
                
                case .success(let data):
                    let image = UIImage(data: data)
                    self.avatars.append(image)
                case .failure(let error):
                    self.avatars.append(nil)
                    print(error.localizedDescription)
                }
            }
        }
        
        
    }
    
    func getUsers () {
        FirestoreService.shared.getUsers { (result) in
            switch result {
            case .success(let users):
                self.users = [MWUser]()
                for user in users {
                    if user.id != AuthService.shared.auth.currentUser?.uid {
                        self.users.append(user)
                    print(user.username)
                    }

                    }

                self.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension UsersViewController {
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MWUser> (collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersCell.reuseId, for: indexPath) as! UsersCell
            
            StorageService.shared.download(url: self.users[indexPath.item].id) { (result) in
                switch result {
                
                case .success(let data):
                    cell.avatar.image = UIImage(data: data)
                case .failure(let error):
                    cell.avatar.image = UIImage(named: "avatars")
                    print(error.localizedDescription)
                }
            }
            

            cell.nameLabel.text = self.users[indexPath.item].username
            
            return cell
        })
    }
}


extension UsersViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("FatalError: Секция с таким названием не найдена")
            }
            
            switch section {
            
            case .users:
                return self.createSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        config.scrollDirection = .vertical
        layout.configuration = config
        
        return layout
        
    }
    
    
    func createSection() -> NSCollectionLayoutSection {
        
        //item
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(15)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16,
                                                             leading: 8,
                                                             bottom: 8,
                                                             trailing: 8)
        section.interGroupSpacing = 15
        //        let sectionHeader =
        //        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}

extension UsersViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = SpecViewController(currentUser: users[indexPath.item], isEdit: false)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }

}
