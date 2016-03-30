if (typeof App === 'undefined') {
    App = {};
}
/**
 * Flickr Model
 * @class Flickr
 * @constructor
 * @extends Backbone.Model
 */
App.Flickr = Backbone.Model.extend({
    initialize: function() {
        this.url = 'https://api.flickr.com/services/rest/?api_key=' + FLICKR_API_KEY + '&format=json&method=flickr.photos.getRecent&nojsoncallback=1&page=1&per_page=20';
    },
    storeName: 'flickr'
});
