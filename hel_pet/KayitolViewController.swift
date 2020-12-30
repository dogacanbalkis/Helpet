//
//  KayitolViewController.swift
//  hel_pet
//
//  Created by Doğa Balkış on 13.11.2020.
//

import UIKit
import Firebase

class KayitolViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var kullaniciadiKayit: UITextField!
    @IBOutlet weak var sifreKayit: UITextField!
    @IBAction func kayitolButon(_ sender: Any) {
        //  email ve şifre boş girilirse çalıştıralacak işlem
        if kullaniciadiKayit.text != "" && sifreKayit.text != "" {
            Auth.auth().createUser(withEmail: kullaniciadiKayit.text!, password: sifreKayit.text!) { (authdata, error) in
                // hata varsa eğer ilk onu görmek için kullanacağız.Eğer internet bağlantısı veya farklı bir şekilde sorun olursa onu otomatik Firebase bunu gösterecek.
                if error != nil{
                    //     Firebase hata mesajı
                    self.hataOlustur(titleInput: "Hata", messageInput: error!.localizedDescription)
                    
                }else{
                    Auth.auth().currentUser?.sendEmailVerification { [self] (error) in
                        self.performSegue(withIdentifier: "toFeedVC2", sender: nil)
                    }
                }
            }
        }else{
            //     giriş yaparken eğer doğru değilse uyarı mesajı vericek.
            hataOlustur(titleInput: "Hata", messageInput: "Lütfen kullanıcı adı ve şifreyi kontrol ediniz.")
        }
    }
    
    // MARK: - Functions
    @IBAction func vazgecButon(_ sender: Any) {
        performSegue(withIdentifier: "toBackMainPage", sender: nil)
    }
    // Hata mesajı Oluşturuyoruz.
    func hataOlustur(titleInput:String, messageInput: String) {
        let hataMesaji = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let tamamButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        hataMesaji.addAction(tamamButton)
        self.present(hataMesaji, animated: true, completion: nil)
        
    }
    //Bildirim Mesajı Oluşturuyoruz.
    func bildirimMesajiOlustur(titleInput: String, messageInput: String)
    {
        let bildirimMesaji = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let bildirimButon = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        bildirimMesaji.addAction(bildirimButon)
        self.present(bildirimMesaji, animated: true, completion: nil)
    }
    
    // MARK: - Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
