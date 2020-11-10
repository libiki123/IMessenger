//
//  StorageManager.swift
//  iMessenger
//
//  Created by Nikki Truong on 2020-11-09.
//  Copyright © 2020 EthanTruong. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias uploadPictureCompletion = (Result<String, Error>) -> Void
    
    // upload picture to firebase storage and return completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping uploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {metaData, error in
            guard error == nil else {
                print("Fail to upload data to firebase for picture")
                completion(.failure(StrageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Fail to get download url")
                    completion(.failure(StrageErrors.failedToDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url return: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StrageErrors: Error {
        case failedToUpload
        case failedToDownloadUrl
    }
}
