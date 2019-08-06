//
//  PlayerViewController.swift
//  Radios
//
//  Created by berk birkan on 20.07.2019.
//  Copyright © 2019 berk birkan. All rights reserved.
//

import UIKit
import SDWebImage
import FRadioPlayer

class PlayerViewController: UIViewController,FRadioPlayerDelegate{
    
    let player = FRadioPlayer.shared
    
    
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        print("changed")
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        print("changed")
    }
    
    
    
    var station = Station()
    
    
    @IBOutlet weak var radioimage: UIImageView!
    
    
    
    @IBOutlet weak var radioname: UILabel!
    
    
    @IBOutlet weak var radiotags: UILabel!
    
    @IBOutlet weak var play: UIButton!
    
    @IBOutlet weak var fav: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.delegate = self
        
        if player.isPlaying{
            play.imageView?.image = UIImage(named: "play")
        }else{
            play.imageView?.image = UIImage(named: "pause")
        }
        
        
        
        radioname.text = self.station.name
        radiotags.text = self.station.tags
        radioimage.sd_setImage(with: URL(string: self.station.image), completed: nil)
        
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addfav(_ sender: UIButton) {
        
        let fav = Favorite()
        fav.name = self.station.name
        fav.image = self.station.image
        fav.tags = self.station.tags
        fav.url = self.station.url
        
        DBManager.sharedInstance.addData(object: fav)
        
    }
    
    @IBAction func playradio(_ sender: UIButton) {
        
        if player.isPlaying{
            play.imageView?.image = UIImage(named: "pause")
            player.pause()
        }else{
            play.imageView?.image = UIImage(named: "play")
            player.play()
        }
        
    }
    

   

}
