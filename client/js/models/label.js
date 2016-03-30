if (typeof App === 'undefined') {
    App = {};
}
/**
 * Label Model
 * @class Label
 * @constructor
 * @extends Backbone.Model
 */
App.Label = Backbone.Model.extend({
    storeName: 'label',
    initialize: function() {
        this.card = new App.Card();
    }
});
