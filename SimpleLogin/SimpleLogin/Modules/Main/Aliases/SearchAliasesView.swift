//
//  SearchAliasesView.swift
//  SimpleLogin
//
//  Created by Thanh-Nhon Nguyen on 14/09/2021.
//

import SwiftUI

struct SearchAliasesView: View {
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Text("Search")
                .navigationBarTitle("Search", displayMode: .inline)
                .navigationBarItems(leading:
                                        Button(action: {
                                            presentationMode.wrappedValue.dismiss()
                                        }, label: {
                                            Text("Close")
                                        }))
        }
        .accentColor(.slPurple)
    }
}

struct SearchAliasesView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAliasesView()
    }
}