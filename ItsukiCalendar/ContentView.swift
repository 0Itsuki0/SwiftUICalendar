//
//  ContentView.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/06.
//

import SwiftUI

struct ContentView: View {

    @State private var presentPopup = false

    var body: some View {
        let transition: AnyTransition = .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top))
        VStack {
//            if !presentPopup {
                Button {
                    withAnimation(.linear(duration: 1)) {
                        presentPopup = true
                    }
                } label: {
                    Text("Present Pop-up")
                        .frame(height: presentPopup ? 0 : 100)

                }
//                .frame(height: 0)

//                .transition(transition)
            

//            }
            
//            VStack{
//                Text("other text")
//
//                ZStack  {
//                    Text("other text")
                    if presentPopup {
                        Popup(isPresented: $presentPopup, dismissOnTapOutside: true) {
                            Text("something")
                        }
                        .padding(.horizontal, UIScreen.main.bounds.size.width)
//                        .padding(.vertical, UIScreen.main.bounds.size.height)
                        .transition(transition)

                    }
            
            Text("conents to the right")
//                }
// 
//                
//            }
//            .frame(width: 100, height: 100)


            
//            Button {
//                withAnimation {
//                    shouldPresentPopUpDialog = true
//                }
//            } label: {
//                Text("Present Pop-up Dialog")
//            }
        }
    }
}

#Preview {
    ContentView()
}
