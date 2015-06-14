this.LoftGroupActions = (function() {
  function LoftGroupActions(list, loft) {
    this.list = list;
    this.loft = loft;
    this._render();
    this._bind_checkboxes();
  }

  LoftGroupActions.prototype._render = function() {
    this.$el = $("<div class='assets-group-actions' style='display:none;'></div>");
    this.list.$header.append(this.$el);
    this.$acceptBtn = $("<a href='#' class='accept'>Accept</a>");
    this.$acceptBtn.on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        return _this._accept_selected_items();
      };
    })(this));
    this.$el.append(this.$acceptBtn);
    this.$deleteBtn = $("<a href='#' class='delete'>Delete Selected</a>");
    this.$deleteBtn.on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        return _this._delete_selected_list_items();
      };
    })(this));
    this.$el.append(this.$deleteBtn);
    this.$unselectBtn = $("<a href='#' class='unselect'>Unselect</a>");
    this.$unselectBtn.on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        return _this._unselect_list_items();
      };
    })(this));
    return this.$el.append(this.$unselectBtn);
  };

  LoftGroupActions.prototype._bind_checkboxes = function() {
    return this.list.$el.on('click', '.asset .asset-checkbox input', (function(_this) {
      return function(e) {
        var selectedItems;
        if (!_this.loft.selectMultipleAssets) {
          _this._select_single_item($(e.target));
        }
        selectedItems = _this._selected_list_items();
        if (selectedItems.length > 0) {
          return _this._show();
        } else {
          return _this.hide();
        }
      };
    })(this));
  };

  LoftGroupActions.prototype._select_single_item = function($checkbox) {
    if ($checkbox.prop('checked')) {
      this.list.$el.find('.asset .asset-checkbox input:checked').prop('checked', false);
      return $checkbox.prop('checked', true);
    }
  };

  LoftGroupActions.prototype._selected_list_items = function() {
    return $.map(this.list.$el.find('.asset .asset-checkbox input:checked'), function(checkbox) {
      return $(checkbox).parent().parent();
    });
  };

  LoftGroupActions.prototype._unselect_list_items = function() {
    this.list.$el.find('.asset .asset-checkbox input').prop('checked', false);
    return this.hide();
  };

  LoftGroupActions.prototype._delete_selected_list_items = function() {
    var $item, $selectedItems, filesToRemoveCounter, i, len, objectId;
    if (confirm("Are you sure?")) {
      $selectedItems = this._selected_list_items();
      filesToRemoveCounter = $selectedItems.length;
      for (i = 0, len = $selectedItems.length; i < len; i++) {
        $item = $selectedItems[i];
        objectId = $item.attr('data-id');
        this.list.config.arrayStore.remove(objectId, {
          onSuccess: (function(_this) {
            return function() {};
          })(this),
          onError: (function(_this) {
            return function() {};
          })(this)
        });
      }
      return this.hide();
    }
  };

  LoftGroupActions.prototype._accept_selected_items = function() {
    var $item, $selectedItems, i, len, object, objectId, objects;
    $selectedItems = this._selected_list_items();
    objects = [];
    for (i = 0, len = $selectedItems.length; i < len; i++) {
      $item = $selectedItems[i];
      objectId = $item.attr('data-id');
      object = this.list.config.arrayStore.get(objectId);
      objects.push(object);
    }
    this.loft.onAcceptCallback(objects);
    return this.loft.closeModal();
  };

  LoftGroupActions.prototype._show = function() {
    return this.$el.show();
  };

  LoftGroupActions.prototype.hide = function() {
    return this.$el.hide();
  };

  return LoftGroupActions;

})();

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

this.LoftAssetItem = (function(superClass) {
  extend(LoftAssetItem, superClass);

  function LoftAssetItem(module, path, object1, config) {
    this.module = module;
    this.path = path;
    this.object = object1;
    this.config = config;
    this.$el = $("<div class='item asset asset-" + this.object.type + "' data-id='" + this.object._id + "'></div>");
    this.render();
  }

  LoftAssetItem.prototype._bind_name_input = function() {
    this.$nameInput.on('blur', (function(_this) {
      return function(e) {
        return _this._update_name_if_changed();
      };
    })(this));
    return this.$nameInput.on('keyup', (function(_this) {
      return function(e) {
        if (e.keyCode === 13) {
          $(e.target).blur();
        }
        if (e.keyCode === 27) {
          return _this._cancel_name_change();
        }
      };
    })(this));
  };

  LoftAssetItem.prototype._edit_name = function(e) {
    this.$el.addClass('edit-name');
    return this.$nameInput.focus().select();
  };

  LoftAssetItem.prototype._cancel_name_change = function() {
    var name;
    this.$el.removeClass('edit-name');
    name = this.$title.html();
    return this.$nameInput.val(name);
  };

  LoftAssetItem.prototype._update_name_if_changed = function() {
    var name;
    this.$el.removeClass('edit-name');
    name = this.$nameInput.val();
    if (name === this.$title.html()) {
      return;
    }
    this.$title.html(name);
    return this.config.arrayStore.update(this.object._id, {
      '[name]': name
    }, {
      onSuccess: (function(_this) {
        return function(object) {};
      })(this),
      onError: (function(_this) {
        return function(errors) {};
      })(this)
    });
  };

  LoftAssetItem.prototype.render = function() {
    var name;
    this.$el.html('').removeClass('item-folder has-subtitle has-thumbnail');
    this._render_title();
    this._render_subtitle();
    this.$link = $("<a class='asset-icon' href='" + this.object.file.url + "' target='_blank'></a>");
    this.$el.prepend(this.$link);
    if (this.object.type === 'image' && this.object.grid_item_thumbnail !== '') {
      this.$thumbnailSmall = $("<img class='asset-thumbnail-small'  src='" + this.object._list_item_thumbnail.small + "' />");
      this.$thumbnailMedium = $("<img class='asset-thumbnail-medium' src='" + this.object._list_item_thumbnail.medium + "' />");
      this.$link.append(this.$thumbnailSmall);
      this.$link.append(this.$thumbnailMedium);
    }
    this.$checkbox = $("<div class='asset-checkbox'></div>");
    this.$checkboxInput = $("<input type='checkbox' />");
    this.$checkbox.append(this.$checkboxInput);
    this.$el.prepend(this.$checkbox);
    name = this.$title.text();
    this.$name = $("<div class='asset-name'></div>");
    this.$nameInput = $("<input type='text' value='" + name + "' />");
    this.$name.append(this.$nameInput);
    this.$title.before(this.$name);
    this._bind_name_input();
    return this.$title.on('click', (function(_this) {
      return function(e) {
        return _this._edit_name(e);
      };
    })(this));
  };

  return LoftAssetItem;

})(Item);

this.Loft = (function() {
  function Loft(title, resource, resourcePath, arrayStoreClass, arrayStoreConfig) {
    var moduleConfig;
    this.arrayStoreClass = arrayStoreClass;
    this.arrayStoreConfig = arrayStoreConfig;
    this.module = {};
    this.store = {};
    if (this.arrayStoreClass == null) {
      this.arrayStoreClass = RailsArrayStore;
    }
    if (this.arrayStoreConfig == null) {
      this.arrayStoreConfig = {
        resource: resource,
        path: resourcePath,
        sortBy: 'created_at',
        sortReverse: true,
        searchable: true
      };
    }
    this._uploadsCounter = 0;
    moduleConfig = {
      title: title,
      showNestedListsAside: true,
      items: {
        loft_all: this._nested_list_config('All'),
        loft_images: this._nested_list_config('Images', 'image'),
        loft_text: this._nested_list_config('Text', 'text'),
        loft_archives: this._nested_list_config('Archives', 'archive'),
        loft_audio: this._nested_list_config('Audio', 'audio'),
        loft_video: this._nested_list_config('Video', 'video'),
        loft_other: this._nested_list_config('Other', 'other')
      },
      onModuleInit: (function(_this) {
        return function(module) {
          return _this._initialize_module(module);
        };
      })(this)
    };
    return moduleConfig;
  }

  Loft.prototype._initialize_module = function(module) {
    this.module = module;
    this.store = this.module.nestedLists.loft_all.config.arrayStore;
    this.module.showModal = (function(_this) {
      return function(assetType, selectMultipleAssets, callback) {
        return _this.showModal(assetType, selectMultipleAssets, callback);
      };
    })(this);
    this.selectMultipleAssets = true;
    this.module.rootList.$modalCloseBtn = $("<a href='#' class='modal-close'>Cancel</a>");
    this.module.rootList.$header.prepend(this.module.rootList.$modalCloseBtn);
    this.module.rootList.$modalCloseBtn.on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        return _this.closeModal();
      };
    })(this));
    this.module.rootList.$items.on('click', 'a', (function(_this) {
      return function(e) {
        var $item, listName;
        if (_this.module.$el.hasClass('module-modal')) {
          e.preventDefault();
          $item = $(e.currentTarget);
          listName = $item.attr('href').split('/')[2];
          _this.module.activeList.hide();
          _this.module.showList(listName);
          _this.module.activeList.updateItems();
          $item.parent().children('.active').removeClass('active');
          return $item.addClass('active');
        }
      };
    })(this));
    if (!chr.isMobile()) {
      return this.module.$el.addClass('grid-mode');
    }
  };

  Loft.prototype._nested_list_config = function(moduleName, assetType) {
    var config, storeConfig;
    storeConfig = {};
    $.extend(storeConfig, this.arrayStoreConfig);
    if (assetType) {
      $.extend(storeConfig, {
        urlParams: {
          by_type: assetType
        }
      });
    }
    config = {
      title: moduleName,
      showWithParent: true,
      itemClass: LoftAssetItem,
      arrayStore: new this.arrayStoreClass(storeConfig),
      onListInit: (function(_this) {
        return function(list) {
          return _this._inititialize_list(list);
        };
      })(this),
      onListShow: (function(_this) {
        return function(list) {
          return _this._clear_assets_selection();
        };
      })(this)
    };
    return config;
  };

  Loft.prototype._inititialize_list = function(list) {
    list.$uploadInput = $("<input class='asset-upload' type='file' multiple='multiple' />");
    list.$search.before(list.$uploadInput);
    list.$uploadInput.on('change', (function(_this) {
      return function(e) {
        var file, files, i, len, results;
        files = e.target.files;
        if (files.length > 0) {
          results = [];
          for (i = 0, len = files.length; i < len; i++) {
            file = files[i];
            results.push(_this._upload(file, list));
          }
          return results;
        }
      };
    })(this));
    list.groupActions = new LoftGroupActions(list, this);
    list.$switchMode = $("<a class='assets-switch-mode' href='#'></a>");
    list.$backBtn.after(list.$switchMode);
    list.$switchMode.on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        return _this.module.$el.toggleClass('grid-mode');
      };
    })(this));
    return list.$header.on('click', '.back', (function(_this) {
      return function(e) {
        if (_this.module.$el.hasClass('module-modal')) {
          e.preventDefault();
          return _this.module.showList();
        }
      };
    })(this));
  };

  Loft.prototype._upload = function(file, list) {
    var obj;
    obj = {};
    obj["__FILE__[file]"] = file;
    this._start_file_upload();
    return this.store.push(obj, {
      onSuccess: (function(_this) {
        return function(object) {
          return _this._finish_file_upload(list);
        };
      })(this),
      onError: (function(_this) {
        return function(errors) {
          _this._finish_file_upload(list);
          return chr.showError('Can\'t upload file.');
        };
      })(this)
    });
  };

  Loft.prototype._start_file_upload = function() {
    this._uploadsCounter += 1;
    return this.module.$el.addClass('assets-uploading');
  };

  Loft.prototype._finish_file_upload = function(list) {
    this._uploadsCounter -= 1;
    if (this._uploadsCounter === 0) {
      this.module.$el.removeClass('assets-uploading');
      if (this.module.activeList.name !== 'loft_all') {
        return this.module.activeList.updateItems();
      }
    }
  };

  Loft.prototype._clear_assets_selection = function() {
    var list, name, ref, results;
    ref = this.module.nestedLists;
    results = [];
    for (name in ref) {
      list = ref[name];
      list.groupActions.hide();
      results.push(list.$items.find('.asset-checkbox').prop('checked', false));
    }
    return results;
  };

  Loft.prototype.closeModal = function() {
    this.selectMultipleAssets = true;
    this._clear_assets_selection();
    this.module.$el.removeClass('module-modal');
    return this.module.hide();
  };

  Loft.prototype.showModal = function(assetType, selectMultipleAssets1, onAcceptCallback) {
    if (assetType == null) {
      assetType = 'all';
    }
    this.selectMultipleAssets = selectMultipleAssets1 != null ? selectMultipleAssets1 : false;
    this.onAcceptCallback = onAcceptCallback != null ? onAcceptCallback : $.noop;
    this.module.$el.addClass('module-modal');
    this.module.show();
    this.module.showList("loft_" + assetType);
    this.module.activeList.updateItems();
    this.module.rootList.$items.children().removeClass('active');
    return this.module.rootList.$items.children("[href='#/loft/loft_" + assetType + "']").addClass('active');
  };

  return Loft;

})();

if (!this.RedactorPlugins) {
  this.RedactorPlugins = {};
}

RedactorPlugins.loft = function() {
  var methods;
  methods = {
    init: function() {
      var fileButton, imageButton;
      imageButton = this.button.add('image', 'Insert Image');
      this.button.addCallback(imageButton, this.loft.showImagesModal);
      fileButton = this.button.add('file', 'Insert File');
      return this.button.addCallback(fileButton, this.loft.showAllModal);
    },
    showImagesModal: function() {
      return chr.modules.loft.showModal('images', true, (function(_this) {
        return function(objects) {
          return _this.loft.insertImages(objects);
        };
      })(this));
    },
    showAllModal: function() {
      var multipleAssets;
      multipleAssets = this.selection.getText() === '';
      return chr.modules.loft.showModal('all', multipleAssets, (function(_this) {
        return function(objects) {
          return _this.loft.insertFiles(objects);
        };
      })(this));
    },
    insertFiles: function(objects) {
      var asset, html, i, len, links, selectedText;
      if (objects.length > 0) {
        selectedText = this.selection.getText();
        if (selectedText !== '') {
          asset = objects[0];
          html = "<a href='" + asset.file.url + "' target='_blank'>" + selectedText + "</a>";
        } else {
          links = [];
          for (i = 0, len = objects.length; i < len; i++) {
            asset = objects[i];
            links.push("<a href='" + asset.file.url + "' target='_blank'>" + asset.name + "</a>");
          }
          html = links.join('<br>');
        }
        return this.insert.html(html, false);
      }
    },
    insertImages: function(objects) {
      var asset, html, i, images, len;
      if (objects.length > 0) {
        images = [];
        for (i = 0, len = objects.length; i < len; i++) {
          asset = objects[i];
          images.push("<img src='" + asset.file.url + "' alt='" + asset.name + "' />");
        }
        html = images.join('<br>');
        return this.insert.html(html, false);
      }
    }
  };
  return methods;
};



var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

this.InputLoftImage = (function(superClass) {
  extend(InputLoftImage, superClass);

  function InputLoftImage() {
    return InputLoftImage.__super__.constructor.apply(this, arguments);
  }

  InputLoftImage.prototype._add_input = function() {
    var base;
    if ((base = this.config).placeholder == null) {
      base.placeholder = 'Image url';
    }
    this.$input = $("<input type='string' name='" + this.name + "' value='" + (this._safe_value()) + "' id='" + this.name + "' />");
    this.$el.append(this.$input);
    this.$input.on('change', (function(_this) {
      return function(e) {
        return _this.updateValue($(e.target).val());
      };
    })(this));
    this._add_image();
    this._add_choose_button();
    this._add_remove_button();
    return this._update_input_class();
  };

  InputLoftImage.prototype._add_image = function() {
    this.$image = $("<a href='' target='_blank' class='image'><img src='' /></a>");
    this.$el.append(this.$image);
    return this._update_image();
  };

  InputLoftImage.prototype._add_choose_button = function() {
    this.$chooseBtn = $("<a href='#' class='choose'></a><br/>");
    this.$el.append(this.$chooseBtn);
    this._update_choose_button_title();
    return this.$chooseBtn.on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        return chr.modules.loft.showModal('images', false, function(objects) {
          var asset;
          asset = objects[0];
          return _this.updateValue(asset.file.url);
        });
      };
    })(this));
  };

  InputLoftImage.prototype._add_remove_button = function() {
    this.$removeBtn = $("<a href='#' class='remove'>Remove</a>");
    this.$el.append(this.$removeBtn);
    return this.$removeBtn.on('click', (function(_this) {
      return function(e) {
        e.preventDefault();
        if (confirm('Are you sure?')) {
          return _this.updateValue('');
        }
      };
    })(this));
  };

  InputLoftImage.prototype._update_image = function() {
    var url;
    url = this.value;
    this.$image.attr('href', this.value).children().attr('src', this.value);
    if (this.value === '') {
      return this.$image.hide();
    } else {
      return this.$image.show();
    }
  };

  InputLoftImage.prototype._update_choose_button_title = function() {
    var title;
    title = this.value === '' ? 'Choose or upload' : 'Choose other or upload';
    return this.$chooseBtn.html(title);
  };

  InputLoftImage.prototype._update_input_class = function() {
    if (this.value === '') {
      return this.$el.removeClass('has-value');
    } else {
      return this.$el.addClass('has-value');
    }
  };

  InputLoftImage.prototype.updateValue = function(value) {
    this.value = value;
    this.$input.val(this.value);
    this._update_image();
    this._update_choose_button_title();
    return this._update_input_class();
  };

  return InputLoftImage;

})(InputString);

chr.formInputs['loft-image'] = InputLoftImage;
