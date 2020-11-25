if (typeof App === 'undefined') {
    App = {};
}
/**
 * Unsplash Collection
 * @class UnsplashCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.UnsplashCollection = Backbone.Collection.extend({
    model: App.Unsplash,
    storeName: 'unsplash'
});
