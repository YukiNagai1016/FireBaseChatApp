//
//  ViewController.swift
//  FireApp
//
//  Created by 優樹永井 on 2019/04/12.
//  Copyright © 2019 com.nagai. All rights reserved.
//

import UIKit
import FirebaseCore
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageField.delegate = self
        
        databaseRef = Database.database().reference()
        // databaseを呼んでる？？
        
        databaseRef.observe(DataEventType.childAdded, with: { snapshot in //セッティングしている。新しいデータが入ってくるのを見張ってる。もしも、新しいデータが入ってきた場合{}内の処理を実行する。
            if let name = (snapshot.value! as AnyObject).object(forKey: "name") as? String,
                let message = (snapshot.value! as AnyObject).object(forKey: "message") as? String {
                self.textView.text! = "\(self.textView.text!)\n\(name) : \(message)"
                
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        let messageData = ["name": nameField.text!, "message": messageField.text!]
        // firebaseにdictionary型を保存するためデータを作成！
        
        databaseRef.childByAutoId().setValue(messageData) // データを保存！
        
        textField.resignFirstResponder() //キーボードを閉じる
        messageField.text = "" //最終的にはtextFieldを空にする。
        
        return true
    }
}

