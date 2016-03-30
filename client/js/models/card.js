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
        }, {
            silent: true
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
