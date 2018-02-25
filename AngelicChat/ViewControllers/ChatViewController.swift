//
//  ChatViewController.swift
//  AngelicChat
//
//  Created by angel gonzalez on 2/23/18.
//  Copyright © 2018 angel gonzalez. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ChatViewController: UIViewController, UITableViewDataSource  {
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var chatMessageField: UITextField!
    
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    var refreshcontrol: UIRefreshControl!
    
    var convo: [Message] = []
    
    override func viewDidLoad() {
        loadingActivityIndicator.hidesWhenStopped = true;
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        table.dataSource = self
        table.separatorStyle = .none
        
        
        // Auto size row height based on cell autolayout constraints
        table.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        table.estimatedRowHeight = 50
        
        
        refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(ChatViewController.loadToRefresh(_:)), for: .valueChanged)
        
        
        fetchNewMessage()
        onTimer()

    }
    
    
    @objc func loadToRefresh(_ refreshControl:UIRefreshControl){
        fetchNewMessage()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sendButton(_ sender: Any) {
    loadingActivityIndicator.startAnimating()
        let chatMessage = Message()
        chatMessage.text = chatMessageField.text ?? ""
        chatMessage.user = PFUser.current()!
        let baseURL = "http://api.adorable.io/avatar/100/"
        chatMessage.avatar = baseURL + chatMessage.user.username!
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        print(convo)
        
        let curMessage = convo[indexPath.row]
        
        if let user = curMessage.user as? PFUser {
            // User found! update username label with username
            cell.userNameLabel.text = user.username
        }
        if curMessage.user == nil {
            // No user found, set default username
            cell.userNameLabel.text = "🤖"
        }
        
        // Set the avatar image
        
        // No avatar found, set default avatar
        if curMessage.avatar == nil {
            
            let defaultURL = URL(string: "http://api.adorable.io/avatar/100/janeDoe")!
            print("no avatar")
            print(defaultURL)
            cell.avatarImageView.af_setImage(withURL: defaultURL)
        }
        // Avatar found! Set custom avatar
        if let avatar = curMessage.avatar as? String{
        
            print("avatar")
            print(avatar)
            cell.avatarImageView.af_setImage(withURL: URL(string: avatar)!)
        }
        
    
    
        // Set Message
        cell.messageLabel.text = convo[indexPath.row].text
        
        loadingActivityIndicator.stopAnimating()
        return cell
    }
    func fetchNewMessage() {
        
    loadingActivityIndicator.startAnimating()
        let query = Message.query()!
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            
            if let messages = messages as? [Message]{
                self.convo = messages
                self.table.reloadData()
                //print(self.convo)
            }
            else{
                print(error?.localizedDescription)
            }
        }
        
    }
    
    @objc func onTimer(){
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        fetchNewMessage()
        
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
