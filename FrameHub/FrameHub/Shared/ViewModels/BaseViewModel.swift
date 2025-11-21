//
//  BaseViewModel.swift
//  FrameHub
//
//  Created by Peter Conijn on 21/11/2025.
//

import Foundation
import Combine

/// Base protocol that all ViewModels should conform to
protocol BaseViewModel: ObservableObject {
    /// Indicates whether the view model is currently loading data
    var isLoading: Bool { get set }

    /// Error message to display to the user, if any
    var errorMessage: String? { get set }
}

/// Default implementations for common ViewModel functionality
extension BaseViewModel {
    /// Handle errors in a consistent way across all ViewModels
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        isLoading = false
    }

    /// Clear any error messages
    func clearError() {
        errorMessage = nil
    }
}
