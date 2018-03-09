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
        if (!_.isUndefined(this.sortKey)) {
            if (this.sortKey === 'name' || this.sortKey === 'list_name') {
                var str = '' + item.get(this.sortKey);
                str = str.toLowerCase();
                str = str.split('');
                str = _.map(str, function(letter) {
                    if (this.sortDirection === 'desc') {
                        return String.fromCharCode(-(letter.charCodeAt(0)));
                    } else {
                        return String.fromCharCode((letter.charCodeAt(0)));
                    }
                });
                return str;
            } else if (this.sortKey === 'due_date' || this.sortKey === 'list_moved_date') {
                if (item.get(this.sortKey) !== null) {
                    var date = item.get(this.sortKey).split(' ');
                    if (!_.isUndefined(date[1])) {
                        _date = date[0] + 'T' + date[1];
                    } else {
                        _date = date[0];
                    }
                    sort_date = new Date(_date);
                    return this.sortDirection === 'desc' ? -sort_date.getTime() : sort_date.getTime();
                }
            } else if (this.sortKey === 'created_date') {
                if (item.get('created') !== null) {
                    var date = item.get('created').split(' ');
                    if (!_.isUndefined(date[1])) {
                        _date = date[0] + 'T' + date[1];
                    } else {
                        _date = date[0];
                    }
                    sort_date = new Date(_date);
                    return this.sortDirection === 'desc' ? -sort_date.getTime() : sort_date.getTime();
                }
            } else if (this.sortKey === 'start_date') {
                if (item.get('custom_fields') !== null) {
                    var inputArr = item.get('custom_fields');
                    var start_date_time = JSON.parse(inputArr);
                    if (!_.isUndefined(start_date_time.start_date)) {
                        _date = start_date_time.start_date + 'T' + start_date_time.start_time;
                    } else {
                        _date = start_date_time.start_date;
                    }
                    sort_date = new Date(_date);
                    return this.sortDirection === 'desc' ? -sort_date.getTime() : sort_date.getTime();
                }
            } else {
                if (this.sortDirection === 'desc') {
                    return -item.get(this.sortKey);
                } else {
                    return item.get(this.sortKey);
                }
            }
        } else {
            if (this.sortDirection === 'desc') {
                return -item.get('position');
            } else {
                return item.get('position');
            }
        }
    },
    sortByColumn: function(colName, sortDirection = 'asc') {
        this.sortKey = colName;
        this.sortDirection = sortDirection;
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
