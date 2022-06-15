//
//  ContentView.swift
//  BtcStatus
//
//  Created by jacob on 12/06/2022.
//

import SwiftUI

extension Color {
    static let darkPink = Color(red: 208 / 255, green: 45 / 255, blue: 208 / 255)
}

extension UIColor {
    static let blackish = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
}

var price: String = ""
let cryptos = ["BTC", "ETH", "XMR"]


func BtcStatus(crypto: String) -> String {
    struct Ticker: Codable {
        let status: String
        let ticker: TickerClass
    }

    struct TickerClass: Codable {
        let market: Market
        let rate: String
        let previousRate: String
    }

    struct Market: Codable {
        let code: String
        let first, second: First
    }

    struct First: Codable {
        let currency, minOffer: String
        let scale: Int
    }
    
    if let url = URL(string: "https://api.zonda.exchange/rest/trading/ticker/" + crypto + "-PLN") {
        URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            let jsonDecoder = JSONDecoder()
                do {
                    let parsedJSON = try jsonDecoder.decode(Ticker.self, from: data)
                    if parsedJSON.ticker.rate != nil {
                        price = (parsedJSON.ticker.rate + " PLN = 1 \(crypto)")
                        print(price)
                    }
                } catch {
                    print(error)
                }
            }
        }
        .resume().self
    }
    return price
}

struct ContentView: View {
    
    
    @State private var isAnimating = false
    @State var buttonTitle: String = "..."
    @State var value: String = "BTC"
    
    let startGradient = Gradient(colors: [Color.red, Color.darkPink])
    
    init() {
        let look = UINavigationBarAppearance()
        look.configureWithOpaqueBackground()
        look.backgroundColor = .blackish
        look.titleTextAttributes = [.foregroundColor: UIColor.white]
        look.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = look
        UINavigationBar.appearance().compactAppearance = look
        UINavigationBar.appearance().scrollEdgeAppearance = look
        
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                LinearGradient(
                    gradient: startGradient,
                    startPoint: isAnimating ? .leading : .topTrailing, endPoint: .bottom) .animation(.linear(duration: 1).repeatForever(autoreverses: true), value: isAnimating) .ignoresSafeArea() .saturation(0.7)
                
                Rectangle()
                    .opacity(0.55)
                    .ignoresSafeArea()
                    .colorInvert()
                
                VStack {
                    
                    Text(buttonTitle)
                        .font(.system(size: 36))
                        .padding(15)
                        .foregroundColor(.white)
                        .background(.black .opacity(0.55))
                        .cornerRadius(20)
                    
                    Picker("Pick Crypto", selection: $value) {
                        ForEach(cryptos, id: \.self) {
                            Text($0)
                        }
                    }
                    .accentColor(.black)
                    .pickerStyle(.menu)
                    .padding(15)
                    .colorInvert()
                    .background(.black .opacity(0.55))
                    .cornerRadius(20)
                    
                    Button(action: {
                        buttonTitle = "\(BtcStatus(crypto: value))"
                    })
                    {
                        HStack {
                            Text("Check")
                        }
                        .font(.system(size: 24))
                        .padding(15)
                        .foregroundColor(.white)
                        .background(.black .opacity(0.55))
                        .cornerRadius(20)
                    }
                }
                .foregroundColor(Color.white)
                .font(.system(size: 22))
                
            }
            .onAppear {
                isAnimating.toggle()
            }
            .navigationTitle("BtcStatus")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}


