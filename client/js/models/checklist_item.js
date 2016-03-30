if (typeof App === 'undefined') {
    App = {};
}
/**
 * CheckList Item Model
 * @class CheckListItem
 * @constructor
 * @extends Backbone.Model
 */
App.CheckListItem = Backbone.Model.extend({
    storeName: 'item',
    initialize: function() {
        this.board_users = new App.BoardsUserCollection();
        this.cards = new App.CardCollection();
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
