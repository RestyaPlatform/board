if (typeof App === 'undefined') {
    App = {};
}
/**
 * ChatHistory Model
 * @class ChatHistory
 * @constructor
 * @extends Backbone.Model
 */
App.ChatHistory = Backbone.Model.extend({
    model: 'chat_history',
    initialize: function() {
        this.user = new App.User();
        this.cards = new App.CardCollection();
        this.lists = new App.ListCollection();
        this.boards = new App.BoardCollection();
    }
});
