//
//  StorageManager.swift
//  iMessenger
//
//  Created by Nikki Truong on 2020-11-09.
//  Copyright © 2020 EthanTruong. All rights reserved.
//

import Foundation
import FirebaseStorage

/// allow you to get, fetch and upload files to firebase storage
final class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    private let storage = Storage.storage().reference()
    
    public typealias uploadPictureCompletion = (Result<String, Error>) -> Void
    
    /// upload picture to firebase storage and return completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping uploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {[weak self]metaData, error in
            guard error == nil else {
                print("Fail to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Fail to get download url")
                    completion(.failure(StorageErrors.failedToDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url return: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToDownloadUrl
    }
    
    public func downloadUrl(for path: String, completion: @escaping (Result<URL, Error>) -> Void){
        let reference = storage.child(path)
        
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToDownloadUrl))
                return
            }
            
            completion(.success(url))
        })
    }
    
    // upload image that will be snet in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping uploadPictureCompletion) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metaData, error in
            guard error == nil else {
                print("Fail to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Fail to get download url")
                    completion(.failure(StorageErrors.failedToDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url return: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    // upload video that will be snet in a conversation message
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping uploadPictureCompletion) {
        if let videoData = NSData(contentsOf: fileUrl) as Data? {
            storage.child("message_videos/\(fileName)").putData(videoData, metadata: nil, completion: { [weak self] metaData, error in
                guard error == nil else {
                    print("Fail to upload video file to firebase for picture")
                    completion(.failure(StorageErrors.failedToUpload))
                    return
                }
                
                self?.storage.child("message_videos/\(fileName)").downloadURL(completion: {url, error in
                    guard let url = url else {
                        print("Fail to get download url")
                        completion(.failure(StorageErrors.failedToDownloadUrl))
                        return
                    }
                    
                    let urlString = url.absoluteString
                    print("Download url return: \(urlString)")
                    completion(.success(urlString))
                })
            })
        }
    }
}
