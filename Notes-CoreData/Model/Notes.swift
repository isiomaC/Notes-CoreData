//
//  Notes.swift
//  Notes-CoreData
//
//  Created by Anofienam Isioma on 15/04/2019.
//  Copyright © 2019 com.chuck. All rights reserved.
//

import Foundation
import CoreData

class Notes{
    
    var note : [Note]?
    
    static let sharedInstance : Notes = {
        var instance = Notes()
        return instance
    }()
    
}
