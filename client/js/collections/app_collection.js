if (typeof App === 'undefined') {
    App = {};
}
/**
 * App Collection
 * @class AppCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.AppCollection = Backbone.Collection.extend({
    model: App.App
});
