# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
# -----------------------------------------------------------------------------
# Loft Group Actions
# -----------------------------------------------------------------------------
class @LoftGroupActions
  constructor: (@list, @loft) ->
    @_render()
    @_bind_checkboxes()

  # PRIVATE ===================================================================

  _render: ->
    @$el =$ "<div class='assets-group-actions' style='display:none;'></div>"
    @list.$header.append @$el

    # accept selected
    @$acceptBtn =$ "<a href='#' class='accept'>Accept</a>"
    @$acceptBtn.on 'click', (e) => e.preventDefault(); @_accept_selected_items()
    @$el.append @$acceptBtn

    # delete button
    @$deleteBtn =$ "<a href='#' class='delete'>Delete Selected</a>"
    @$deleteBtn.on 'click', (e) => e.preventDefault(); @_delete_selected_list_items()
    @$el.append @$deleteBtn

    # unselect button
    @$unselectBtn =$ "<a href='#' class='unselect'>Unselect</a>"
    @$unselectBtn.on 'click', (e) => e.preventDefault(); @_unselect_list_items()
    @$el.append @$unselectBtn

  _bind_checkboxes: ->
    @list.$el.on 'click', '.asset .asset-checkbox input', (e) =>
      # when multiple selection disabled select only one asset a time
      if ! @loft.selectMultipleAssets
        @_select_single_item($(e.target))

      selectedItems = @_selected_list_items()
      if selectedItems.length > 0
        @_show()
      else
        @hide()

  _select_single_item: ($checkbox) ->
    if $checkbox.prop('checked')
      @list.$el.find('.asset .asset-checkbox input:checked').prop('checked' , false)
      $checkbox.prop('checked', true)

  _selected_list_items: ->
    $.map @list.$el.find('.asset .asset-checkbox input:checked'), (checkbox) ->
      $(checkbox).parent().parent()

  _unselect_list_items: ->
    @list.$el.find('.asset .asset-checkbox input').prop('checked', false)
    @hide()

  _delete_selected_list_items: ->
    if confirm("Are you sure?")
      $selectedItems       = @_selected_list_items()
      filesToRemoveCounter = $selectedItems.length

      # we have on scroll pagination so after some items are removed,
      # next page request might skip items that replaced removed ones
      for $item in $selectedItems
        objectId = $item.attr('data-id')
        @list.config.arrayStore.remove objectId,
          onSuccess: => # success notification
          onError:   => # error notification
      @hide()

  _accept_selected_items: ->
    $selectedItems  = @_selected_list_items()

    objects = []
    for $item in $selectedItems
      objectId = $item.attr('data-id')
      object   = @list.config.arrayStore.get(objectId)
      objects.push object

    if @loft.closeOnAccept
      @loft.onAcceptCallback(objects)
      @loft.closeModal()

    else
      @loft.onAcceptCallback(objects, => @loft.closeModal())

  _show: ->
    @$el.show()

  # PUBLIC ====================================================================

  hide: ->
    @$el.hide()
