class @LoftGroupActions
  constructor: (@list, @module) ->
    @_render()
    @_bind_checkboxes()


  _render: ->
    @$el =$ "<div class='assets-group-actions' style='display:none;'></div>"
    @list.$header.append @$el

    @$unselectBtn =$ "<a href='#' class='unselect'>Unselect All</a>"
    @$unselectBtn.on 'click', (e) => e.preventDefault(); @_unselect_list_items()
    @$el.append @$unselectBtn

    @$deleteBtn =$ "<a href='#' class='delete'>Delete Selected</a>"
    @$deleteBtn.on 'click', (e) => e.preventDefault(); @_delete_selected_list_items()
    @$el.append @$deleteBtn


  _bind_checkboxes: ->
    @list.$el.on 'click', '.asset .asset-checkbox', (e) =>
      selectedItems = @_selected_list_items()
      if selectedItems.length > 0
        @_show()
      else
        @_hide()


  _selected_list_items: ->
    @list.$el.find '.asset .asset-checkbox:checked'


  _unselect_list_items: ->
    @list.$el.find('.asset .asset-checkbox').prop('checked', false)
    @_hide()


  _delete_selected_list_items: ->
    if confirm("Are you sure?")
      selectedItems        = @_selected_list_items()
      filesToRemoveCounter = selectedItems.length

      # we have on scroll pagination so after some items are removed,
      # next page request might skip items that replaced removed ones
      for item in selectedItems
        objectId = $(item).parent().attr('data-id')
        @list.config.arrayStore.remove objectId,
          onSuccess: => # success notification
          onError:   => # error notification
      @_hide()


  _show: ->
    @$el.show()


  _hide: ->
    @$el.hide()




