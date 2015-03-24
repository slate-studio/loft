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
class @Loft
  constructor: (title, @resource, @resourcePath) ->
    @module = {}
    @store  = {}

    @_uploadsCounter = 0

    moduleConfig =
      title: title
      showNestedListsAside: true
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

    return config


  _inititialize_list: (list) ->
    # uploading spinner
    list.$loading =$ "<div class='loader'></div>"
    list.$el.append list.$loading

    # file input button for uploading new files
    list.$uploadInput =$ "<input class='asset-upload' type='file' multiple='multiple' />"
    list.$search.before list.$uploadInput

    # file upload handler
    list.$uploadInput.on 'change', (e) =>
      files = e.target.files
      if files.length > 0
        @_upload(file, list) for file in files

    # group actions toolbar
    list.$groupActions = new LoftGroupActions(list, this)


  _upload: (file, list) ->
    obj = {}
    obj["__FILE__[file]"] = file

    @_start_file_upload()
    @store.push obj,
      onSuccess: (object) => @_finish_file_upload(list)
      onError:   (errors) => @_finish_file_upload(list)
        # + process validation errors, if any


  _start_file_upload: ->
    @_uploadsCounter += 1
    @module.$el.addClass('assets-uploading')


  _finish_file_upload: (list) ->
    @_uploadsCounter -= 1
    if @_uploadsCounter == 0
      @module.$el.removeClass('assets-uploading')

      # update data in list if it's not assets_all,
      # in there new objects are added automatically
      visibleList = @module.visibleNestedListShownWithParent()
      if visibleList.name != 'assets_all'
        visibleList.updateItems()




