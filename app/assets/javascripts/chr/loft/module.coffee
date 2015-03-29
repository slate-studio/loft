# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
#
# Coding Guide:
#   https://github.com/thoughtbot/guides/tree/master/style/coffeescript
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Loft
# TODO:
#  - back to root list
# -----------------------------------------------------------------------------
class @Loft
  constructor: (title, @resource, @resourcePath) ->
    @module = {}
    @store  = {}

    @_uploadsCounter = 0

    moduleConfig =
      title:                title
      showNestedListsAside: true
      itemClass:            LoftTypeItem
      items:
        assets_all:      @_nested_list_config 'All'
        assets_images:   @_nested_list_config 'Images',   'image'
        assets_text:     @_nested_list_config 'Text',     'text'
        assets_archives: @_nested_list_config 'Archives', 'archive'
        assets_audio:    @_nested_list_config 'Audio',    'audio'
        assets_video:    @_nested_list_config 'Video',    'video'
        assets_other:    @_nested_list_config 'Other',    'other'

      onModuleInit: (module) =>
        @_initialize_module(module)

    return moduleConfig


  _initialize_module: (module) ->
    @module = module
    @store  = @module.nestedLists.assets_all.config.arrayStore

    # API method
    @module.showModal = (assetType, selectMultipleAssets, callback) =>
      @showModal(assetType, selectMultipleAssets, callback)
    @selectMultipleAssets = true

    # modal close button
    @module.rootList.$modalCloseBtn =$ "<a href='#' class='modal-close'>Cancel</a>"
    @module.rootList.$header.prepend @module.rootList.$modalCloseBtn
    @module.rootList.$modalCloseBtn.on 'click', (e) => e.preventDefault() ; @closeModal()

    # grid mode
    @module.$el.addClass('grid-mode')


  _nested_list_config: (moduleName, assetType) ->
    arrayStoreConfig =
      resource:    @resource
      path:        @resourcePath
      searchable:  true
      sortBy:      'created_at'
      sortReverse: true

    if assetType
      $.extend(arrayStoreConfig, { urlParams: { by_type:  assetType } })

    config =
      title:              moduleName
      itemTitleField:     'name'
      itemSubtitleField:  'created_ago'
      itemClass:          LoftAssetItem
      arrayStore:         new MongosteenArrayStore(arrayStoreConfig)
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

      # update data in list if it's not assets_all,
      # in assets_all new objects are added automatically
      visibleList = @module.visibleNestedListShownWithParent()
      if visibleList.name != 'assets_all'
        visibleList.updateItems()


  _clear_assets_selection: ->
    for name, list of @module.nestedLists
      list.groupActions.hide()
      list.$items.find('.asset-checkbox').prop('checked', false)


  closeModal: ->
    @selectMultipleAssets = true
    @_clear_assets_selection()
    @module.$el.removeClass('module-modal')
    @module.hide()


  # chr.modules.assets.showModal()
  showModal: (assetType='all', @selectMultipleAssets=false, @onAcceptCallback=$.noop) ->
    # modal mode
    @module.$el.addClass('module-modal')
    # show nested list
    @module.showNestedList("assets_#{ assetType }")
    # select active item
    @module.rootList.$items.children().removeClass('active')
    @module.rootList.$items.children("[href='#/assets/assets_#{ assetType }']").addClass('active')
    # show module
    @module.show()





