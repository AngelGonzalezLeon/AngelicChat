//
//  ChatViewController.swift
//  AngelicChat
//
//  Created by angel gonzalez on 2/23/18.
//  Copyright © 2018 angel gonzalez. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource  {
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var chatMessageField: UITextField!
    
    var convo: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        table.dataSource = self
        
        // Auto size row height based on cell autolayout constraints
        table.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        table.estimatedRowHeight = 50
        
        fetchNewMessage()
        onTimer()
//        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sendButton(_ sender: Any) {
        let chatMessage = Message()
        chatMessage.text = chatMessageField.text ?? ""
        chatMessage.user = PFUser.current()!
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
        
        if let user = convo[indexPath.row].user as? PFUser {
            // User found! update username label with username
            cell.userNameLabel.text = user.username
        }
        if convo[indexPath.row].user == nil {
            // No user found, set default username
            cell.userNameLabel.text = "🤖"
        }
        
        // Set Message
        cell.messageLabel.text = convo[indexPath.row].text
        
        return cell
    }
    func fetchNewMessage() {
        
        let query = Message.query()!
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            
            if let messages = messages as? [Message]{
                self.convo = messages
                self.table.reloadData()
                print(self.convo)
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
