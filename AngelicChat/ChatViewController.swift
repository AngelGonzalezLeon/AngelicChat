//
//  ChatViewController.swift
//  AngelicChat
//
//  Created by angel gonzalez on 2/23/18.
//  Copyright © 2018 angel gonzalez. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {

    let chatMessage = PFObject(className: "Message")
    
    @IBOutlet weak var chatMessageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
