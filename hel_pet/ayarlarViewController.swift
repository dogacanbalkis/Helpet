//
//  ayarlarViewController.swift
//  hel_pet
//
//  Created by Doğa Balkış on 12.11.2020.
//

import UIKit
import Firebase


class ayarlarViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var userEmail: UILabel!
    var posts = [Post]()
    let postManager = PostManager()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      prepareForUserMail()
    }
    
    func prepareForUserMail(){
        // Kullanıcı'nın mail adresini Firebase'den alıp Label'a yazıyoruz.
        let firestoredb = Firestore.firestore()
        userEmail.text! = (Auth.auth().currentUser?.email)!
    }
    

    // MARK: - Button
    @IBAction func cikisyapTiklandi(_ sender: Any) {
        // Çıkış yap butonuna bastığımızda Firebase üzerinden SignOut olmaktadır.
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch {
            print("Hata Oluştu")
        }
    }
    
}

