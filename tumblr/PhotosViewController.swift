//
//  PhotosViewController.swift
//  tumblr
//
//  Created by Anmol Khanna on 2/1/17.
//  Copyright © 2017 Anmol Khanna. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var UITableView: UITableView!
    var posts : [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITableView.rowHeight = 240;
        UITableView.dataSource = self
        UITableView.delegate = self
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.UITableView.reloadData()
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    }
                }
        });
        task.resume()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let posts = posts{
            return posts.count
        }
        else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        //cell.textLabel!.text = "hello"
        
        let post = posts?[indexPath.row]
        
        //let timestamp = post?["timestamp"] as? String
        
        
        let photos = post?.value(forKeyPath: "photos") as? [NSDictionary]
        
        let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
        
        let imageUrl = URL(string: imageUrlString!)
        
        
        
        
       cell.pcell.setImageWith(imageUrl!)
        
        //let imageUrl = URL(string: imageUrlString!)!
        
        
        
        return cell
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
