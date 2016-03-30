if (typeof App === 'undefined') {
    App = {};
}
/**
 * Card Collection
 * @class CardCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.CardCollection = Backbone.Collection.extend({
    model: App.Card,
    sortDirection: 'asc',
    comparator: function(item) {
        if (this.sortDirection === 'desc') {
            return -item.get('position');
        } else {
            return item.get('position');
        }
    },
    sortByColumn: function(colName) {
        this.sortKey = colName;
        this.sort();
    },
    search: function(letters) {
        if (letters === '') return this;
        var pattern = new RegExp(letters, 'gi');
        return _(this.filter(function(data) {
            return pattern.test(data.get('name'));
        }));
    },
    next: function(card) {
        var filtered_cards = this.where({
            list_id: card.attributes.list_id
        });
        var cards = new App.CardCollection();
        cards.reset(filtered_cards, {
            silent: true
        });
        cards.sortByColumn('position');
        return cards.at(cards.indexOf(card) + 1);
    },
    previous: function(card) {
        var filtered_cards = this.where({
            list_id: card.attributes.list_id
        });
        var cards = new App.CardCollection();
        cards.reset(filtered_cards, {
            silent: true
        });
        cards.sortByColumn('position');
        return cards.at(cards.indexOf(card) - 1);
    }
});
