//
//  ContentView.swift
//  Tip-Em
//
//  Created by Adrien CHABAUD on 2022-11-06.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    // Main variables
    @State var total = "112.63"
    @State var tip = 20.0
    @State var splitNumber = 1.0
    
    @State var totalPerPerson = 45.05
    @State var partBill = 37.54
    @State var partTip = 7.51
    
    // Colors used in the app
    let orangeColor = Color(red: 243/255, green: 154/255, blue: 54/255)
    let greyColor = Color(red: 159/255, green: 166/255, blue: 162/255)
    
    // Different fonts used
    let titleFontSize = 21.0
    let mainFontSize = 25.0
    let subFontSize = 20.0
    
    var body: some View {
        ZStack {
            //MARK: - BACKGROUND
            Rectangle()
                .foregroundColor(orangeColor)
                .edgesIgnoringSafeArea(.all)
            
            
            Rectangle()
                .frame(width: 550)
                .foregroundColor(Color.white)
                .rotationEffect(Angle(degrees: 80))
            
            //MARK: - TITLE + SHARE
            VStack {
                HStack {
                    //Title
                    TextViewExtract(text: "Tip-Em", color: Color.white, fontSize: titleFontSize)
                        .padding(.trailing, 30)
                        .fontWeight(.bold)

                    
                    // Share button (to send by text)
                    ShareLink(item: createMessage()){
                        Label("", systemImage: "square.and.arrow.up")
                            .foregroundColor(Color.white)
                    }
                    
                }.scaleEffect(2)
                    .padding(.leading, 150)
                    .padding(.trailing, 30)
                    .padding(.vertical, 80)
                
                //MARK: - BILL AMOUNT
                VStack {
                    // Bill amount
                    TextViewExtract(text: "Enter bill amount:", color: greyColor, fontSize: subFontSize)
                        .font(.system(size: subFontSize))
                    
                    VStack {
                        HStack {
                            TextViewExtract(text: "$", color: orangeColor, fontSize: mainFontSize)
                                .fontWeight(.bold)
                                .font(.system(size: mainFontSize))
                            
                            TextField("Total", text: $total){ _ in
                                updateNumbers()
                            }
                            .frame(width: 90)
                            .fontWeight(.bold)
                            .font(.system(size: mainFontSize))
                            .foregroundColor(orangeColor)
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
                        TextViewExtract(text: "Choose a tip: ", color: greyColor, fontSize: subFontSize)
                        
                        Text("\(tip, specifier: "%.1f")%")
                            .foregroundColor(orangeColor)
                            .fontWeight(.bold)
                            .font(.system(size: mainFontSize))
                        
                    }.padding([.bottom, .top], 10)
                    
                    Slider(value: $tip, in: 0...100, step: 1.0){ _ in
                        updateNumbers()
                    }
                    .padding(.horizontal, 90)
                }.padding(.vertical, 8)
                
                //MARK: - SPLIT
                VStack {
                    TextViewExtract(text: "Split into:", color: greyColor, fontSize: subFontSize)
                        .padding(.vertical, 8)
                    
                    HStack {
                        // Stepper
                        Stepper("Split into", value: $splitNumber, in: 1...100){ _ in
                            updateNumbers()
                        }
                        .labelsHidden()
                        .padding(.trailing, 12)
                        
                        Text("\(splitNumber, specifier: "%.f")")
                            .foregroundColor(orangeColor)
                            .fontWeight(.bold)
                            .font(.system(size: mainFontSize))
                        
                    }
                }.padding(.vertical, 8)
                
                //MARK: - TOTALs
                VStack {
                    VStack(spacing: 8) {
                        //Display of the Total per person
                        TextViewExtract(text: "Total per person:", color: greyColor, fontSize: subFontSize)
                        
                        Text("$\(totalPerPerson, specifier: "%.2f")")
                            .foregroundColor(orangeColor)
                            .fontWeight(.bold)
                            .font(.system(size: mainFontSize))
                    }
                    
                    HStack(spacing: 150){
                        VStack(spacing: 8){
                            // Display of the Bill Part
                            
                            TextViewExtract(text: "Bill", color: greyColor, fontSize: subFontSize)
                            
                            Text("$\(partBill, specifier: "%.2f")")
                                .foregroundColor(orangeColor)
                                .font(.system(size: mainFontSize))
                                .fontWeight(.bold)
                        }
                        
                        VStack(spacing: 8){
                            // Display of the Tip Part
                            TextViewExtract(text: "Tip", color: greyColor, fontSize: subFontSize)
                            
                            Text("$\(partTip, specifier: "%.2f")")
                                .foregroundColor(orangeColor)
                                .font(.system(size: mainFontSize))
                                .fontWeight(.bold)
                        }
                    }
                }.padding(.top, 70)
                    .padding(.bottom, 170)
            }
            
        }
    }
    
    /*
     * Calculate the different items to show with the information given
     * by the user
     */
    func updateNumbers() {
        let totalDouble = Double(total)!
        let tipAmount = totalDouble * tip / 100
        let totalTipped = totalDouble + tipAmount
        
        totalPerPerson = totalTipped / splitNumber
        partTip = tipAmount / splitNumber
        partBill = totalDouble / splitNumber
    }
    
    /*
     * Allow to build the message to pass through the ShareLink(),
     * when the user press the share button
     */
    func createMessage() -> String {
        let message = "Bill Amount: $\(total)\nTip Amount: \(tip)%\nSplit:\(splitNumber)\nTotal per person: $\(totalPerPerson)"
        print(message)
        return message
    }
}
/*
 * Allow less repetition of code by showing a basic Text() item with a color
 * a font size and a text
 */
struct TextViewExtract: View {
    let text: String
    let color: Color
    let fontSize: Double
    
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .font(.system(size: fontSize))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
