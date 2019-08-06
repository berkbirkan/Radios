//
//  FavoriteViewController.swift
//  Radios
//
//  Created by berk birkan on 20.07.2019.
//  Copyright © 2019 berk birkan. All rights reserved.
//

import UIKit
import SDWebImage
import FRadioPlayer

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,FRadioPlayerDelegate {
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        print("changed")
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        print("changed")
    }
    
    
    
    
    var index = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.sharedInstance.getDataFromDB().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "favorite", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = DBManager.sharedInstance.getDataFromDB()[indexPath.row].name
        cell.detailTextLabel!.text = DBManager.sharedInstance.getDataFromDB()[indexPath.row].tags
        cell.imageView?.sd_setImage(with: URL(string: DBManager.sharedInstance.getDataFromDB()[indexPath.row].url), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        
        
        let player = FRadioPlayer.shared
        player.delegate = self
        player.radioURL = URL(string: DBManager.sharedInstance.getDataFromDB()[indexPath.row].url)
        player.play()
        self.performSegue(withIdentifier: "toplay", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toplay"{
            let secondvc = segue.destination as! PlayerViewController
            secondvc.title = DBManager.sharedInstance.getDataFromDB()[index].name
            let radio = Station()
            radio.name = DBManager.sharedInstance.getDataFromDB()[index].name
            radio.image = DBManager.sharedInstance.getDataFromDB()[index].image
            radio.tags = DBManager.sharedInstance.getDataFromDB()[index].tags
            radio.url = DBManager.sharedInstance.getDataFromDB()[index].url
            
            secondvc.station = radio
        }
        
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        getFavorite()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getFavorite()
        //navbar color
        navigationController?.navigationBar.barTintColor = UIColor.green
        
        tableview.delegate = self
        tableview.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func getFavorite(){
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    
    

   

}
