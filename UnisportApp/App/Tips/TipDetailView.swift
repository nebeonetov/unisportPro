//
//  TipDetailView.swift
//  UnisportApp
//
//  Created by D K on 16.04.2025.
//

import SwiftUI

struct TipDetailView: View {
    let tip: Tip // Use Tip model
    @Binding var showDetail: Bool
    let namespace: Namespace.ID

    //MARK: - Colors
    private let detailBackgroundColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    private let secondaryTextColor = Color.gray

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) { // Use spacing 0

                 //MARK: - Image Placeholder
                Image(tip.contentImagePlaceholder)
                    .resizable()
                    .scaledToFill()
                     .frame(height: 250) // Larger image
                     .clipped()
                      // ---> Matched Geometry ID for Image <---
                      .matchedGeometryEffect(id: "\(tip.id)_image", in: namespace)
                      .ignoresSafeArea(edges: .top)


                 //MARK: - Content Area
                 VStack(alignment: .leading, spacing: 15) {
                    


                      // Title & Subtitle
                      Text(tip.title).font(.title).fontWeight(.bold).foregroundColor(.white)
                      Text(tip.subtitle).font(.callout).foregroundColor(secondaryTextColor)

                      Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1).padding(.vertical, 10)

                      // Detailed Content
                      Text(tip.detailedContent)
                          .font(.body).foregroundColor(.white.opacity(0.85)).lineSpacing(5)

                      Spacer()
                 }
                 .padding() // Padding for text content
                 .padding(.bottom, 60)

            } // End Main VStack
        } // End ScrollView
         .background(detailBackgroundColor.ignoresSafeArea()) // BG for ScrollView
         // ---> Matched Geometry ID for Card Background <---
         .background(
              Rectangle().fill(detailBackgroundColor) // Match shape and color
                  .matchedGeometryEffect(id: "\(tip.id)_card", in: namespace)
                  .ignoresSafeArea()
         )
        .overlay(alignment: .topTrailing) { // Close Button
            VStack {
                Button {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        showDetail = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .shadow(radius: 1)
                        .shadow(radius: 1)
                        .shadow(radius: 1)
                }
                .padding()
                Spacer()
            }
        }
         .preferredColorScheme(.dark)
         .statusBar(hidden: true)
    }
}
