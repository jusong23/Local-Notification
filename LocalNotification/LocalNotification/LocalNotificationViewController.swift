import UIKit
import UserNotifications

class LocalNotificationViewController: UIViewController {
    var interval: TimeInterval = 1
    var specificDay = [5,6,7]
    var triggers: [UNCalendarNotificationTrigger] = []
    
    @IBOutlet weak var inputField: UITextField!

    // Local Notification 예약 및 조건(주기, 시간, 위치) 설정
    @IBAction func schedule(_ sender: Any) {
        print("Alarm Request Complete")
        
        // 매주 특정요일 목,금,토(5,6,7) 오전 09시 00분에 반복
        for i in 1...self.specificDay.count {
            self.triggers.append(UNCalendarNotificationTrigger(dateMatching: DateComponents.triggerFor(weekday: specificDay[i-1]), repeats: true))
        }
        
        for trigger in self.triggers {
            // Create the content of the notification
            let content = UNMutableNotificationContent()
            content.title = "My Notification Title"
            content.body = "Body of Notification"

            // Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                  // Handle any errors.
               }
            }
        }
        inputField.text = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 이 화면 시 Badge 수 변경
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension DateComponents {
   static func triggerFor(weekday: Int) -> DateComponents {
      var component = DateComponents()
      component.calendar = Calendar.current
      component.hour = 9
      component.minute = 0
      component.weekday = weekday
      return component
   }
}



extension LocalNotificationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
}

extension LocalNotificationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        interval = TimeInterval(row + 1)
    }
}
