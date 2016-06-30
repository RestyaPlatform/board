if (typeof App === 'undefined') {
    App = {};
}
/**
 * Activity Model
 * @class Activity
 * @constructor
 * @extends Backbone.Model
 */
App.Activity = Backbone.Model.extend({
    storeName: 'comment',
    initialize: function() {
        this.user = new App.User();
        this.cards = new App.CardCollection();
        this.lists = new App.ListCollection();
        this.boards = new App.BoardCollection();
    }
});
