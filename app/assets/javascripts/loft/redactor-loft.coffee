# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#         Slate Studio (http://www.slatestudio.com)
#
# Coding Guide:
#   https://github.com/thoughtbot/guides/tree/master/style/coffeescript
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Redactor.js Loft Plugin
# -----------------------------------------------------------------------------

if ! @RedactorPlugins then @RedactorPlugins = {}

RedactorPlugins.loft = ->
  methods =
    init: ->
      imageButton = @button.add('image', 'Insert Image')
      @button.addCallback(imageButton, @loft.showImagesModal)

      fileButton = @button.add('file', 'Insert File')
      @button.addCallback(fileButton, @loft.showAllModal)

    showImagesModal: ->
      chr.modules.loft.showImages true, (objects) =>
        @loft.insertImages(objects)

    # allow multiple assets when no text is selected
    showAllModal: ->
      multipleAssets = this.selection.getText() == ''
      chr.modules.loft.showAll multipleAssets, (objects) =>
        @loft.insertFiles(objects)

    # if text is selected replace text with <a>{{ text }}</a>
    # otherwise add link(s) split by <br/> tag
    insertFiles: (objects) ->
      if objects.length > 0
        selectedText = this.selection.getText()
        if selectedText != ''
          asset = objects[0]
          html = "<a href='#{ asset.file.url }' target='_blank'>#{ selectedText }</a>"
        else
          links = []
          for asset in objects
            links.push "<a href='#{ asset.file.url }' target='_blank'>#{ asset.name }</a>"
          html = links.join('<br>')

        this.insert.html(html, false)

    insertImages: (objects) ->
      if objects.length > 0
        images = []
        for asset in objects
          images.push "<img src='#{ asset.file.url }' alt='#{ asset.name }' />"

        html = images.join('<br>')

        this.insert.html(html, false)

  return methods
