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
    @State var splitNumber = 1.0
    
    @State var totalPerPerson = 45.05
    @State var partBill = 37.54
    @State var partTip = 7.51
    
    private let url = URL(string: "https://www.apple.com")!
    
    
    var body: some View {
        ZStack {
            //MARK: - BACKGROUND
            Rectangle()
                .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                .edgesIgnoringSafeArea(.all)
                    
                
                Rectangle()
                    .frame(width: 550)
                    .foregroundColor(Color.white)
                    .rotationEffect(Angle(degrees: 80))
            
            //MARK: - TITLE + SHARE
            VStack {
                HStack {
                    //Title
                    Text("Tip-Em")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.trailing, 30)
                    
                    // Share button (to send by text)
                    ShareLink(item: "Hello World!"){
                        Label("", systemImage: "square.and.arrow.up")
                            .foregroundColor(Color.white)
                    }
                    
//                    Button(action: {
//                        print("pressed")
//                    }, label: {Image(systemName: "square.and.arrow.up")
//                        .foregroundColor(Color.white)
//
//                    })
                    
                    
                }.scaleEffect(2)
                    .padding(.leading, 150)
                    .padding(.trailing, 30)
                    .padding(.vertical, 80)
                
                //MARK: - BILL AMOUNT
                VStack {
                    // Bill amount
                    Text("Enter bill amount:")
                        .foregroundColor(Color(red: 159/255, green: 166/255, blue: 162/255))
                        .font(.system(size: 20.0))
                    
                    VStack {
                        HStack {
                            Text("$")
                                .fontWeight(.bold)
                                .font(.system(size: 25.0))
                                .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                            
                            TextField("Total", text: $total){ _ in
                                updateNumbers()
                            }
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
                            .font(.system(size: 20.0))
                        
                        Text("\(tip, specifier: "%.1f")%")
                            .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                            .fontWeight(.bold)
                            .font(.system(size: 25.0))
                        
                    }.padding([.bottom, .top], 10)
                    
                    Slider(value: $tip, in: 0...100, step: 1.0){ _ in
                            updateNumbers()
                    }
                        .padding(.horizontal, 90)
                }.padding(.vertical, 8)
                
                //MARK: - SPLIT
                VStack {
                    Text("Split into:")
                        .foregroundColor(Color(red: 159/255, green: 166/255, blue: 162/255))
                        .font(.system(size: 20.0))
                        .padding(.vertical, 8)
                    
                    HStack {
                        // Stepper
                        Stepper("Split into", value: $splitNumber, in: 1...100){ _ in
                            updateNumbers()
                        }
                        .labelsHidden()
                        .padding(.trailing, 12)
                        
                        Text("\(splitNumber, specifier: "%.f")")
                            .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                            .fontWeight(.bold)
                            .font(.system(size: 25.0))
                        
                    }
                }.padding(.vertical, 8)
                
                //MARK: - TOTAL
                VStack {
                    VStack(spacing: 8) {
                        //Total person
                        Text("Total per person:")
                            .foregroundColor(Color(red: 159/255, green: 166/255, blue: 162/255))
                            .font(.system(size: 20.0))
                        
                        Text("$\(totalPerPerson, specifier: "%.2f")")
                            .foregroundColor((Color(red: 243/255, green: 154/255, blue: 54/255)))
                            .fontWeight(.bold)
                            .font(.system(size: 25.0))
                    }
                    
                    HStack(spacing: 150){
                        VStack(spacing: 8){
                            // Bill Part
                            
                            Text("Bill")
                                .foregroundColor(Color(red: 159/255, green: 166/255, blue: 162/255))
                                .font(.system(size: 20.0))
                            
                            Text("$\(partBill, specifier: "%.2f")")
                                .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                                .font(.system(size: 25.0))
                                .fontWeight(.bold)
                        }
                        
                        VStack(spacing: 8){
                            // Tip Part
                            Text("Tip")
                                .foregroundColor(Color(red: 159/255, green: 166/255, blue: 162/255))
                                .font(.system(size: 20.0))
                            
                            Text("$\(partTip, specifier: "%.2f")")
                                .foregroundColor(Color(red: 243/255, green: 154/255, blue: 54/255))
                                .font(.system(size: 25.0))
                                .fontWeight(.bold)
                        }
                    }
                }.padding(.top, 70)
                    .padding(.bottom, 170)
            }
            
        }
    }
    
    func updateNumbers() {
        let totalDouble = Double(total)!
        let tipAmount = totalDouble * tip / 100
        let totalTipped = totalDouble + tipAmount
        
        totalPerPerson = totalTipped / splitNumber
        partTip = tipAmount / splitNumber
        partBill = totalDouble / splitNumber
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
