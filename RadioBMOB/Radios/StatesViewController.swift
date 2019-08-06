//
//  StatesViewController.swift
//  Radios
//
//  Created by berk birkan on 20.07.2019.
//  Copyright © 2019 berk birkan. All rights reserved.
//

import UIKit

class StatesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var names = [String]()
    var counts = [String]()
    var index = 0
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "states", for: indexPath) as! UITableViewCell
        
        cell.textLabel!.text = self.names[indexPath.row]
        cell.detailTextLabel!.text = self.counts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "bystate", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "bystate"{
            let secondvc = segue.destination as! ByStateViewController
            secondvc.state = self.names[index]
            secondvc.title = self.names[index]
        }
        
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getStates()
        
        //navbar color
        navigationController?.navigationBar.barTintColor = UIColor.green
        
        self.title = "States"
        
        tableview.delegate = self
        tableview.dataSource = self


        
    }
    
    func getStates(){
        
        guard let url = URL(string: "http://www.radio-browser.info/webservice/json/states?country=" + country) else {return}
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
                
                for state in jsonArray{
                    let name = state["name"] as! String
                    let count = state["stationcount"] as! String
                    
                    self.names.append(name)
                    self.counts.append(count)
                    
                    
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
