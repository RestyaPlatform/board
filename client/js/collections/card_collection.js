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
            if (this.sortKey === 'name' || this.sortKey === 'list_name' || sort_by === 'sort_group_label' || sort_by === 'sort_group_user') {
                var str = '' + item.get(this.sortKey),
                    direction = this.sortDirection;
                str = str.toLowerCase();
                str = str.split('');
                str = _.map(str, function(letter) {
                    if (direction === 'desc') {
                        return String.fromCharCode(-(letter.charCodeAt(0)));
                    } else {
                        return String.fromCharCode((letter.charCodeAt(0)));
                    }
                });
                return str;
            } else if (this.sortKey === 'due_date' || this.sortKey === 'list_moved_date' || this.sortKey === 'modified') {
                if (item.get(this.sortKey) !== null && item.get(this.sortKey) !== 'NULL' && !_.isUndefined(item.get(this.sortKey)) && !_.isEmpty(item.get(this.sortKey))) {
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
                if (item.get('created') !== null && !_.isUndefined(item.get('created')) && !_.isEmpty(item.get('created'))) {
                    var datetime = item.get('created').split(' ');
                    if (!_.isUndefined(datetime[1])) {
                        _date = datetime[0] + 'T' + datetime[1];
                    } else {
                        _date = datetime[0];
                    }
                    sort_date = new Date(_date);
                    return this.sortDirection === 'desc' ? -sort_date.getTime() : sort_date.getTime();
                }
            } else if (this.sortKey === 'start_date') {
                if (item.get('custom_fields') !== null && !_.isUndefined(item.get('custom_fields')) && !_.isEmpty(item.get('custom_fields'))) {
                    var inputArr = item.get('custom_fields');
                    var start_date_time = JSON.parse(inputArr);
                    if (!_.isUndefined(start_date_time.start_date) && !_.isEmpty(start_date_time.start_date) && !_.isUndefined(start_date_time.start_time) && !_.isEmpty(start_date_time.start_time)) {
                        _date = start_date_time.start_date + 'T' + start_date_time.start_time;
                        sort_date = new Date(_date);
                        return this.sortDirection === 'desc' ? -sort_date.getTime() : sort_date.getTime();
                    }
                }
            } else if (this.sortKey === 'checklist_item_completed_count' || this.sortKey === 'checklist_item_pending_count') {
                if (!_.isUndefined(item.checklists) && !_.isEmpty(item.checklists) && item.checklists !== null) {
                    return this.sortDirection === 'desc' ? -item.get(this.sortKey) : item.get(this.sortKey);
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
    sortByColumn: function(colName, sortDirection) {
        this.sortKey = colName;
        if (!_.isUndefined(sortDirection)) {
            this.sortDirection = sortDirection;
        }
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
