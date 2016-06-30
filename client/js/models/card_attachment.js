if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card Attachment Model
 * @class Card Attachment
 * @constructor
 * @extends Backbone.Model
 */
App.CardAttachment = Backbone.Model.extend({
    initialize: function() {
        this.card = new App.Card();
    }
});
