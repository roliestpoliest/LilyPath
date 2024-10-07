//
//  TabBar.swift
//  LilyPath
//
//  Created by Chelsea Nguyen on 10/7/24.
//

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Tabs

    var body: some View {
        ZStack {
            HStack {
                ForEach(Tabs.allCases, id: \.self) { tab in
                    Button(
                        action: {
                            selectedTab = tab
                        },
                        label: {
                            CustomTabItem(
                                icon: tab.icon, title: tab.rawValue,
                                isActive: selectedTab == tab)
                        })
                }
            }
            .padding(5)
        }
        .frame(height: 60)
        .background(Color.lightGreen)
        .cornerRadius(30)
    }

    func CustomTabItem(icon: Icon, title: String, isActive: Bool) -> some View {
        HStack {
            Spacer()

            IconImage(
                icon: icon, height: 25,
                color: isActive ? .white : Color.customBrown)
            if isActive {
                Text(title)
                    .font(Font.tabLabel)
                    .foregroundColor(isActive ? .white : Color.customBrown)
            }

            Spacer()
        }
        .frame(maxHeight: 50)
        .background(isActive ? Color.darkGreen : Color.lightGreen)
        .cornerRadius(35)
    }
}

#Preview {
    TabBar(selectedTab: .constant(.home))
        .padding(30)
        .background(Color.mainBackground)
}
