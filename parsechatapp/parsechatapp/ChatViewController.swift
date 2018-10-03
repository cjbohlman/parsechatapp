//
//  ChatViewController.swift
//  
//
//  Created by Mely Bohlman on 10/3/18.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var chatMessageField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.dataSource = self
        chatTableView.delegate = self
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        chatTableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let chatMessage = messages[indexPath.row]
        cell.messageLabel.text = chatMessage["text"] as? String
        return cell
    }
    
    @objc func onTimer() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("user")

        // fetch data asynchronously
        query.findObjectsInBackground { (newMessages, error: Error?) in
            if let newMessages = newMessages {
                self.messages = newMessages
                self.chatTableView.reloadData()
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func onSendTap(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = chatMessageField.text ?? ""
        print(chatMessage["text"])
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        

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