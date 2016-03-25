/**
 * Backbone localStorage and sessionStorage Adapter
 * Version 0.0.1
 *
 * https://github.com/jcbrand/Backbone.browserStorage
 */
(function (root, factory) {
  if (typeof exports === 'object' && typeof require === 'function') {
    module.exports = factory(require("backbone"), require('underscore'));
  } else if (typeof define === "function" && define.amd) {
    // AMD. Register as an anonymous module.
    define(["backbone", "underscore"], function(Backbone, _) {
      // Use global variables if the locals are undefined.
      return factory(Backbone || root.Backbone, _ || root._);
    });
  } else {
    factory(Backbone, _);
  }
}(this, function(Backbone, _) {
// A simple module to replace `Backbone.sync` with *browser storage*-based
// persistence. Models are given GUIDS, and saved into a JSON object. Simple
// as that.

// Hold reference to Underscore.js and Backbone.js in the closure in order
// to make things work even if they are removed from the global namespace

// Generate four random hex digits.
function S4() {
   return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
}

// Generate a pseudo-GUID by concatenating random hexadecimal.
function guid() {
   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}

function contains(array, item) {
  var i = array.length;
  while (i--) if (array[i] === item) return true;
  return false;
}

function extend(obj, props) {
  for (var key in props) { obj[key] = props[key]; }
  return obj;
}

function _browserStorage (name, serializer, type) {
    var _store;
    if (type === 'local' && !window.localStorage ) {
        throw "Backbone.browserStorage: Environment does not support localStorage.";
    } else if (type === 'session' && !window.sessionStorage ) {
        throw "Backbone.browserStorage: Environment does not support sessionStorage.";
    }
    this.name = name;
    this.serializer = serializer || {
        serialize: function(item) {
        return _.isObject(item) ? JSON.stringify(item) : item;
        },
        // fix for "illegal access" error on Android when JSON.parse is passed null
        deserialize: function (data) {
        return data && JSON.parse(data);
        }
    };

    if (type === 'session') {
        this.store = window.sessionStorage;
    } else if (type === 'local') {
        this.store = window.localStorage;
    } else {
        throw "Backbone.browserStorage: No storage type was specified";
    }
    _store = this.store.getItem(this.name);
    this.records = (_store && _store.split(",")) || [];
}

// Our Store is represented by a single JS object in *localStorage* or *sessionStorage*.
// Create it with a meaningful name, like the name you'd give a table.
Backbone.BrowserStorage = {
    local: function (name, serializer) {
        return _browserStorage.bind(this, name, serializer, 'local')();
    },
    session: function (name, serializer) {
        return _browserStorage.bind(this, name, serializer, 'session')();
    }
};

// The browser's local and session stores will be extended with this obj.
var _extension = {

  // Save the current state of the **Store**
  save: function() {
    this.store.setItem(this.name, this.records.join(","));
  },

  // Add a model, giving it a (hopefully)-unique GUID, if it doesn't already
  // have an id of it's own.
  create: function(model) {
    if (!model.id) {
      model.id = guid();
      model.set(model.idAttribute, model.id);
    }
    this.store.setItem(this._itemName(model.id), this.serializer.serialize(model));
    this.records.push(model.id.toString());
    this.save();
    return this.find(model) !== false;
  },

  // Update a model by replacing its copy in `this.data`.
  update: function(model) {
    this.store.setItem(this._itemName(model.id), this.serializer.serialize(model));
    var modelId = model.id.toString();
    if (!contains(this.records, modelId)) {
      this.records.push(modelId);
      this.save();
    }
    return this.find(model) !== false;
  },

  // Retrieve a model from `this.data` by id.
  find: function(model) {
    return this.serializer.deserialize(this.store.getItem(this._itemName(model.id)));
  },

  // Return the array of all models currently in storage.
  findAll: function() {
    var result = [];
    for (var i = 0, id, data; i < this.records.length; i++) {
      id = this.records[i];
      data = this.serializer.deserialize(this.store.getItem(this._itemName(id)));
      if (data !== null) result.push(data);
    }
    return result;
  },

  // Delete a model from `this.data`, returning it.
  destroy: function(model) {
    this.store.removeItem(this._itemName(model.id));
    var modelId = model.id.toString();
    for (var i = 0, id; i < this.records.length; i++) {
      if (this.records[i] === modelId) {
        this.records.splice(i, 1);
      }
    }
    this.save();
    return model;
  },

  browserStorage: function() {
    return {
        session: sessionStorage,
        local: localStorage
    };
  },

  // Clear browserStorage for specific collection.
  _clear: function() {
    var local = this.store,
      itemRe = new RegExp("^" + this.name + "-");

    // Remove id-tracking item (e.g., "foo").
    local.removeItem(this.name);

    // Match all data items (e.g., "foo-ID") and remove.
    for (var k in local) {
      if (itemRe.test(k)) {
        local.removeItem(k);
      }
    }

    this.records.length = 0;
  },

  // Size of browserStorage.
  _storageSize: function() {
    return this.store.length;
  },

  _itemName: function(id) {
    return this.name+"-"+id;
  }

};

extend(Backbone.BrowserStorage.session.prototype, _extension);
extend(Backbone.BrowserStorage.local.prototype, _extension);

// localSync delegate to the model or collection's
// *browserStorage* property, which should be an instance of `Store`.
// window.Store.sync and Backbone.localSync is deprecated, use Backbone.BrowserStorage.sync instead
Backbone.BrowserStorage.sync = Backbone.localSync = function(method, model, options) {
  var store = model.browserStorage || model.collection.browserStorage;

  var resp, errorMessage;
  //If $ is having Deferred - use it.
  var syncDfd = Backbone.$ ?
    (Backbone.$.Deferred && Backbone.$.Deferred()) :
    (Backbone.Deferred && Backbone.Deferred());

  try {

    switch (method) {
      case "read":
        resp = model.id !== undefined ? store.find(model) : store.findAll();
        break;
      case "create":
        resp = store.create(model);
        break;
      case "update":
        resp = store.update(model);
        break;
      case "delete":
        resp = store.destroy(model);
        break;
    }

  } catch(error) {
    if (error.code === 22 && store._storageSize() === 0)
      errorMessage = "Private browsing is unsupported";
    else
      errorMessage = error.message;
  }

  if (resp) {
    if (options && options.success) {
      if (Backbone.VERSION === "0.9.10") {
        options.success(model, resp, options);
      } else {
        options.success(resp);
      }
    }
    if (syncDfd) {
      syncDfd.resolve(resp);
    }

  } else {
    errorMessage = errorMessage ? errorMessage
                                : "Record Not Found";

    if (options && options.error)
      if (Backbone.VERSION === "0.9.10") {
        options.error(model, errorMessage, options);
      } else {
        options.error(errorMessage);
      }

    if (syncDfd)
      syncDfd.reject(errorMessage);
  }

  // add compatibility with $.ajax
  // always execute callback for success and error
  if (options && options.complete) options.complete(resp);

  return syncDfd && syncDfd.promise();
};

Backbone.ajaxSync = Backbone.sync;

Backbone.getSyncMethod = function(model) {
  if(model.browserStorage || (model.collection && model.collection.browserStorage)) {
    return Backbone.localSync;
  }
  return Backbone.ajaxSync;
};

// Override 'Backbone.sync' to default to localSync,
// the original 'Backbone.sync' is still available in 'Backbone.ajaxSync'
Backbone.sync = function(method, model, options) {
  return Backbone.getSyncMethod(model).apply(this, [method, model, options]);
};

return Backbone.BrowserStorage;
}));
