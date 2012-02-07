(($) ->

  unless $().jquery >= '1.6'
    throw 'ajaxsubmit.js require jQuery >= 1.6.0'

  $.errors =
    attribute: "validate"
    activationClass: "error"
    format: "<div class='validation'><div class='validation-message'></div><div class='arrow'></div></div>"
    messageClass: "validation-message"

  applyValidationMessage = (div, message) ->
    unless div.hasClass($.errors.activationClass)
      div.addClass $.errors.activationClass
      message_div = div.find(".#{$.errors.messageClass}")
      if message_div.size() == 0
        div.append($.errors.format)
      message_div = div.find(".#{$.errors.messageClass}")
      if message_div.size() > 0
        message_div.html(message)
      else
        throw new Error(
          "configuration error: $.errors.format must have elment with class #{$.errors.messageClass}"
        )

  applyValidation = (form, field, message) ->
    div = form.find("[#{$.errors.attribute}~='#{field}']")
    if div.size() == 0
      div = $("<div #{$.errors.attribute}='#{field}'></div>")
      form.prepend(div)
    applyValidationMessage(div, message)


  $.fn.applyErrors = (errors) ->
    form = $(@)
    $(@).clearErrors()
    if $.type(errors) == "object"
      errors = $.map errors, (v,k) -> [[k,v]]
    $(errors).each (key, error) ->
      field = error[0]
      message = error[1]
      message = message[0] if $.isArray(message)
      applyValidation(form, field, message)

  $.fn.clearErrors = ->
    validators = $(@).find("[#{$.errors.attribute}]")
    validators.removeClass $.errors.activationClass

)(jQuery)
