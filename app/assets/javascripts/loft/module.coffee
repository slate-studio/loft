# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
#
# Coding Guide:
#   https://github.com/thoughtbot/guides/tree/master/style/coffeescript
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Loft
# -----------------------------------------------------------------------------
#
# Public methods:
#   new Loft(title, resource, resourcePath, @arrayStoreClass, @arrayStoreConfig)
#   showModal(assetType, @selectMultipleAssets, @onAcceptCallback)
#   closeModal()
#
# -----------------------------------------------------------------------------
class @Loft
  constructor: (title, resource, resourcePath, @arrayStoreClass, @arrayStoreConfig) ->
    @module = {}
    @store  = {}

    @arrayStoreClass  ?= RailsArrayStore
    @arrayStoreConfig ?=
      resource:    resource
      path:        resourcePath
      sortBy:      'created_at'
      sortReverse: true
      searchable:  true

    @_uploadsCounter = 0

    moduleConfig =
      title:                title
      showNestedListsAside: true
      items:
        loft_all:      @_nested_list_config 'All'
        loft_images:   @_nested_list_config 'Images',   'image'
        loft_text:     @_nested_list_config 'Text',     'text'
        loft_archives: @_nested_list_config 'Archives', 'archive'
        loft_audio:    @_nested_list_config 'Audio',    'audio'
        loft_video:    @_nested_list_config 'Video',    'video'
        loft_other:    @_nested_list_config 'Other',    'other'

      onModuleInit: (module) =>
        @_initialize_module(module)

    return moduleConfig


  # PRIVATE ===============================================

  _initialize_module: (module) ->
    @module = module
    @store  = @module.nestedLists.loft_all.config.arrayStore

    # API method
    @module.showModal = (assetType, selectMultipleAssets, callback) =>
      @showModal(assetType, selectMultipleAssets, callback)
    @selectMultipleAssets = true

    # modal close button
    @module.rootList.$modalCloseBtn =$ "<a href='#' class='modal-close'>Cancel</a>"
    @module.rootList.$header.prepend @module.rootList.$modalCloseBtn
    @module.rootList.$modalCloseBtn.on 'click', (e) => e.preventDefault() ; @closeModal()

    # modal types navigation
    @module.rootList.$items.on 'click', 'a', (e) =>
      if @module.$el.hasClass 'module-modal'
        e.preventDefault()

        $item    = $(e.currentTarget)
        listName = $item.attr('href').split('/')[2]

        @module.activeList.hide()
        @module.showList(listName)
        @module.activeList.updateItems()

        $item.parent().children('.active').removeClass('active')
        $item.addClass('active')

    # enable grid mode as default on desktop/tablet
    if ! chr.isMobile()
      @module.$el.addClass('grid-mode')


  _nested_list_config: (moduleName, assetType) ->
    storeConfig = {}
    $.extend(storeConfig, @arrayStoreConfig)

    if assetType
      $.extend(storeConfig, { urlParams: { by_type:  assetType } })

    config =
      title:              moduleName
      itemTitleField:     'name'
      itemSubtitleField:  'created_ago'
      showWithParent:     true
      itemClass:          LoftAssetItem
      arrayStore:         new @arrayStoreClass(storeConfig)
      onListInit: (list) => @_inititialize_list(list)
      onListShow: (list) => @_clear_assets_selection()

    return config


  _inititialize_list: (list) ->
    # file input button for uploading new files
    list.$uploadInput =$ "<input class='asset-upload' type='file' multiple='multiple' />"
    list.$search.before list.$uploadInput

    # file upload handler
    list.$uploadInput.on 'change', (e) =>
      files = e.target.files
      if files.length > 0
        @_upload(file, list) for file in files

    # group actions toolbar
    list.groupActions = new LoftGroupActions(list, this)

    # grid/list checkbox
    list.$switchMode =$ "<a class='assets-switch-mode' href='#'></a>"
    list.$backBtn.after list.$switchMode
    list.$switchMode.on 'click', (e) => e.preventDefault() ; @module.$el.toggleClass('grid-mode')

    # modal back for mobiles
    list.$header.on 'click', '.back', (e) =>
      if @module.$el.hasClass 'module-modal'
        e.preventDefault()
        @module.showList()


  _upload: (file, list) ->
    obj = {}
    obj["__FILE__[file]"] = file

    @_start_file_upload()
    @store.push obj,
      onSuccess: (object) => @_finish_file_upload(list)
      onError:   (errors) =>
        @_finish_file_upload(list)
        chr.showError('Can\'t upload file.')


  _start_file_upload: ->
    @_uploadsCounter += 1
    @module.$el.addClass('assets-uploading')


  _finish_file_upload: (list) ->
    @_uploadsCounter -= 1
    if @_uploadsCounter == 0
      @module.$el.removeClass('assets-uploading')

      # update data in list if it's not loft_all,
      # in loft_all new objects are added automatically
      if @module.activeList.name != 'loft_all'
        @module.activeList.updateItems()


  _clear_assets_selection: ->
    for name, list of @module.nestedLists
      list.groupActions.hide()
      list.$items.find('.asset-checkbox').prop('checked', false)


  # PUBLIC ================================================

  closeModal: ->
    @selectMultipleAssets = true
    @_clear_assets_selection()
    @module.$el.removeClass('module-modal')
    @module.hide()


  # chr.modules.assets.showModal()
  showModal: (assetType='all', @selectMultipleAssets=false, @onAcceptCallback=$.noop) ->
    # modal mode
    @module.$el.addClass('module-modal')
    # show module
    @module.show()
    # show nested list
    @module.showList("loft_#{ assetType }")
    @module.activeList.updateItems()
    # select active item
    @module.rootList.$items.children().removeClass('active')
    @module.rootList.$items.children("[href='#/loft/loft_#{ assetType }']").addClass('active')





