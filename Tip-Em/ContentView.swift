//
//  ContentView.swift
//  Tip-Em
//
//  Created by Adrien CHABAUD on 2022-11-06.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var total = "112.63"
    @State var tip = 20.0
    
    var body: some View {
        ZStack {
            //MARK: - BACKGROUND
            Rectangle()
                .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .frame(width: 550)
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 80))
            
            //MARK: - TITLE + SHARE
            VStack {
                HStack {
                    //Title
                    Text("Tip-Em")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.trailing, 30)
                    
                    // Share button (to send by text)
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.black)
                }.scaleEffect(2)
                    .padding(.leading, 150)
                    .padding(.trailing, 30)
                    .padding([.top,	 .bottom], 16)
                
                //MARK: - BILL AMOUNT
                VStack {
                    // Bill amount
                    Text("Enter bill amount:")
                        .foregroundColor(Color(red: 159/255, green: 166/255, blue: 162/255))
                    VStack {
                        HStack {
                            Text("$")
                                .fontWeight(.bold)
                                .font(.system(size: 25.0))
                                .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                            TextField("Total", text: $total)
                                .frame(width: 90)
                                .fontWeight(.bold)
                                .font(.system(size: 25.0))
                                .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                                .keyboardType(.decimalPad)
                                .onReceive(Just(total)) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        self.total = filtered
                                    }
                                }
                        }.padding(.bottom, -9)
                        Divider()
                            .frame(width: 40)
                            .padding(.horizontal, 30)
                            .background(Color.black)
                            .opacity(0.3)
                    }
                }
                
                //MARK: - TIPPING
                VStack {
                    HStack {
                        Text("Choose a tip: ")
                            .foregroundColor(Color(red: 159/255, green: 166/255, blue: 162/255))
                        Text("\(tip, specifier: "%.1f")%")
                            .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                            .fontWeight(.bold)
                            .font(.system(size: 25.0))
                    }.padding([.bottom, .top], 10)
                    
                    Slider(value: $tip, in: 0...100)
                        .padding(.horizontal, 90)
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
