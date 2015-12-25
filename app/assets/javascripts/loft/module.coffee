# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
# -----------------------------------------------------------------------------
# Loft
# -----------------------------------------------------------------------------
# Public methods:
#   new Loft(title, resource, resourcePath)
#   showAll(@selectMultipleAssets, @onAcceptCallback, @onCloseCallback)
#   showImages(@selectMultipleAssets, @onAcceptCallback, @onCloseCallback)
#   showDocuments(@selectMultipleAssets, @onAcceptCallback, @onCloseCallback)
#   closeModal()
# -----------------------------------------------------------------------------
class @Loft
  constructor: (title="Media", resource="asset", resourcePath="/admin/assets") ->
    @module = {}
    @store  = {}
    @_uploadsCounter = 0

    @title = title
    @menuIcon = "cloud-upload"

    @itemClass = LoftAssetItem
    @arrayStore = new RailsArrayStore
      resource: resource
      path: resourcePath
      sortBy: "created_at"
      sortReverse: true
      searchable:  true

    @listTabs =
      "All": {}
      "Images": { images: true }
      "Documents": { not_images: true }

    @onListInit = (list) =>
      @_add_upload_button(list)
      @_add_group_actions(list)
      @_add_mode_switch(list)

    @onListShow = (list) =>
      @_clear_assets_selection(list)

    @onModuleInit = (module) =>
      @_initialize_module(module)

  # PRIVATE ===================================================================

  _initialize_module: (@module) ->
    @selectMultipleAssets = true
    @store = @module.rootList.config.arrayStore

    @_add_close_button()
    @_enable_grid_mode()

    @module.showAll = $.proxy(@showAll, this)
    @module.showImages = $.proxy(@showImages, this)
    @module.showDocuments = $.proxy(@showDocuments, this)

  _add_close_button: ->
    @module.rootList.$modalCloseBtn =$ """<a href='#' class='modal-close'>
                                            <i class='fa fa-times'></i>
                                          </a>"""
    @module.rootList.$header.prepend @module.rootList.$modalCloseBtn
    @module.rootList.$modalCloseBtn.on "click", (e) =>
      e.preventDefault()
      @closeModal()

  _enable_grid_mode: ->
    if ! chr.isMobile()
      @module.$el.addClass "grid-mode"

  _add_upload_button: (list) ->
    list.$uploadInput =$ "<input class='asset-upload' type='file' multiple='multiple' />"
    list.$search.before list.$uploadInput
    list.$uploadInput.on "change", (e) =>
      files = e.target.files
      if files.length > 0
        @_upload(file, list) for file in files

  _add_group_actions: (list) ->
    list.groupActions = new LoftGroupActions(list, this)

  _add_mode_switch: (list) ->
    list.$switchMode =$ """<a class='assets-switch-mode' href='#'>
                             <i class='fa fa-fw fa-th-large'></i>
                             <i class='fa fa-fw fa-th-list'></i>
                           </a>"""
    list.$backBtn.after list.$switchMode
    list.$switchMode.on 'click', (e) => e.preventDefault() ; @module.$el.toggleClass('grid-mode')

    # # modal back for mobiles
    # list.$header.on 'click', '.back', (e) =>
    #   if @module.$el.hasClass 'module-modal'
    #     e.preventDefault()
    #     @module.showList()

  _upload: (file, list) ->
    obj = {}
    obj["__FILE__[file]"] = file

    @_start_file_upload()
    @store.push obj,
      onSuccess: (object) => @_finish_file_upload(list)
      onError:   (errors) =>
        @_finish_file_upload(list)
        chr.showError("Can't upload file.")

  _start_file_upload: ->
    @_uploadsCounter += 1
    @module.$el.addClass("assets-uploading")

  _finish_file_upload: (list) ->
    @_uploadsCounter -= 1
    if @_uploadsCounter == 0
      @module.$el.removeClass("assets-uploading")

      # update data in list if it's not loft_all,
      # in loft_all new objects are added automatically
      # if @module.activeList.name != 'loft_all'
      #   @module.activeList.updateItems()

  _clear_assets_selection: (list) ->
    list.groupActions.hide()
    list.$items.find(".asset-checkbox").prop("checked", false)

  _show_modal: ($tab) ->
    @module.$el.addClass("module-modal")
    @module.show()
    @module.activeList.selectTab($tab, true)

  # PUBLIC ====================================================================

  showAll: (@selectMultipleAssets=false, @onAcceptCallback=$.noop, @onCloseCallback=$.noop) ->
    @_show_modal(@module.rootList.tabLinks[0])

  showImages: (@selectMultipleAssets=false, @onAcceptCallback=$.noop, @onCloseCallback=$.noop) ->
    @_show_modal(@module.rootList.tabLinks[1])

  showDocuments: (@selectMultipleAssets=false, @onAcceptCallback=$.noop, @onCloseCallback=$.noop) ->
    @_show_modal(@module.rootList.tabLinks[2])

  closeModal: ->
    @selectMultipleAssets = true
    @_clear_assets_selection(@module.activeList)
    @module.$el.removeClass("module-modal")
    @module.hide()
    @onCloseCallback?()
