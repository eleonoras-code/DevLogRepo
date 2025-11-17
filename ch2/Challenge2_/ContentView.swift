//
//  ContentView.swift
//  Challenge2_
//
//  Created by Eleonora Persico on 11/11/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext //used to insert, delete and edit objects > every view that modifies data needs .modelContext
    @Query(sort: \Win.date, order: .reverse) var wins: [Win] //queries are used to filter, search and sort data in the model. + FETCHING = keeps the views updated 
    
    @State private var path = [Win]()
    @State private var winToDelete: Win?
    @State private var showAlertDelete: Bool = false
    @State private var winIdToDelete: PersistentIdentifier?
     
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                (
                    Text("Hello, ")
                        .font(.custom("GeistMono-Regular", size: 24)) +
                    Text("developer 👋")
                        .font(.custom("GeistMono-Bold", size: 24))
                )
                .foregroundStyle(Color(red: 0.71, green: 0.996, blue: 0.247))
                .padding(.leading)
                .padding(.top, 8)
                
                if wins.isEmpty {
                    EmptyStateView(title: "Add Your First Win") {
                        addWin()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    List {
                        ForEach(wins) { win in
                            ZStack {
                                NavigationLink(value: win) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                JournalWinView(win: win)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            winIdToDelete = win.persistentModelID
                                            showAlertDelete = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                        }
                        .alert("Delete this win?", isPresented: $showAlertDelete) {
                            Button("Delete", role: .destructive) {
                                if let id = winIdToDelete,
                                   let win = wins.first(where: { $0.persistentModelID == id }) {
                                    modelContext.delete(win)
                                }
                                winIdToDelete = nil
                            }
                            Button("Cancel", role: .cancel) {
                                winIdToDelete = nil
                            }
                        } message: {
                            Text("Are you sure you want to delete this win?")
                        }
                        
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(for: Win.self) { win in
                AddWinView(win: win)
            }
            .toolbar {
                Button("", systemImage: "plus", action: addWin)
                    .foregroundStyle(Color.accent)
            }
        }
    }
    
    func addWin() {
        let newWin = Win()
        path = [newWin]
        if (!newWin.title.isEmpty) {
            do {
                try? modelContext.save()
            }
        } else {
            print("errore")
        }
    }
    
    func deleteWins(_ indexSet: IndexSet) {
        for index in indexSet {
            let winToDelete = wins[index]
            modelContext.delete(winToDelete)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}


