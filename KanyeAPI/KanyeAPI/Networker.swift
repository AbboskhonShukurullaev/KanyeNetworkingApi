//
//  Networker.swift
//  KanyeAPI
//
//  Created by 1 on 23/11/21.
//

import Foundation

enum NetworkerError: Error {
    case badResponse
    case badStatusCode
    case badData
}

class Networker {
    
    static let shared = Networker()
    
    private let urlSession: URLSession
    
    init() {
        let defaultConfiguration = URLSessionConfiguration.default
        urlSession = URLSession(configuration: defaultConfiguration)
    }
    

    func getQuote(completion: @escaping (Kanye?, Error?) -> Void) {
        let url = URL(string: "https://api.kanye.rest/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = urlSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(nil, NetworkerError.badResponse)
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(nil, NetworkerError.badStatusCode)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NetworkerError.badData)
                }
                return
            }
            
            do {
                let kanyeJson = try JSONDecoder().decode(Kanye.self, from: data)
                
                print(kanyeJson)
                
                DispatchQueue.main.async {
                    completion(kanyeJson, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func getImage(completion: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Kanye_West_at_the_2009_Tribeca_Film_Festival_%28cropped%29.jpg/1200px-Kanye_West_at_the_2009_Tribeca_Film_Festival_%28cropped%29.jpg")!
        
        let task = urlSession.downloadTask(with: url) { (localURL: URL?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(nil, NetworkerError.badResponse)
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(nil, NetworkerError.badResponse)
                }
                return
            }
            
            guard let localURL = localURL else {
                DispatchQueue.main.async {
                    completion(nil, NetworkerError.badData)
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: localURL)
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
