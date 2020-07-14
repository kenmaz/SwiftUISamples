//
//  ContentView.swift
//  CoreDataStringArraySample
//
//  Created by kenmaz on 2020/07/14.
//  Copyright © 2020 kenmaz.net. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = ViewModel()

    var body: some View {
        NavigationView {
            List(vm.books) { book in
                Button(action: { self.vm.addComment(to: book) }) {
                    VStack(alignment: .leading) {
                        Text(book.title).font(.headline)
                        Text(book.joinedComment)
                    }
                }
            }
            .navigationBarTitle("Books", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: vm.addBook) {
                Text("Add")
            })
        }
        .onAppear(perform: vm.fetchBooks)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
