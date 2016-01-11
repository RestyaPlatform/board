if (typeof App == 'undefined') {
    App = {};
}
/**
 * Plugin Collection
 * @class PluginCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.PluginCollection = Backbone.Collection.extend({
    model: App.Plugin
});
