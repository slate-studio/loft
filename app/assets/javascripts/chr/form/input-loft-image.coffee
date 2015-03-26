# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
#
# Coding Guide:
#   https://github.com/thoughtbot/guides/tree/master/style/coffeescript
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# INPUT LOFT IMAGE
# -----------------------------------------------------------------------------
class @InputLoftImage extends InputString
  _addInput: ->
    @config.placeholder ?= 'Image url'

    @$input =$ "<input type='string' name='#{ @name }' value='#{ @_valueSafe() }' id='#{ @name }' />"
    @$el.append @$input

    @_add_image()
    @_add_choose_button()
    @_add_remove_button()
    @_update_input_class()


  _add_image: ->
    @$image =$ "<a href='' target='_blank' class='image'><img src='' /></a>"
    @$el.append @$image
    @_update_image()


  _add_choose_button: ->
    @$chooseBtn =$ "<a href='#' class='choose'></a><br/>"
    @$el.append @$chooseBtn

    @_update_choose_button_title()

    @$chooseBtn.on 'click', (e) =>
      e.preventDefault()
      chr.modules.assets.showModal 'images', false, (objects) =>
        asset = objects[0]
        @updateValue(asset.file.url)


  _add_remove_button: ->
    @$removeBtn =$ "<a href='#' class='remove'>Remove</a>"
    @$el.append @$removeBtn

    @$removeBtn.on 'click', (e) =>
      e.preventDefault()
      if confirm('Are you sure?')
        @updateValue('')


  _update_image: ->
    url = @value
    @$image.attr('href', @value).children().attr('src', @value)
    if @value == '' then @$image.hide() else @$image.show()


  _update_choose_button_title: ->
    title = if @value == '' then 'Choose or upload' else 'Choose other or upload'
    @$chooseBtn.html(title)


  _update_input_class: ->
    if @value == '' then @$el.removeClass('has-value') else @$el.addClass('has-value')


  #
  # PUBLIC
  #

  updateValue: (@value) ->
    @$input.val(@value)

    @_update_image()
    @_update_choose_button_title()
    @_update_input_class()


_chrFormInputs['loft-image'] = InputLoftImage




