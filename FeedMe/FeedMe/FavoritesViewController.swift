//
//  FavoritesViewController.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/6/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var localUser : User = User();
    var items: [Recipe] = []
    var bgColor = UIColor(red: 253/255.0, green: 251/255.0, blue: 243/255.0, alpha: 255/255.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = bgColor
        println("???")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
        }
        self.getLocalUser()
    }
    
    func getLocalUser() -> Void {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/", parameters:nil)
        var user = User()
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                println("Error: \(error)")
                
            }
            else {
                if let fbid = result["id"] as? String {
                    self.localUser.fbid = fbid
                    if let name = result["name"] as? String {
                        self.localUser.name = name
                    }
                }
                var server = Server()
                if (!server.doesUserExist(self.localUser)) {
                    server.createUser(self.localUser);
                } else {
                    println("user exists")
                }
                self.items = server.getFavoriteRecipes(self.localUser)
                self.tableView.reloadData()
            }
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row].name
        cell.backgroundColor = bgColor
        cell.textLabel?.font = UIFont(name: "GillSans", size: 20)
        cell.textLabel?.textColor = UIColor(red: 216/255.0, green: 140/255.0, blue: 105/255.0, alpha: 1.0)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var server = Server()
            server.deleteFavoriteRecipe(self.localUser, recipe: items[indexPath.row])
            items.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            self.tableView.editing = false
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
