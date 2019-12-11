if (typeof App === 'undefined') {
    App = {};
}
/**
 * List Collection
 * @class ListCollection
 * @constructor
 * @extends Backbone.Collection
 */
App.ListCollection = Backbone.Collection.extend({
    model: App.List,
    comparator: function(item) {
        if (!_.isUndefined(this.sortKey)) {
            if (this.sortKey === 'position') {
                return this.sortDirection === 'desc' ? -item.get('position') : item.get('position');
            } else if (this.sortKey === 'name') {
                var str = '' + item.get('name'),
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
            } else if (this.sortKey === 'modified') {
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
    storeName: 'list',
    search: function(letters) {
        if (letters === '') return this;
        var pattern = new RegExp(letters, 'gi');
        return _(this.filter(function(data) {
            return pattern.test(data.get('name'));
        }));
    },
    next: function(list) {
        return this.at(this.indexOf(list) + 1);
    },
    previous: function(list) {
        return this.at(this.indexOf(list) - 1);
    }
});
