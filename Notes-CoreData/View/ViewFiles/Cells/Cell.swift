//
//  Cell.swift
//  Notes-CoreData
//
//  Created by Anofienam Isioma on 11/04/2019.
//  Copyright © 2019 com.chuck. All rights reserved.
//

import Foundation
import UIKit

class Cell: UICollectionViewCell{
    
    let containerView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
 
    let title : UILabel = {
        let tit = UILabel()
        tit.clipsToBounds = true
        tit.translatesAutoresizingMaskIntoConstraints = false
        tit.font = UIFont.boldSystemFont(ofSize: 20)
        tit.textColor = .lightGray
        return tit
    }()
    
    let text : UILabel = {
        let tit = UILabel()
        tit.clipsToBounds = true
        tit.translatesAutoresizingMaskIntoConstraints = false
        tit.font = UIFont(name: "HelveticaNeue-Thin", size: 17)
        tit.textColor = .lightGray
        tit.numberOfLines = 2
        return tit
    }()
    
    let date : UILabel = {
        let tit = UILabel()
        tit.clipsToBounds = true
        tit.translatesAutoresizingMaskIntoConstraints = false
        tit.font = UIFont(name: "HelveticaNeue-Thin", size: 12)
        tit.textColor = .lightGray
        return tit
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        contentView.addSubview(containerView)
        containerView.addSubview(title)
        containerView.addSubview(text)
        containerView.addSubview(date)
        addViewConstraints()
        contentViewContraints()
    }
    
    func contentViewContraints(){
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true
        contentView.widthAnchor.constraint(equalTo:safeAreaLayoutGuide.widthAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
    }
    
    func addViewConstraints(){
        
        //Container View Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        //title constraints
        title.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        //text constraints
        text.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        text.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        text.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        text.bottomAnchor.constraint(equalTo: date.topAnchor).isActive = true
        
        //date constriants
        date.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        date.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        date.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
}
