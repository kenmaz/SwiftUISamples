//
//  ViewModel.swift
//  CoreDataStringArraySample
//
//  Created by kenmaz on 2020/07/14.
//  Copyright © 2020 kenmaz.net. All rights reserved.
//

import UIKit
import CoreData
import SwiftUI

class ViewModel: ObservableObject {

    @Published var books: [BookItem] = []

    struct BookItem: Identifiable {
        var id: String { String(describing: objectId) }
        let objectId: NSManagedObjectID
        let title: String
        let comments: [String]

        var joinedComment: String {
            comments.joined(separator: "\n")
        }
    }

    func fetchBooks() {
        do {
            if let books = try container.viewContext.fetch(Book.fetchRequest()) as? [Book] {
                self.books = books.map {
                    BookItem(
                        objectId: $0.objectID,
                        title: $0.title ?? "",
                        comments: $0.comments ?? []
                    )
                }
            } else {
                print("no books")
            }
        } catch {
            print(error)
        }
    }

    func addBook() {
        container.performBackgroundTask { [weak self] context in
            let book = Book(context: context)
            book.title = "New Book"
            do {
                try context.save()
                DispatchQueue.main.async {
                    self?.fetchBooks()
                }
            } catch {
                print(error)
            }
        }
    }

    func addComment(to item: BookItem) {
        let comment = "Good!"
        let id = item.objectId
        container.performBackgroundTask { [weak self] context in
            do {
                guard let book = try context.existingObject(with: id) as? Book else { return }
                var comments = book.comments ?? []
                comments.append(comment)
                book.comments = comments
                try context.save()
                DispatchQueue.main.async {
                    self?.fetchBooks()
                }
            } catch {
                print(error)
            }
        }
    }

    private var container: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
}
