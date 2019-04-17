//
//  BCell.swift
//  Notes-CoreData
//
//  Created by Anofienam Isioma on 11/04/2019.
//  Copyright © 2019 com.chuck. All rights reserved.
//

import UIKit

class BCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func setValues(title: String, text: String, date: String ){
        self.title.text = title
        self.text.text = text
        self.date.text = date
    }
    
}
