//
//  ViewController.swift
//  TextFieldDebounce
//
//  Created by Min-Su Kim on 2022/09/09.
//

import UIKit
import Combine

final class ViewController: UIViewController {
  
  lazy var stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.distribution = .fill
  }
  
  lazy var textField = UITextField().then {
    $0.borderStyle = .roundedRect
  }
  
  lazy var explainLabel = UILabel().then {
    $0.text = "아래의 텍스트로 검색합니다."
    $0.textColor = .systemGray
    $0.font = .systemFont(ofSize: 12, weight: .medium)
  }
  
  lazy var searchLabel = UILabel()
  
  var viewModel: ViewModel!
  var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = ViewModel()
    
    setView()
    setConstraint()
    bind()
  }
  
  private func bind() {
    textField.textDidChange
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .sink { text in
        self.viewModel.text = text
      }
      .store(in: &subscriptions)
    
    viewModel.$text
      .sink { text in
        if text.isEmpty {
          self.searchLabel.text = "입력 대기중 입니다."
        } else {
          self.searchLabel.text = "\"\(text)\""
        }
      }
      .store(in: &subscriptions)
  }
}


// MARK: - UI
extension ViewController {
  private func setView() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(stackView)
    
    stackView.addArrangedSubview(textField)
    stackView.addArrangedSubview(explainLabel)
    stackView.addArrangedSubview(searchLabel)
  }
  
  private func setConstraint() {
    stackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.trailing.equalToSuperview().offset(-24)
      make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(24)
    }
  }
}

