if (typeof App === 'undefined') {
    App = {};
}
/**
 * Boards User Model
 * @class BoardsUser
 * @constructor
 * @extends Backbone.Model
 */
App.BoardsUser = Backbone.Model.extend({
    storeName: 'board_user'
});
