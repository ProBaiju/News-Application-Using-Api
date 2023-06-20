//
//  apiCaller.swift
//  newsApplicationIso
//
//  Created by AL20 on 19/06/23.
//

import Foundation





final class APICaller {
    static let shared = APICaller()
    struct Constant {
        static let topHeadlineURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=4ad916e802f64fecba37f4520bab75c6")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constant.topHeadlineURL else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error:", error)
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    let articleTitles = result.articles.map { $0.title }
                    print("Article Titles:", articleTitles)
                    completion(.success(result.articles))
                } catch {
                    print("Decoding Error:", error)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


// Models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
//    let content: String
}

struct Source: Codable {
    let name: String
}

