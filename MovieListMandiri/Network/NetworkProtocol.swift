//
//  NetworkProtocol.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import RxSwift

protocol NetworkProtocol {
    func get(url: String, bodyParams: [String: Any], header: [String: String]) -> Observable<Data>
    func post(url: String, bodyParams: [String: Any], header: [String: String]) -> Observable<Data>
    func put(url: String, bodyParams: [String: Any], header: [String: String]) -> Observable<Data>
    
    func delete(url: String, bodyParams: [String: Any], header: [String: String]) -> Observable<Data>
}
    
extension NetworkProtocol {
    func get(url: String,
             bodyParams: [String: Any] = [:],
             header: [String: String] = [:]) -> Observable<Data> {
        return self.get(url: url, bodyParams: bodyParams, header: header)
    }
    
    func post(url: String,
              bodyParams: [String: Any] = [:],
              header: [String: String] = [:]) -> Observable<Data> {
        return self.post(url: url, bodyParams: bodyParams, header: header)
    }
    
    func put(url: String,
              bodyParams: [String: Any] = [:],
              header: [String: String] = [:]) -> Observable<Data> {
        return self.put(url: url, bodyParams: bodyParams, header: header)
    }
    
    func delete(url: String,
              bodyParams: [String: Any] = [:],
              header: [String: String] = [:]) -> Observable<Data> {
        return self.delete(url: url, bodyParams: bodyParams, header: header)
    }
}

