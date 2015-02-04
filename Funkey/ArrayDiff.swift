import UIKit

enum ArrayDifferenceOperation<T> {
    case Insertion(NSIndexPath)
    case Deletion(NSIndexPath)
    case Move((NSIndexPath, NSIndexPath))
    case Update(NSIndexPath)
}

func differenceBetween<T: Equatable>(# oldArray: [T], andNewArray newArray: [T])
            -> [ArrayDifferenceOperation<T>] {
    let deletedObjects = filter(oldArray) { oldItem in
        return find(newArray, oldItem) == nil
    }
    let insertedObjects = filter(newArray) { newItem in
        return find(oldArray, newItem) == nil
    }
    
    let deletions = deletionsFrom(array: oldArray, withDeletedObjects: deletedObjects)
    let insertions = insertionsFrom(array: newArray, withInsertedObjects: insertedObjects)
    let moves = movesFrom(array: oldArray, toArray: newArray,
                          withDeletedObjects: deletedObjects,
                          insertedObjects: insertedObjects)
                
    var changes = [ArrayDifferenceOperation<T>]()
    changes.extend(deletions)
    changes.extend(insertions)
    changes.extend(moves)
    return changes
}

private func deletionsFrom<T: Equatable>(array oldArray: [T],
                                         withDeletedObjects objects: [T])
                                    -> [ArrayDifferenceOperation<T>] {
    var changes = [ArrayDifferenceOperation<T>]()
    for (i, item) in enumerate(oldArray) {
        if find(objects, item) != nil {
            changes.append(.Deletion(NSIndexPath(forRow: i, inSection: 0)))
        }
    }
    return changes
}

private func insertionsFrom<T: Equatable>(array newArray: [T],
                                          withInsertedObjects objects: [T])
                                    -> [ArrayDifferenceOperation<T>] {
    var changes = [ArrayDifferenceOperation<T>]()
    for (i, item) in enumerate(newArray) {
        if find(objects, item) != nil {
            changes.append(.Insertion(NSIndexPath(forRow: i, inSection: 0)))
        }
    }
    return changes
}

private func movesFrom<T: Equatable>(array oldArray: [T], toArray newArray: [T],
                                     withDeletedObjects deletedObjects: [T],
                                     # insertedObjects: [T])
                                -> [ArrayDifferenceOperation<T>] {
    var delta = 0
    var changes = [ArrayDifferenceOperation<T>]()
    for (oldIndex, oldItem) in enumerate(oldArray) {
        if find(deletedObjects, oldItem) != nil {
            delta++
            continue
        }
        var localDelta = delta
        for (newIndex, newItem) in enumerate(newArray) {
            if find(insertedObjects, newItem) != nil {
                localDelta--
                continue
            }
            if newItem != oldItem {
                continue
            }
            let adjustedIndex = newIndex + localDelta
            if oldIndex != newIndex && adjustedIndex != oldIndex {
                changes.append(.Move((NSIndexPath(forRow: oldIndex, inSection: 0),
                                      NSIndexPath(forRow: newIndex, inSection: 0))))
            } else {
                changes.append(.Update(NSIndexPath(forRow: newIndex, inSection: 0)))
            }
            break
        }
    }
    return changes
}
