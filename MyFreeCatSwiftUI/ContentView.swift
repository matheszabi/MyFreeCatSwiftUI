//
//  ContentView.swift
//  MyFreeCatSwiftUI
//
//  Created by Mathe  Szabolcs on 28.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var image : Image? = nil
    
    var body: some View {
        VStack{
            
            HStack(alignment: .center){
                    Text("Get a cat:")
                        .padding()
                
                    Button(action: buttonClicked) {
                        Text("Random one")
                        .padding(20)
                        .background(Color.yellow)
                        .foregroundColor(Color.purple)
                    }
            }.padding()
            // This should be the last, put everything to the top
            
            image?
                .resizable()
                .scaledToFit()
                .background(Color.red)
                
            Spacer()
        }
    }
    
    func buttonClicked(){
        
        let url = URL(string: "https://api.thecatapi.com/v1/images/search")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print("The response is : ",String(data: data, encoding: .utf8)!)
            // [{"breeds":[],"id":"dcv","url":"https://cdn2.thecatapi.com/images/dcv.jpg","width":828,"height":450}]
            // [{"breeds":[],"id":"Vcf2l8tKO","url":"https://cdn2.thecatapi.com/images/Vcf2l8tKO.jpg","width":400,"height":600}]
            // [{"breeds":[],"id":"ap5","url":"https://cdn2.thecatapi.com/images/ap5.jpg","width":480,"height":360}]

            
            let myArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any]
           
            if let firstElement = myArray?.first as? Dictionary<String, AnyObject>{
                let catImageData = CatImageData(json: firstElement)
                
                let url = URL(string: catImageData.url)
                let data = try? Data(contentsOf: url!) // synchronously, but we are in the task now
                
                
                image = Image( uiImage :  UIImage(data: data!)! )
                
                
            }
            
        }
        task.resume()
        
    }
}


struct CatImageData  {
    var id: String
    var url : String
    var width: String
    var height: String
    
    init(json : Dictionary<String, AnyObject>){
        id = json ["id"] as! String
        url = json ["url"] as! String
        width = (json ["width"] as! NSNumber).stringValue
        height = (json ["height"] as! NSNumber).stringValue // usually it is an int
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
