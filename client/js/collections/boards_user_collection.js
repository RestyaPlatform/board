if (typeof App === 'undefined') {
    App = {};
}
/**
 * Boards User Collection
 * @class BoardsUserCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.BoardsUserCollection = Backbone.Collection.extend({
    model: App.BoardsUser,
    comparator: function(item) {
        return -item.get('board_user_role_id');
    },
    search: function(letters) {
        if (letters === "") return this;

        var pattern = new RegExp(letters, "gi");
        return _(this.filter(function(data) {
            return pattern.test(data.get("username")) || pattern.test(data.get("email"));
        }));
    },
    saved: function() {
        return this.reject(function(board_users) {
            return board_users.isNew();
        });
    }
});
