//
//  GitData.swift
//  MockAPI
//
//  Created by Muralidhar reddy Kakanuru on 12/3/24.
//


import Foundation

protocol GitData {
    func getData<T: Decodable>(url:String, completion: @escaping @Sendable (T) -> Void)
}

struct DataGit: GitData {

    static let shared = DataGit()
    private init() {}
    
    func getData<T: Decodable>(url: String, completion: @escaping @Sendable (T) -> Void) {
        guard let serverurl = URL(string : url) else {
            print("invalid url")
            return
        }
        
        URLSession.shared.dataTask(with: serverurl){data, _, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else{
                print("no data fetched")
                return
            }
            
            do{
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded)
                }
            }catch {
                print("decoding error \(error)")
            }
            
        }.resume()
    }
    
}
