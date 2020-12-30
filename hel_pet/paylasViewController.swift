//
//  paylasViewController.swift
//  hel_pet
//
//  Created by Doğa Balkış on 12.11.2020.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class paylasViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate,UITextViewDelegate {
    
    // MARK: - UI Elements
    @IBOutlet weak var paylasImage: UIImageView!
    @IBOutlet weak var paylasButonOutlet: UIButton!
    @IBOutlet weak var yorumText: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var currentPinLocation: CLLocationCoordinate2D?
    let postManager = PostManager()
    let manager = CLLocationManager()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resimSec))
        // map view'ın pin koyabilmek için gesture recognizer oluşturuyoruz.
        let gestureRecognizerMap = UILongPressGestureRecognizer(target: self, action: #selector(konumuSeç(gestureRecognizerMap:)))
        
        yorumText.delegate = self
        yorumText.text = "Yorumunuzu buraya yazabilirsiniz..."
        yorumText.textColor = UIColor.lightGray
        yorumText.textAlignment = .center
        yorumText.returnKeyType = .done
        mapView.layer.cornerRadius = 13
        mapView.layer.masksToBounds = true
        // locationManager oluşturup konuma erişmek için izin isitiyoruz
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.addGestureRecognizer(gestureRecognizerMap)
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.showsUserLocation = true
        // başlangıçta imageview'da göreceğimiz resim ve tıkladığımızda resim upload edeceğimiz kodlar
        paylasImage.isUserInteractionEnabled = true
        paylasImage.addGestureRecognizer(gestureRecognizer)
        // kaç sn mapte pini tuttuğunu söylüyor sn cinsinden
        gestureRecognizerMap.minimumPressDuration = 0.5
        
    }
    // MARK: - Functions
    //    map view gesture için selector func oluşturuyoruz
    @objc func konumuSeç(gestureRecognizerMap: UILongPressGestureRecognizer){
        guard gestureRecognizerMap.state == .began else { return }
        //eğer haritaya dokunulduysa kontrol ediyoruz
        let touchPoint = gestureRecognizerMap.location(in: self.mapView)
        // dokunulan yerin kordinatlarını oluşturuyoruz ve map viewde gösteriyoruz
        let newPinLocation = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        // Eğer haritada pin varsa, önce onu kaldır.
        if currentPinLocation != nil {
            mapView.removeAnnotations(mapView.annotations)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = newPinLocation
        annotation.title = "Yardım Noktası"
        annotation.subtitle = "Helpet"
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: newPinLocation, span: span)
        mapView.setRegion(region, animated: true)
        currentPinLocation = newPinLocation
    }
    //veriler Firebase' e yüklenirken beklenmesini gösteren bir animasyon oluşturduk, verilerin yüklenmesi bir kaç saniye alabiliyor.
    func waitingAnimation(){
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.systemRed
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    @objc func resimSec() {
        // kullanıcının kütüphanesine erişmek için picker control oluşturuyoruz.
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    //    Textview kodlar
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Yorumunuzu buraya yazabilirsiniz..." {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.textAlignment = .center
            
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            
            textView.text = "Yorumunuzu buraya yazabilirsiniz..."
            textView.textColor = UIColor.lightGray
            textView.textAlignment = .center
        }
    }
    //   Textview içerisinde tıklandığı andaki kodlar
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //    kullanıcı resmi seçince ne olacak diye sorucak
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        paylasImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    //   uyari fonksiyonu oluşturduk
    func uyariOlustur(titleInput: String, messageInput: String){
        let uyari = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let tamamButon = UIAlertAction(title:"Tamam" ,style: UIAlertAction.Style.default, handler: nil)
        uyari.addAction(tamamButon)
        self.present(uyari, animated: true, completion: nil)
    }
    
    // MARK: - Button
    
    @IBAction func paylasButon(_ sender: Any) {
        waitingAnimation()
        let location = GeoPoint(latitude: currentPinLocation!.latitude, longitude: currentPinLocation!.longitude)
        let ownerEmail = Auth.auth().currentUser!.email!
        let helpet = false
        let post = Post(ownerEmail: ownerEmail, comment: yorumText.text!, location: location, helped: helpet)
        postManager.createPost(post: post, image: paylasImage.image!) { [weak self] (success, error) in
            if success {
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {
                    strongSelf.paylasImage.image = UIImage(named: "paylasResim.png")
                    strongSelf.yorumText.text = "Yorumunuzu buraya yazabilirsiniz..."
                    strongSelf.yorumText.textColor = UIColor.lightGray
                    strongSelf.yorumText.textAlignment = .center
                    strongSelf.view.endEditing(true)
                    strongSelf.mapView.removeAnnotations(strongSelf.mapView.annotations)
                    strongSelf.tabBarController?.selectedIndex = 0
                    strongSelf.mapView.showsUserLocation = true
                    strongSelf.mapView.setUserTrackingMode(.follow, animated: true)
                    strongSelf.activityIndicator.stopAnimating()
                }
                
            }else if let error = error{
                debugPrint(error.localizedDescription)
                self?.uyariOlustur(titleInput: "Hata", messageInput: error.localizedDescription)
            }
        }
    }
}

