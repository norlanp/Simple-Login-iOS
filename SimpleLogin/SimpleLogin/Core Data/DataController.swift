//
//  DataController.swift
//  SimpleLogin
//
//  Created by Nhon Nguyen on 07/03/2022.
//

import CoreData
import SimpleLoginPackage

struct DataController {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func update(_ aliases: [Alias]) throws {
        for alias in aliases {
            try LocalAlias.createOrUpdate(from: alias, with: context)
        }
        try context.save()
    }

    func update(_ alias: Alias) throws {
        try update([alias])
    }

    func delete(_ alias: Alias) throws {
        let fetchRequest = LocalAlias.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", alias.id)
        if let localAlias = try context.fetch(fetchRequest).first {
            context.delete(localAlias)
        }
        try context.save()
    }

    func reset() throws {
        let localAliases = try context.fetch(LocalAlias.fetchRequest())
        for localAlias in localAliases {
            context.delete(localAlias)
        }

        let localMailboxLites = try context.fetch(LocalMailboxLite.fetchRequest())
        for localMailboxLite in localMailboxLites {
            context.delete(localMailboxLite)
        }

        try context.save()
    }

    func getAllAliases() throws -> [Alias] {
        let localAliases = try context.fetch(LocalAlias.fetchRequest())
        return localAliases.compactMap { Alias(from: $0) }
    }
}
