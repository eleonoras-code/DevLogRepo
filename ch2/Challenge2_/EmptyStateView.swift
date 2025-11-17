//
//  EmptyStateView.swift
//  commit
//
//  Created by Eleonora Persico on 10/11/25.
//

import SwiftUI


struct EmptyStateView: View {
    var title: String = ""
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Everybody starts somewhere")
                .font(.custom( "GeistMono-Regular", size: 15))
                .foregroundStyle(Color.white)
            
            Button(action: action) {
                Text(title)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(red: 0.71, green: 0.996, blue: 0.247))
                            .frame(width: 180, height: 40 )
                    )
            }
            .padding(.bottom, 50)
        }
        
    }
}

#Preview {
    EmptyStateView(
            title: "Log your successes",
            action: {
                print("Button tapped")
            }
        )
    }
