//
//  TrackCell.swift
//  ALiTunesSearch
//
//  Created by ALLENMAC on 2017/8/18.
//  Copyright © 2017年 ALLENMAC. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    // MARK: Definition
    
    @IBOutlet weak var trackTmageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    
    // MARK: - Public
    
    public func configureCell(data: [String: Any]) {
        let trackName: String = data["trackName"] as! String
        self.nameLabel.text = trackName
        
        let releaseDate: String = data["releaseDate"] as! String
        let year = releaseDate.components(separatedBy: "-").first
        self.yearLabel.text = year
        
        self.trackTmageView.image = UIImage.init(named: "imagePlaceholder")
        
        let url: URL = URL(string: data["artworkUrl100"] as! String)!
        URLSession.shared.dataTask(with: url) { (imageData: Data?, response: URLResponse?, error: Error?) in
            if imageData != nil {
                OperationQueue.main.addOperation {
                    self.trackTmageView.image = UIImage.init(data: imageData!)
                }
            }
            }.resume()
    }
    
    
    
    // MARK: - override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
