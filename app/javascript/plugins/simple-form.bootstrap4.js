import $ from 'jquery'
import ClientSideValidations from '@client-side-validations/client-side-validations'

ClientSideValidations.formBuilders['SimpleForm::FormBuilder'] = {
  add: function (element, settings, message) {
    this.wrapper(settings.wrapper).add.call(this, element, settings, message)
  },
  remove: function (element, settings) {
    this.wrapper(settings.wrapper).remove.call(this, element, settings)
  },
  wrapper: function (name) {
    return this.wrappers[name] || this.wrappers.default
  },

  wrappers: {
    default: {
      add (element, settings, message) {
        const wrapperElement = element.parent()
        let errorElement = wrapperElement.find(settings.error_tag + '.invalid-feedback')

        if (!errorElement.length) {
          errorElement = $('<' + settings.error_tag + '>', { class: 'invalid-feedback', text: message })
          wrapperElement.append(errorElement)
        }

        wrapperElement.addClass(settings.wrapper_error_class)
        element.addClass('is-invalid')
        errorElement.text(`${wrapperElement.find('label').clone().children().remove().end().text()  } ${message}`)
      },

      remove (element, settings) {
        const wrapperElement = element.parent()
        const errorElement = wrapperElement.find(settings.error_tag + '.invalid-feedback')

        wrapperElement.removeClass(settings.wrapper_error_class)
        element.removeClass('is-invalid')
        errorElement.remove()
      }
    }
  }
}
