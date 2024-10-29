//
//  ViewModel.swift
//  Journal
//
//  Created by Reem on 25/04/1446 AH.
//

import SwiftUI


enum SortOption {
    case bookmark
    case date
}

class JournalViewModel: ObservableObject {
    @Published var sortOption: SortOption = .date
    @Published var searchText = ""
    @Published var journalTitle: String = ""
    @Published var journalDate: String = ""
    @Published var journalDescription: String = ""
    @Published var isShowingAddJournal = false
    @Published var isActive = true
    @Published var isEditing = false
    @Published var journals: [Journals] = []
    @Published var newJournalTitle: String = ""
    @Published var newJournalDescription: String = ""
    @Published var isShowingEditJournal = false
    @Published var journalToEdit: Journals?
    
    let currentDate = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)

    func addJournal() {
        let newJournal = Journals(
            title: newJournalTitle,
            date: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none),
            description: newJournalDescription
        )
        journals.append(newJournal)
        
        // Clear input fields after adding
        newJournalTitle = ""
        newJournalDescription = ""
        
        // Close the add journal sheet
        isShowingAddJournal = false
    }
    
    func editJournal(journal: Journals) {
        journalToEdit = journal
        newJournalTitle = journal.title
        newJournalDescription = journal.description
        isEditing = true
        isShowingAddJournal = true
    }

    func saveEditedJournal() {
        if let journalToEdit = journalToEdit,
           let index = journals.firstIndex(where: { $0.id == journalToEdit.id }) {
            journals[index].title = newJournalTitle
            journals[index].description = newJournalDescription
            
            // Clear input fields after saving
            newJournalTitle = ""
            newJournalDescription = ""
            
            // Close the add journal sheet
            isShowingAddJournal = false
            isEditing = false
            self.journalToEdit = nil
        }
    }
    
    func toggleBookmark(journal: Journals) {
        if let index = journals.firstIndex(where: { $0.id == journal.id }) {
            journals[index].isBookmarked.toggle()
        }
    }
    
    func deleteJournal(journal: Journals) {
        if let index = journals.firstIndex(where: { $0.id == journal.id }) {
            journals.remove(at: index)
        }
    }
    
    var filteredJournals: [Journals] {
        let filteredBySearch = journals.filter {
            searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText)
        }
        
        switch sortOption {
        case .bookmark:
            return filteredBySearch.filter { $0.isBookmarked }
        case .date:
            return filteredBySearch.sorted { $0.date < $1.date }
        }
    }
}
