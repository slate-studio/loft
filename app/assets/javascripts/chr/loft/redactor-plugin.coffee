if ! RedactorPlugins then @RedactorPlugins = {}

RedactorPlugins.loft = ->
  methods =
    init: ->
      imageButton = @button.add('image', 'Insert Image')
      @button.addCallback(imageButton, @loft.showImagesModal)

      fileButton = @button.add('file', 'Insert File')
      @button.addCallback(fileButton, @loft.showAllModal)


    showImagesModal: ->
      chr.modules.assets.showModal 'images', true, (objects) => @loft.insertImages(objects)


    showAllModal: ->
      chr.modules.assets.showModal 'all', true, (objects) => @loft.insertFiles(objects)


    insertFiles: (objects) ->
      for asset in objects
        this.file.insert "<a href='#{ asset.file.url }' target='_blank'>#{ asset.name }</a>"


    insertImages: (objects) ->
      for asset in objects
        this.image.insert "<img src='#{ asset.file.url }' alt='#{ asset.name }' />"


  return methods




