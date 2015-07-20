//
//     Backbone.Rails.js
//
//     Makes Backbone.js play nicely with the default Rails setup, i.e.,
//     no need to set
//       ActiveRecord::Base.include_root_in_json = false
//     and build all of your models directly from `params` rather than
//     `params[:model]`.
//
//     Load this file after backbone.js and before your application JS.
//

Backbone.RailsJSON = {
  // In order to properly wrap/unwrap Rails JSON data, we need to specify
  // what key the object will be wrapped with.
  _name : function() {
    if (!this.name) throw new Error("A 'name' property must be specified");
    return this.name;
  },

  // A test to indicate whether the given object is wrapped.
  isWrapped : function(object) {
    return (object.hasOwnProperty(this._name()) &&
        (typeof(object[this._name()]) == "object"));
  },

  // Extracts the object's wrapped attributes.
  unwrappedAttributes : function(object) {
    return object[this._name()];
  },

  // Wraps the model's attributes under the supplied key.
  wrappedAttributes : function() {
    var object = new Object;
    object[this._name()] = _.clone(this.attributes);
    return object;
  },

  // Sets up the new model's internal state so that it matches the
  // expected format. Should be called early in the model's constructor.
  maybeUnwrap : function(args) {
    if (this.isWrapped(args)) {
      var unwrappedAttributes = this.unwrappedAttributes(args);
      this.unset(this._name(), { silent: true });
      this.set(unwrappedAttributes, { silent: true });
      this._previousAttributes = _.clone(this.attributes);
    }
  }
};

_.extend(Backbone.Model.prototype, Backbone.RailsJSON, {
  // This is called on all models coming in from a remote server.
  // Unwraps the given response from the default Rails format.
  parse : function(resp) {
    return this.unwrappedAttributes(resp);
  },

  // This is called just before a model is persisted to a remote server.
  // Wraps the model's attributes into a Rails-friendly format.
  toJSON : function() {
    return this.wrappedAttributes();
  },

  // A new default initializer which handles data directly from Rails as
  // well as unnested data.
  initialize : function(args) {
    if (typeof args != 'undefined') {
	    this.maybeUnwrap(args);
	}
  }
});
