if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card Model
 * @class Card
 * @constructor
 * @extends Backbone.Model
 */
App.Card = Backbone.Model.extend({
    storeName: 'card',
    initialize: function() {
        this.url = api_url + 'boards/' + this.attributes.board_id + '/lists/' + this.attributes.list_id + '/cards.json';

        this.attachments = new App.CardAttachmentCollection();
        this.attachments.card = this;

        this.labels = new App.CardLabelCollection();
        this.labels.card = this;

        this.board_labels = new App.CardLabelCollection();

        this.checklists = new App.CardCheckListCollection();
        this.checklists.card = this;

        this.board_users = new App.BoardsUserCollection();
        this.board_users.card = this;

        this.cards = new App.CardCollection();
        this.users = new App.UserCollection();
        this.card_voters = new App.CardVoterCollection();
        this.board_activities = new App.ActivityCollection();
        this.cards_subscribers = new App.CardSubscriberCollection();

        // Filtered will be changed in_header_view.js
        this.attributes.is_filtered = false;
    },
    moveAfter: function(beforeId) {
        var before;
        var after;
        if (this.collection.list == 'undefined' || this.collection.list === undefined) {
            before = this.collection.get(beforeId);
            after = this.collection.next(before);
        } else {
            before = this.collection.list.board.cards.get(beforeId);
            after = this.collection.list.board.cards.next(before);
        }
        if (typeof after == 'undefined') {
            afterPosition = before.position() + 2;
        } else {
            afterPosition = after.position();
        }
        var difference = (afterPosition - before.position()) / 2;
        var newPosition = difference + before.position();
        this.set({
            position: newPosition
        }, {
            silent: true
        });
        return this;
    },
    moveBefore: function(afterId) {
        var after;
        var before;
        if (this.collection.list == 'undefined' || this.collection.list === undefined) {
            after = this.collection.get(afterId);
            before = this.collection.previous(after);
        } else {
            after = this.collection.list.board.cards.get(afterId);
            before = this.collection.list.board.cards.previous(after);
        }
        if (typeof before == 'undefined') {
            beforePosition = 0.0;
        } else {
            beforePosition = before.position();
        }
        var difference = (after.position() - beforePosition) / 2;
        var newPosition = difference + beforePosition;
        this.set({
            position: newPosition
        }, {
            silent: true
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
