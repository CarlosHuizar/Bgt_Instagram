//
//  MainViewController.swift
//  Instagram2
//
//  Created by Carlos Huizar-Valenzuela on 2/26/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var feedTableView: UITableView!
    var posts: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        
        getFeed()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)

    }
    
    @IBAction func onShare(_ sender: Any) {
        
    }
    
    func getFeed()
    {
        // construct PFQuery
        let query = Post.query()
        query?.order(byDescending: "createdAt")
        query?.includeKey("author")
        query?.limit = 20
        
        // fetch data asynchronously
        query?.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            self.posts = posts
            if let posts = posts {
                //print (posts)
                //self.posts = posts
            } else {
                // handle error
            }
            self.feedTableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts != nil{
            return (posts?.count)!
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("Before")
        if(posts != nil) {
            print ("hello")
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
            let post = posts![indexPath.row]
            let caption = post.value(forKey: "caption")
            let picture = post.value(forKey: "media") as? PFFile
            if(picture != nil) {
                picture!.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
                    if(imageData != nil) {
                        let image = UIImage(data: imageData!)
                        cell.feedImageView.image = image
                    }
                })
            }
            
            cell.captionLabel.text = caption as? String
            
            return cell
        }
        print ("Is nil*******************************")
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
        
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
