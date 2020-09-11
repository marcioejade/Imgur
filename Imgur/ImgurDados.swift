//
//  ImgurDados.swift
//  Imgur
//
//  Created by Marcio Izar Bastos de Oliveira on 08/09/20.
//  Copyright © 2020 Marcio Izar Bastos de Oliveira. All rights reserved.
//

import Foundation

class ImgurDados {
    
    var isError = false
//    var imgur = Imgur()

    func getListaImagens(completion: @escaping (Imgur?) -> ()) {
        guard let url = URL(string: "https://api.imgur.com/3/gallery/top/time/week/1?showViral=false&mature=true&album_previews=false") else {
            print("Erro URL")
            isError = true
            return
        }
        
        let yourAuthorizationToken = "Client-ID 649b5eaeffc5f8b"
                
        //Create URLRequest
        var request = URLRequest.init(url: url)
        request.setValue(yourAuthorizationToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                self.isError = true
                completion(nil)
                return
            }

            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                //Decode JSON Response Data
                let model = try decoder.decode(Imgur.self, from: dataResponse)
                print(model.success)
                print(model.status)
                if model.success {
                    completion(model)
                } else {
                    self.isError = true
                    print("Erro Desconhecido")
                }
            } catch let parsingError {
                do {
                    let decoderError = JSONDecoder()
                    let modelError = try decoderError.decode(ImgurError.self, from: dataResponse)
                    if modelError.success == false {
                        print(modelError.data.error ?? "Erro!")
                    } else {
                        self.isError = true
                        print("Erro Desconhecido - ", parsingError)
                    }
                } catch let parsingError {
                    self.isError = true
                    print("Error - ", parsingError)
                }
            }
        }
        task.resume()
    }
}
