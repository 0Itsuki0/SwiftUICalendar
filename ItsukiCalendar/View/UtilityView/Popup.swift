//
//  Popup.swift
//  ItsukiCalendar
//
//  Created by Itsuki on 2024/04/13.
//

import SwiftUI


struct Popup<Content: View>: View {

    @Binding var isPresented: Bool
    let content: Content
    let dismissOnTapOutside: Bool
    let contentSize: CGSize
    let animationDuration: Double

    var body: some View {

        ZStack {

            Rectangle()
                .fill(.gray.opacity(0.7))
                .ignoresSafeArea()
                .onTapGesture {
                    if dismissOnTapOutside {
                        withAnimation(.linear(duration: animationDuration)) {
                            isPresented = false
                        }
                    }
                }

            content
                .frame(width: contentSize.width, height: contentSize.height, alignment: .center)
                .padding()
                .background(.white)
                .cornerRadius(12)
        }
        .ignoresSafeArea(.all)
        .frame(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height,
            alignment: .center
        )
    }
        
}

extension Popup {
    // full screen
    init(isPresented: Binding<Bool>,
         animationDuration: Double = 0.2,
         @ViewBuilder _ content: () -> Content) {
        
        _isPresented = isPresented
        self.dismissOnTapOutside = false
        self.animationDuration = animationDuration
        self.contentSize = CGSize(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height)
        self.content = content()
        
    }
    
    // dialog
    init(isPresented: Binding<Bool>,
         animationDuration: Double = 0.2,
         dismissOnTapOutside: Bool = true,
         contentWidth: CGFloat = UIScreen.main.bounds.size.width - 100,
         contentHeight: CGFloat = 300,
         @ViewBuilder _ content: () -> Content) {
        
        _isPresented = isPresented
        self.dismissOnTapOutside = dismissOnTapOutside
        self.animationDuration = animationDuration
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        self.content = content()
        
    }
}


#Preview {
    @State var isPresented = true
    return Popup(isPresented: $isPresented, dismissOnTapOutside: true) {
        Text("pop up")
    }
}
