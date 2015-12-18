# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
# -----------------------------------------------------------------------------
# Loft Asset Item
# -----------------------------------------------------------------------------
class @LoftAssetItem extends Item
  constructor: (@module, @path, @object, @config) ->
    @$el =$ "<div class='item asset asset-#{ @object.type }' data-id='#{ @object._id }'></div>"
    @render()

  # PRIVATE ===================================================================

  _bind_name_input: ->
    @$nameInput.on 'blur',  (e) => @_update_name_if_changed()
    @$nameInput.on 'keyup', (e) =>
      if e.keyCode == 13 then $(e.target).blur()
      if e.keyCode == 27 then @_cancel_name_change()

  _edit_name: (e) ->
    @$el.addClass('edit-name')
    @$nameInput.focus().select()

  _cancel_name_change: ->
    @$el.removeClass('edit-name')
    name = @$title.html()
    @$nameInput.val(name)

  _update_name_if_changed: ->
    @$el.removeClass('edit-name')
    name = @$nameInput.val()

    if name == @$title.html() then return
    @$title.html(name)

    @config.arrayStore.update @object._id, { '[name]': name },
      onSuccess: (object) =>
      onError:   (errors) => # process errors

  # PUBLIC ====================================================================

  render: ->
    @$el.html('').removeClass('item-folder has-subtitle has-thumbnail')

    @_render_title()
    @_render_subtitle()

    # asset icon with link
    @$link =$ "<a class='asset-icon' href='#{ @object.file.url }' target='_blank'></a>"
    @$el.prepend(@$link)

    # thumbnail for images
    if @object.type == 'image' && @object.grid_item_thumbnail != ''
      @$thumbnailSmall  =$ "<img class='asset-thumbnail-small'  src='#{ @object._list_item_thumbnail.small  }' />"
      @$thumbnailMedium =$ "<img class='asset-thumbnail-medium' src='#{ @object._list_item_thumbnail.medium }' />"
      @$link.append @$thumbnailSmall
      @$link.append @$thumbnailMedium

    # checkbox for item selection
    @$checkbox      =$ "<div class='asset-checkbox'></div>"
    @$checkboxInput =$ "<input type='checkbox' />"
    @$checkbox.append(@$checkboxInput)
    @$el.prepend(@$checkbox)

    # input for assets name
    name = @$title.text()
    @$name      =$ "<div class='asset-name'></div>"
    @$nameInput =$ "<input type='text' value='#{ name }' />"
    @$name.append @$nameInput
    @$title.before @$name
    @_bind_name_input()

    # handler for asset name change on title click
    @$title.on 'click', (e) => @_edit_name(e)
