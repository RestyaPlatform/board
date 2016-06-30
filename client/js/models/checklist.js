if (typeof App === 'undefined') {
    App = {};
}
/**
 * CheckList Model
 * @class CheckList
 * @constructor
 * @extends Backbone.Model
 */
App.CheckList = Backbone.Model.extend({
    storeName: 'checklist',
    initialize: function() {
        this.checklist_items = new App.CheckListItemCollection();
        this.board_users = new App.BoardsUserCollection();
        this.card = new App.Card();
    },
    moveAfter: function(beforeId) {
        var before = this.collection.get(beforeId);
        var after = this.collection.next(before);
        if (typeof after == 'undefined') {
            afterPosition = before.position() + 2;
        } else {
            afterPosition = after.position();
        }
        var difference = (afterPosition - before.position()) / 2;
        var newPosition = difference + before.position();
        this.set({
            position: newPosition
        });
        return this;
    },
    moveBefore: function(afterId) {
        var after = this.collection.get(afterId);
        var before = this.collection.previous(after);
        if (typeof before == 'undefined') {
            beforePosition = 0.0;
        } else {
            beforePosition = before.position();
        }
        var difference = (after.position() - beforePosition) / 2;
        var newPosition = difference + beforePosition;
        this.set({
            position: newPosition
        });
        this.collection.sort({
            silent: true
        });
        return this;
    },
    position: function() {
        return parseFloat(this.attributes.position);
    }
});
