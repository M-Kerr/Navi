import QtQuick 2.5
import QtPositioning 5.5

LocaleForm {
    property string locale
    signal selectLanguage(string language)
    signal closeForm()

    goButton.onClicked: {

       if (!languageGroup.current) return

       if (otherRadioButton.checked) {
           selectLanguage(language.text)
       } else {
           selectLanguage(languageGroup.current.text)
       }
    }

    clearButton.onClicked: {
        language.text = ""
    }

    cancelButton.onClicked: {
        closeForm()
    }

    Component.onCompleted: {
        switch (locale) {
            case "en":
                enRadioButton.checked = true;
                break
            case "fr":
                frRadioButton.checked = true;
                break
            default:
                otherRadioButton.checked = true;
                language.text = locale
                break
        }
    }
}
