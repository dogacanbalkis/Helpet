//
//  anasayfaCell.swift
//  hel_pet
//
//  Created by Doğa Balkış on 26.11.2020.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
import SDWebImage


class anasayfaCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate{
    
    // MARK: - Properties
    @IBOutlet weak var kullaniciAdiLabel: UILabel!
    @IBOutlet weak var yorumLabel: UILabel!
    @IBOutlet weak var kullaniciImagelabel: UIImageView!
    @IBOutlet weak var anasayfaHarita: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private var post: Post!
    
    // MARK: - Life Cyle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        button.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    // MARK: - Functions
    @IBAction func buttonTapped(_ button: UIButton) {
        let firestoreDB = Firestore.firestore()
        let ValueStore = ["helped": !post.helped]
        
        firestoreDB.collection("posts").document(post.id).updateData(ValueStore)
    }
    
    func updateButtonUI(filled: Bool) {
        if !filled {
            button.backgroundColor = .clear
            button.setTitle("Yardım Edildi", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            
        }else {
            button.backgroundColor = .systemBlue
            button.setTitle("Yardım Et", for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    func prepare(with post: Post) {
        self.post = post
        
        kullaniciAdiLabel.text = post.ownerEmail
        yorumLabel.text = post.comment
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY, HH:mm"
        
        dateLabel.text = dateFormatter.string(from: post.createdAt)
        
        if let imageURL = URL(string: post.imageURL) {
            kullaniciImagelabel.sd_setImage(with: imageURL)
        }
        
        updateButtonUI(filled: !post.helped)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(geoPoint: post.location)
        anasayfaHarita.addAnnotation(annotation)
        
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(geoPoint: post.location), span: span)
        anasayfaHarita.setRegion(region, animated: true)
        
        
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
     anasayfaHarita.removeAnnotations(anasayfaHarita.annotations)
    }
}
// MARK: - Extension

extension CLLocationCoordinate2D {
    
    init(geoPoint: GeoPoint) {
        self = .init(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
}



















