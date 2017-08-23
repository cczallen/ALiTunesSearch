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
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    
    var dataTask: URLSessionDataTask?
    
    
    
    // MARK: - Public
    
    public func configureCell(data: [String: Any]) {
        let trackName: String = data["trackName"] as! String
        self.nameLabel.text = trackName
        
        let releaseDate: String = data["releaseDate"] as! String
        let year = releaseDate.components(separatedBy: "-").first
        self.yearLabel.text = year
        let genre: String = data["primaryGenreName"] as! String
        self.genreLabel.text = genre
        let director: String = data["artistName"] as! String
        self.directorLabel.text = director
        
        
        var urlString = data["artworkUrl100"] as! String
        urlString = urlString.replacingOccurrences(of: "100x100", with: "600x600")
        
        if self.dataTask?.state != URLSessionTask.State.completed {
            self.dataTask?.cancel()
        }
        
        self.trackTmageView.image = UIImage.init(named: "imagePlaceholder")

        self.dataTask = ApiManager.GETImage(urlString: urlString) { (image: UIImage?) in
            if image != nil {
                self.trackTmageView.image = image
            }
        }
    }
    
    
    
    // MARK: - override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
