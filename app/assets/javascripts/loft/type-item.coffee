# -----------------------------------------------------------------------------
# Author: Alexander Kravets <alex@slatestudio.com>,
#  Slate Studio (http://www.slatestudio.com)
#
# Coding Guide:
#   https://github.com/thoughtbot/guides/tree/master/style/coffeescript
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Loft Asset Item
# -----------------------------------------------------------------------------
class @LoftTypeItem extends Item
  onClick: (e) ->
    if @.$el.hasClass('active') then e.preventDefault() ; return

    if ! @module.$el.hasClass 'module-modal'
      hash = $(e.currentTarget).attr('href')
      chr.updateHash(hash, true)

      crumbs = hash.split('/')
      @module.showNestedList(_last(crumbs), true)

    else
      e.preventDefault()

      $item = $(e.currentTarget)

      $item.parent().children('.active').removeClass('active')
      $item.addClass('active')

      listName = $item.attr('href').split('/')[2]
      @module.showNestedList(listName, true)




