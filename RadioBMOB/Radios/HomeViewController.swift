//
//  HomeViewController.swift
//  Radios
//
//  Created by berk birkan on 20.07.2019.
//  Copyright © 2019 berk birkan. All rights reserved.
//

import UIKit
import SDWebImage
import FRadioPlayer

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,FRadioPlayerDelegate,UISearchBarDelegate {
    
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        print("changed")
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        print("changed")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.stations.removeAll()
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
        
        guard let url = URL(string: "http://www.radio-browser.info/webservice/json/stations/search?tag=" + searchText + "&country=" + country) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                
                for station in jsonArray{
                    let url = station["url"] as! String
                    let name = station["name"] as! String
                    let image = station["favicon"] as! String
                    let tags = station["tags"] as! String
                    
                    let radio = Station()
                    radio.url = url
                    radio.name = name
                    radio.image = image
                    radio.tags = tags
                    
                    self.stations.append(radio)
                    
                    
                }
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getStations()
    }
    
    var stations = [Station]()
    var index = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "station", for: indexPath) as! UITableViewCell
        cell.textLabel!.text = self.stations[indexPath.row].name
        cell.detailTextLabel!.text = self.stations[indexPath.row].tags
        if self.stations[indexPath.row].image == ""{
            cell.imageView?.image = UIImage(named: "radioo")
        }else{
            cell.imageView?.sd_setImage(with: URL(string: self.stations[indexPath.row].image), completed: nil)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        
        
        let player = FRadioPlayer.shared
        player.delegate = self
        player.radioURL = URL(string: self.stations[indexPath.row].url)
        player.play()
        self.performSegue(withIdentifier: "toplay", sender: nil)
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toplay"{
            let secondvc = segue.destination as! PlayerViewController
            secondvc.title = self.stations[index].name
            secondvc.station = self.stations[index]
        }
        
        
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getStations()
        //navbar color
        navigationController?.navigationBar.barTintColor = UIColor.green

        tableview.delegate = self
        tableview.dataSource = self
        
        searchbar.delegate = self
        
    }
    
    func getStations(){
        
        guard let url = URL(string: "http://www.radio-browser.info/webservice/json/stations/bycountry/" + country) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                
                for station in jsonArray{
                    let url = station["url"] as! String
                    let name = station["name"] as! String
                    let image = station["favicon"] as! String
                    let tags = station["tags"] as! String
                    
                    let radio = Station()
                    radio.url = url
                    radio.name = name
                    radio.image = image
                    radio.tags = tags
                    
                    self.stations.append(radio)
                    
                    
                    
                    
                }
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
        
    }
    

   
}
