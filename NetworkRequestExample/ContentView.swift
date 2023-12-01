//
//  ContentView.swift
//  NetworkRequestExample
//
//  Created by Tayami Rai on 01/12/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear{
            
            Task{
                await apiCall()
            }
            
        }
    }
    
    //Remember adding async allows the system to know that you can call the function in a background thread
    
    func apiCall() async{
        
        //URL
        //A url instance is going to be created from this endpoint URL
        
        //This initialiser may contain nil or actual url. Optional binding should be done
        
        if let url = URL(string: "https://api.pexels.com/v1/search?query=nature&per_page=1") {
            
            //URL Request
            var request = URLRequest(url: url)
            
            // used var because let wouldn't allow us to add authorisation
            
            request.addValue("apikey", forHTTPHeaderField: "Authorization")
            
            //URL Session
            // we don't need to create new isntance, we can access shared instance
            
            do{
                let (data, response) = try await URLSession.shared.data(for: request)
                // ^^ this has await and doesn't require a task block since apiCall() is already inside a task block
                
                //Parse the JSON
                
                let decoder = JSONDecoder()
                
                do{
                    let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                    
                    for photo in searchResponse.photos{
                        print(photo)
                    }
                }
                catch{
                    print(error)
                }
                
            }
            catch{
                print(error)
            }
            
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
