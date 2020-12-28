//
//  ContentView.swift
//  BillSpliter
//
//  Created by Maxim Macari on 27/12/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    //Total amount
    @State var bill : CGFloat = 75
    @State var payers = [
        Payer(image: "person", name: "Andy", bgColor: Color.green),
        Payer(image: "person", name: "Cody", bgColor: Color.blue),
        Payer(image: "person", name: "Steve", bgColor: Color.gray)
    ]
    //temp offset
    @State var pay = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                HStack{
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color.red)
                            .padding()
                            .background(Color.black.opacity(0.25))
                            .cornerRadius(15)
                    })
                    
                    Spacer()
                    
                }
                .padding()
                
                
                VStack(spacing: 15){
                    Button(action: {
                        
                    }, label: {
                        Text("Receipt")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.purple.opacity(0.5))
                            .cornerRadius(12)
                    })
                    
                    //Dotted lines
                    Line()
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter, dash: [10]))
                        .frame(height: 1)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    HStack{
                        VStack(alignment: .leading, spacing: 12, content: {
                            Text("Title")
                                .font(.caption)
                            
                            Text("Team Dinner")
                                .font(.title2)
                                .fontWeight(.heavy)
                        })
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 12, content: {
                            Text("Totol bill")
                                .font(.caption)
                            
                            Text("€ \(String(format: "%.2f", bill))")
                                .font(.title2)
                                .fontWeight(.heavy)
                        })
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                    }
                    
                    VStack {
                        HStack(spacing: -20){
                            ForEach(payers){ payer in
                                Image(systemName: payer.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .padding(8)
                                    .background(payer.bgColor)
                                    .clipShape(Circle())
                            }
                        }
                        
                        Text("Spliting with")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.5))
                    .cornerRadius(25)
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    Color.red.clipShape(BillShape())
                        .cornerRadius(25)
                )
                .padding(.horizontal)
                
                //CUstom slider
               
                
                    ForEach(payers.indices) { index in
                        PriceView(payer: $payers[index], totalAmount: bill)
                    }
                
                
                
                Spacer(minLength: 25)
                //pay buton
                HStack{
                    HStack(spacing: 0){
                        ForEach(1...6, id: \.self){ index in
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(Color.white.opacity(Double(index) * 0.06))
                        }
                    }
                    .padding(.leading, 45)
                    
                    Spacer()
                    
                    Button(action: {
                        pay.toggle()
                    }, label: {
                        Text("Confirm Split")
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .foregroundColor(.white)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 10)
                            .background(Color.purple.opacity(0.6))
                            .clipShape(Capsule())
                    })
                }
                .padding()
                .background(
                    Color.black.opacity(0.25)
                )
                .clipShape(Capsule())
                .padding(.horizontal)
            }
            
            Spacer(minLength: 20)
            
        }
        .background(
            Color.purple.opacity(0.5)
                .ignoresSafeArea(.all, edges: .all)
        )
        .alert(isPresented: $pay, content: {
            Alert(title: Text("Alert"), message: Text("Confirm to split pay?"), primaryButton: .default(Text("Pay"), action: {
                //Do someting here
            }), secondaryButton: .destructive(Text("Cancel"), action: {
                //on cancel
            }))
        })
    }
}

//Price splitiing view

struct PriceView: View {
    
    @Binding var payer: Payer
    var totalAmount: CGFloat
    
    var body: some View {
        VStack(spacing: 15){
            
            HStack{
                Image(systemName: payer.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .padding(8)
                    .background(payer.bgColor)
                    .clipShape(Circle())
                
                Text(payer.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("€ \(getPrice(value: totalAmount))")
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
            }
            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
                Capsule()
                    .fill(Color.black.opacity(0.25))
                    .frame(height: 30)
                
                Capsule()
                    .fill(payer.bgColor)
                    .frame(width: payer.offset + 20, height: 30)
                
                //Dots
                HStack(spacing: (UIScreen.main.bounds.width - 100) / 12){
                    ForEach(0..<12, id: \.self){ index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: index % 4 == 0 ? 7 : 4, height: index % 4 == 0 ? 7 : 4)
                    }
                }
                .padding(.leading)
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 35, height: 35)
                    .background(Circle().stroke(Color.white, lineWidth: 5))
                    .offset(x: payer.offset)
                    .gesture(
                        DragGesture().onChanged({ (value) in
                            
                            
                            //limit
                            //Padding horizontal = 30
                            //Circlee radius = 20
                            //Total = 50
                            if value.location.x >= 20 && value.location.x <= UIScreen.main.bounds.width - 50 {
                                //Circle radius = 20
                                payer.offset = value.location.x - 20
                            }
                        })
                    )
            })
            
            
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }
    
    //Calculating pricee
    func getPrice(value: CGFloat) -> String {
        
        let percent = payer.offset / (UIScreen.main.bounds.width - 70)
        
        let amount = percent * (totalAmount / 3)
        
        return String(format: "%.2f", amount)
    }
}


//Lines shape
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}

//Custom bill card shape
struct BillShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
            path.move(to: CGPoint(x: 0, y: 80))
            path.addArc(center: CGPoint(x: 0, y: 80), radius: 20, startAngle: .init(degrees: -90), endAngle: .init(degrees: 90), clockwise: false)
            
            path.move(to: CGPoint(x: rect.width, y: 80))
            path.addArc(center: CGPoint(x: rect.width, y: 80), radius: 20, startAngle: .init(degrees: 90), endAngle: .init(degrees: -90), clockwise: false)
            
        }
    }
}


//sample data
struct Payer: Identifiable {
    
    var id = UUID().uuidString
    var image: String
    var name: String
    var bgColor: Color
    
    //Offset for curstom progressview
    var offset: CGFloat = 0
    
}

