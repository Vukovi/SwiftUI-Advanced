//
//  23_CustomErrors&Alerts.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 28.11.23.
//

import SwiftUI

protocol AppAlert {
    var title: String { get }
    var subtitle: String? { get }
    var buttons: AnyView { get }
}

extension View {
    func showCustomAlert<T: AppAlert>(error: Binding<T?>) -> some View {
        self
            .alert(
                error.wrappedValue?.title ?? "Error",
                isPresented: Binding(myValue: error)) {
                    error.wrappedValue?.buttons
                } message: {
                    if let subtitle = error.wrappedValue?.subtitle {
                        Text(subtitle)
                    }
                }
    }
}


struct CustomErrorsAlerts: View {
    
    enum MyCustomAlert: Error, AppAlert {
        case noInternetConnection(onOkPressed: () -> ())
        case dataNotFound(onOkPressed: () -> (), onRetryPressed: () -> ())
        case urlError(Error)
        
        var errorDescription: String? {
            switch self {
            case .noInternetConnection:
                return "Plase check your internet connection and try again"
            case .dataNotFound:
                return "There was as error loading data. Please try again!"
            case .urlError(let error):
                return "Error: \(error.localizedDescription)"
            }
        }
        
        var title: String {
            switch self {
            case .noInternetConnection:
                return "No Internet connection"
            case .dataNotFound:
                return "No Data"
            case .urlError(_):
                return "Error"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .noInternetConnection:
                return "Plase check your internet connection and try again"
            case .dataNotFound:
                return nil
            case .urlError(_):
                return "Error"
            }
        }
        
        var buttons: AnyView {
            AnyView(getButtonsForAlert)
        }
        
        @ViewBuilder var getButtonsForAlert: some View {
            switch self {
            case .noInternetConnection(let okPressed):
                Button("OK") {
                    okPressed()
                }
            case .dataNotFound(let okPressed, let retryPressed):
                Button("OK") {
                    okPressed()
                }
                Button("RETRY") {
                    retryPressed()
                }
            default:
                Button("DELETE", role: .destructive) {}
            }
        }
    }
    
    @State private var error: MyCustomAlert?
    
    var body: some View {
        Button("CLICK ME") {
            saveDate()
        }
//        .alert(
//            error?.localizedDescription ?? "Error",
//            isPresented: Binding(myValue: $error)) {
//                error?.getButtonsForAlert
//            } message: {
//                if let subtitle = error?.subtitle {
//                    Text(subtitle)
//                }
//            }
        // UMESTO OVOGA IZNAD
        .showCustomAlert(error: $error)
    }
    
    private func saveDate() {
        let isSuccessful: Bool = false
        
        if isSuccessful {
            
        } else {
            let myError: MyCustomAlert = .noInternetConnection {
                
            }
            let myError2: MyCustomAlert = .dataNotFound {
                
            } onRetryPressed: {
                
            }

            let myError3: MyCustomAlert = .urlError(URLError(.badURL))
            error = myError2
        }
    }
}

#Preview {
    CustomErrorsAlerts()
}
