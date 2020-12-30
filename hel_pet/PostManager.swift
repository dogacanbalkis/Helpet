//
//  anasayfaCell.swift
//  hel_pet
//
//  Created by Doğa Balkış on 26.11.2020.
//

import Foundation
import Firebase

class PostManager {
    
    // MARK: - Properties
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()
    
    // MARK: - Functions
    func getAllPosts(completion: @escaping (_ posts: [Post]?, _ error: Error?) -> Void) {
        firestore.collection("posts").order(by: "createdAt", descending: true).addSnapshotListener { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                completion(nil, error)
                return 
                
            }
            var posts = [Post]()
            documents.forEach { (document) in
                var documentData = document.data()
                documentData["id"] = document.documentID
                
                if let post = Post(dictionary: documentData) {
                    posts.append(post)
                }
                completion(posts, error)
            }
        }
    }
    
    func createPost(post: Post, image: UIImage, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        var post = post
        
        uploadImage(image: image) { (url, error) in
            guard let imageURL = url else {
                completion(false, error)
                return
            }
            post.imageURL = imageURL
            
            self.firestore.collection("posts").addDocument(data: post.toDictionary()) { (error) in
                completion(error == nil, error)
            }
        }
    }
    
    private func uploadImage(image: UIImage, completion: @escaping (_ url: String?,_ error: Error?) -> Void) {
        let storageReference = StorageReference()
        let mediaFolder = storageReference.child("media")
        
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let imageID = UUID().uuidString
            let imageReference = mediaFolder.child("\(imageID).jpg")
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            imageReference.putData(imageData, metadata: metaData) { (metaData, error) in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                imageReference.downloadURL { (url, error) in
                    completion(url?.absoluteString, error)
                }
            }
        }
    }
}
