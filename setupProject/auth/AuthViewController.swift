
import UIKit

final class AuthViewController: UIViewController {
    
    private let oauth2service = OAuth2Service.shared
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == ShowWebViewSegueIdentifier {
                guard
                    let webViewViewController = segue.destination as? WebViewController
                else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
                webViewViewController.delegate = self
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }

    // MARK: - Extension

    extension AuthViewController: WebViewControllerDelegate {
        func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
            OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                case .failure:
                    break
                }
            }
        }

        func webViewViewControllerDidCancel(_ vc: WebViewController) {
            dismiss(animated: true)
        }
    }
