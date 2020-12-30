//
//  ViewController.swift
//  hel_pet
//
//  Created by Doğa Balkış on 9.11.2020.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    // MARK: - UI Elements
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    //   Giriş Butonu
    @IBAction func SifreUnutuldu(_ sender: Any) {
        
        let forgotPasswordAlert = UIAlertController(title: "Şifrenizi mi unuttunuz?", message: nil , preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Mail Adresinizi Giriniz."
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Şifreyi Sıfırla", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                //Fonsiyonu async etmekte
                DispatchQueue.main.async { [self] in
                    // Hata oluşturduk
                    if let error = error {
                        self.hataOlustur(titleInput: "Hata Oluştu", messageInput: error.localizedDescription)
                    } else {
                        self.hataOlustur(titleInput: "Şifre Sıfırlama Başarılı!", messageInput: "Lütfen emaillerinizi kontrol edin")
                    }
                }
            })
        }))
        // Hata mesajını present ediyoruz
        self.present(forgotPasswordAlert, animated: true, completion: nil)
        
        
    }
    @IBAction func girisyapTiklandi(_ sender: Any) {
        
        // Girilen kullanıcı adı ve şifreyi boş olup olmadığını kontrol edicek. Eğer ikisinden biri boş ise hata oluştur fonksiyonunu çalıştırarak bildirim gösterecek, doluysa eğer Firebase üzerinden verileri alarak anasayfaViewController'a segue yaparak geçecektir. 
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (Authdata, error) in
                
                
                // Error var ise Hata mesajı Oluşturacak.
                if error != nil {
                    self.hataOlustur(titleInput: "Hata", messageInput: error?.localizedDescription ?? "error")
                    
                }else {
                    //                    hata mesajı boş ise gösterecek.
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            hataOlustur(titleInput: "Tekrar Deneyiniz", messageInput: "Kullanıcı adı veya şifre boş bırakılmaz, lütfen tekrar deneyiniz")
        }
    }
    
    // Kayıt Butonu
    @IBAction func kayitolTiklandi(_ sender: Any) {
        performSegue(withIdentifier: "toKayitOlPage", sender: nil)
    }
    // Hata Mesajı Fonksiyonu
    func hataOlustur(titleInput:String, messageInput: String) {
        let hataMesaji = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let tamamButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        hataMesaji.addAction(tamamButton)
        self.present(hataMesaji, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
