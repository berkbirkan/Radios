//
//  Station.swift
//  Radios
//
//  Created by berk birkan on 20.07.2019.
//  Copyright © 2019 berk birkan. All rights reserved.
//

import Foundation
import RealmSwift

class Station: Object {
    @objc dynamic var name = ""
    @objc dynamic var url = ""
    @objc dynamic var image = ""
    @objc dynamic var tags = ""
    
}
