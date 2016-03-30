if (typeof App === 'undefined') {
    App = {};
}
/**
 * Flickr Collection
 * @class FlickrCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.FlickrCollection = Backbone.Collection.extend({
    model: App.Flickr,
    storeName: 'flickr'
});
