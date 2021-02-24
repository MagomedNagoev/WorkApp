//
//  CategoryCell.swift
//  WorkApp
//
//  Created by Нагоев Магомед on 25.12.2020.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    let titleLabel = UILabel(text: "Категория", font: UIFont(name: "avenir", size: 18)!)
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        Helper.addSubviews(superView: self, subViews: [titleLabel])
        Helper.tamicOff(views: [titleLabel])
        
        NSLayoutConstraint.activate([titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

