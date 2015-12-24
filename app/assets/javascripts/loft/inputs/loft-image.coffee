# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
# -----------------------------------------------------------------------------
# INPUT LOFT IMAGE
# -----------------------------------------------------------------------------
class @InputLoftImage extends InputString

  # PRIVATE ===================================================================

  _add_input: ->
    @config.placeholder ?= 'Image URL'

    type = "string"
    if @config.fullsizePreview
      @$el.addClass "fullsize-preview"
      type = "hidden"

    @$input =$ """<input type='#{type}'
                         name='#{ @name }'
                         value='#{ @_safe_value() }'
                         id='#{ @name }' />"""
    @$el.append @$input
    @$input.on 'change', (e) =>
      @updateValue($(e.target).val())

    if @config.fullsizePreview
      @_update_preview_background()
    else
      @_add_image()
      @_update_image()

    @_add_actions()
    @_update_input_class()

  _add_image: ->
    @$image =$ "<a href='' target='_blank' class='image'><img src='' /></a>"
    @$el.append @$image

  _add_actions: ->
    @$actions =$ "<span class='input-actions'></span>"
    @$label.append @$actions

    @_add_choose_button()
    @_add_remove_button()

  _add_choose_button: ->
    @$chooseBtn =$ "<button class='choose'>#{Icons.upload}</button>"
    @$actions.append @$chooseBtn

    @$chooseBtn.on 'click', (e) =>
      chr.modules.loft.showImages false, (objects) =>
        asset = objects[0]
        @updateValue(asset.file.url)

  _add_remove_button: ->
    @$removeBtn =$ "<button class='remove'>#{Icons.remove}</button>"
    @$actions.append @$removeBtn

    @$removeBtn.on 'click', (e) =>
      if confirm('Are you sure?')
        @updateValue('')

  _update_preview_background: ->
    url = @value
    @$el.css { "background-image": "url(#{url})" }

  _update_image: ->
    url = @value
    @$image.attr('href', url).children().attr('src', url)
    if url == ''
      @$image.hide()
    else
      @$image.show()

  _update_input_class: ->
    if @value == ''
      @$el.removeClass('has-value')
    else
      @$el.addClass('has-value')

  # PUBLIC ====================================================================

  updateValue: (@value) ->
    @$input.val(@value)

    if @config.fullsizePreview
      @_update_preview_background()
    else
      @_update_image()

    @_update_input_class()

chr.formInputs['loft-image'] = InputLoftImage
