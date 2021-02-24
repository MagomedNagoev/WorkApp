import UIKit

class OrderView: UIView {
    

    let picker = UIPickerView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
        hideKeyboardOnTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let titleLB = UILabel(text: "Название задачи", font: .systemFont(ofSize: 15))
    let titleTF = UITextField(backgroundColor: .buttonWhite(),
                              cornerRadius: 4,
                              placeholder: "Введите значение")
    
    let descTV = UITextView()
    
    let costLB = UILabel(text: "Цена заказа", font: .systemFont(ofSize: 15))
    let costTF = UITextField(backgroundColor: .buttonWhite(), cornerRadius: 4, placeholder: "Введите сумму")
    let categoryLB = UILabel(text: "Название категории", font: .systemFont(ofSize: 15))
    let categoryTF = UITextField(backgroundColor: .buttonWhite(),
                              cornerRadius: 4,
                              placeholder: "Выберите категорию")
    let saveButton = UIButton(title: "Сохранить", backgroundColor: .buttonBlue(), cornerRadius: 4, tintColor: .white)
    



    func hideKeyboardOnTap()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(OrderView.dismissKeyboard))

        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        self.endEditing(true)
    }

    
    func viewConfig() {
        costTF.keyboardType = .numberPad
        self.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        categoryTF.inputView = picker
        descTV.backgroundColor = .buttonWhite()
        descTV.font = .systemFont(ofSize: 17)
        let stack = UIStackView(arrangedSubviews: [titleLB,titleTF,categoryLB,categoryTF, costLB,costTF], axis: .vertical, spacing: 0)
        Helper.addSubviews(superView: self, subViews: [stack, descTV,saveButton])
        Helper.tamicOff(views: [titleTF, descTV, costTF, saveButton, stack])
        
        NSLayoutConstraint.activate([stack.topAnchor.constraint(equalTo: topAnchor, constant: 80),
                                     stack.bottomAnchor.constraint(equalTo: descTV.topAnchor, constant: -16),
                                     stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                                     stack.centerXAnchor.constraint(equalTo: centerXAnchor)])
        NSLayoutConstraint.activate([titleLB.heightAnchor.constraint(equalToConstant: 25)])
        NSLayoutConstraint.activate([categoryLB.heightAnchor.constraint(equalToConstant: 25)])
        NSLayoutConstraint.activate([costLB.heightAnchor.constraint(equalToConstant: 25)])
        
        NSLayoutConstraint.activate([titleTF.heightAnchor.constraint(equalToConstant: 40)])
        NSLayoutConstraint.activate([categoryTF.heightAnchor.constraint(equalToConstant: 40)])
        NSLayoutConstraint.activate([costTF.heightAnchor.constraint(equalToConstant: 40)])
        NSLayoutConstraint.activate([saveButton.heightAnchor.constraint(equalToConstant: 50)])
        NSLayoutConstraint.activate([descTV.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16),
                                     descTV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                                     descTV.centerXAnchor.constraint(equalTo: centerXAnchor)])
        
        NSLayoutConstraint.activate([saveButton.topAnchor.constraint(equalTo: descTV.bottomAnchor, constant: 16),
                                     saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -85),
                                     saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                                     saveButton.centerXAnchor.constraint(equalTo: centerXAnchor)])
    
    }
    

}

extension OrderView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category.allCases[row].rawValue
//        return startViewModel.words[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTF.text = Category.allCases[row].rawValue
    }
    
}
