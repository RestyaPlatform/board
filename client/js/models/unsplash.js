if (typeof App === 'undefined') {
    App = {};
}
/**
 * Unsplash Model
 * @class Unsplash
 * @constructor
 * @extends Backbone.Model
 */
App.Unsplash = Backbone.Model.extend({
    initialize: function() {
        this.url = 'https://api.unsplash.com/photos?client_id=' + UNSPLASH_API_KEY + '&page=1&per_page=20';
    },
    storeName: 'unsplash'
});
