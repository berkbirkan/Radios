//
//  DBManager.swift
//  Radios
//
//  Created by berk birkan on 21.07.2019.
//  Copyright © 2019 berk birkan. All rights reserved.
//

import UIKit
import RealmSwift
class DBManager {
    private var   database:Realm
    static let   sharedInstance = DBManager()
    private init() {
        database = try! Realm()
    }
    func getDataFromDB() ->   Results<Favorite> {
        let results: Results<Favorite> =   database.objects(Favorite.self)
        return results
    }
    func addData(object: Favorite)   {
        try! database.write {
            database.add(object, update: true)
            print("Added new object")
        }
    }
    func deleteAllFromDatabase()  {
        try!   database.write {
            database.deleteAll()
        }
    }
    func deleteFromDb(object: Favorite)   {
        try!   database.write {
            database.delete(object)
        }
    }
}
