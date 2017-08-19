//
//  ALiTunesSearchViewController.swift
//  ALiTunesSearch
//
//  Created by ALLENMAC on 2017/8/14.
//  Copyright © 2017年 ALLENMAC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices

// MARK: - Utility

extension String {
    
    //將原始的url編碼為合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //將編碼後的url轉換回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}



// MARK: -

class ALiTunesSearchViewController: UITableViewController {

    // MARK: Definition
    
    @IBOutlet weak var searchBar: UISearchBar!
    var datas: Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        query(keyword: "hobbit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Action
    
    func query(keyword: String?) {
        if keyword == nil || keyword == "" {
            return
        }
        let actualKeyword = keyword?.replacingOccurrences(of: " ", with: "+").urlEncoded()
        
        let url: URL = URL(string: "https://itunes.apple.com/search?term=\(actualKeyword!)&limit=25&entity=movie")!
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            OperationQueue.main.addOperation {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                let json: JSON = JSON(data: data!)
                self.datas = json["results"].arrayObject!
                self.tableView.reloadData()
            }
            }.resume()
    }
    
    func resignSearchBar() {
        self.searchBar.resignFirstResponder()
    }
    
    
    
    // MARK: - Table view data source & delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        
        // Configure the cell...
        let data: [String: Any] = datas[indexPath.row] as! [String : Any]
        cell.configureCell(data: data)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.resignSearchBar()
        
        let data: [String: Any] = datas[indexPath.row] as! [String : Any]
        let url: URL = URL(string: data["trackViewUrl"] as! String)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.resignSearchBar()
    }

    
    
    // MARK: - UISearchBarDelegate
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.query(keyword: searchBar.text)
        self.resignSearchBar()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.query(keyword: searchBar.text)
    }
}
