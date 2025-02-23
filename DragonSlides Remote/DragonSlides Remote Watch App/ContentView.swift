//
//  ContentView.swift
//  DragonSlides Remote Watch App
//
//  Created by Jamie Balfour on 23/02/2025.
//

import SwiftUI

struct ContentView: View {
    
    private var apiKey : String = "5KBBbq3XA$c%tN@ndJ#xM9N#HSj8DWqVWP7$56FpFuMN5v677c"
    private var apiLink = "https://www.api.jamiebalfour.scot/?type=dragonslides_remote"
    private var apiMethod = "put"
    private var apiAction = "remote-slideshow"
    @State private var apiCode : String = ""
    
    
    struct apiRequest: Codable {
        let key : String
        let method : String
        let action : String
        let id : String
        let value : String
    }
    
    func callApi(valueStr : String) {
        
        //Performs the HTTP request
        let url = URL(string: apiLink)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let r = apiRequest(key: apiKey, method : apiMethod, action : apiAction, id : apiCode, value : valueStr)
        guard let uploadData = try? JSONEncoder().encode(r) else {
            return
        }
        print("Starting")
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) {data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
               mimeType == "application/json",
               let data = data,
               let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        
        task.resume()
    }
    
    func getUserCode() {
        print("Getting code")
    }
    
    var body: some View {
        
        
        
        ScrollView{
            
            VStack {
                TextField ("Code", text: $apiCode)
                HStack{
                    Button {
                        //ACTION
                        callApi(valueStr: "back")
                    } label: {
                        Image(systemName: "arrowshape.backward")
                            .font(.system(size : 28))
                            .padding(.vertical, 20)
                    }
                    Button {
                        //ACTION
                        callApi(valueStr: "next")
                    } label: {
                        Image(systemName: "arrowshape.forward")
                            .font(.system(size : 28))
                            .padding(.vertical, 20)
                    }
                }
                Button {
                    //ACTION
                    callApi(valueStr: "speak")
                } label: {
                    Image(systemName: "speaker.2")
                        .font(.system(size : 28))
                }.foregroundColor(.purple)
                HStack{
                    Button {
                        //ACTION
                        callApi(valueStr: "timers")
                    } label: {
                        Image(systemName: "timer")
                            .font(.system(size : 28))
                    }.foregroundColor(.yellow)
                    Button {
                        //ACTION
                        callApi(valueStr: "widgets")
                    } label: {
                        Image(systemName: "macwindow")
                            .font(.system(size : 28))
                    }.foregroundColor(.green)
                }
                HStack{
                    Button {
                        //ACTION
                        callApi(valueStr: "board")
                    } label: {
                        Image(systemName: "pencil.and.scribble")
                            .font(.system(size : 28))
                    }.foregroundColor(.blue)
                    Button {
                        //ACTION
                        callApi(valueStr: "start")
                    } label: {
                        Image(systemName: "house")
                            .font(.system(size : 28))
                    }.foregroundColor(.red)
                }
                
            }
            .navigationBarTitle("Slides")
            .foregroundColor(Color.orange)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
