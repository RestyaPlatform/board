/**
 * @fileOverview This file has functions related to switch to list view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardLabelsForm View
 * @class CardLabelsFormView
 * @constructor
 * @extends Backbone.View
 */
App.SwitchToListView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.sort_by = null;
        this.render();
    },
    template: JST['templates/switch_to_list_form'],
    tagName: 'table',
    className: 'table',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-sort-by': 'sortBy'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            board: this.model
        }));
        this.showTooltip();
        return this;
    },
    /**
     * sortBy()
     * toggle thr label filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    sortBy: function(e) {
        e.preventDefault();
        var self = this;
        var sort_by = $(e.target).data('sort-by');
        var filtered_cards = self.model.cards.filter(function(card) {
            return parseInt(card.attributes.is_archived) === 0;
        });
        var is_card_empty = true;
        var view = '';
        $('.js-card-list-view-' + self.model.attributes.id).html('');
        if (!_.isEmpty(filtered_cards)) {
            _.each(filtered_cards, function(card) {
                var list = self.model.lists.findWhere({
                    id: card.attributes.list_id,
                    is_archived: 0
                });
                card.set('list_name', _.escape(list.attributes.name));
            });
            var cards = new App.CardCollection();
            if (this.sort_by === sort_by) {
                cards.sortDirection = 'asc';
                this.sort_by = '-' + sort_by;
                if ($(e.target).children('span').hasClass('icon-caret-down')) {
                    $('.js-sort-by').children('span').removeClass('icon-caret-up hide icon-caret-down');
                    $(e.target).children('span').removeClass('icon-caret-down').addClass('icon-caret-up');
                } else {
                    $('.js-sort-by').children('span').removeClass('icon-caret-up hide icon-caret-down');
                    $(e.target).children('span').removeClass('icon-caret-up').addClass('icon-caret-down');
                }
            } else {
                cards.sortDirection = 'desc';
                this.sort_by = sort_by;
                if ($(e.target).children('span').hasClass('icon-caret-up')) {
                    $('.js-sort-by').children('span').removeClass('icon-caret-up hide icon-caret-down');
                    $(e.target).children('span').removeClass('icon-caret-up').addClass('icon-caret-down');
                } else {
                    $('.js-sort-by').children('span').removeClass('icon-caret-up hide icon-caret-down');
                    $(e.target).children('span').removeClass('icon-caret-down').addClass('icon-caret-up');
                }
            }
            cards.comparator = function(item) {
                var str = '' + item.get(sort_by);
                if (sort_by === 'name' || sort_by === 'list_name') {
                    str = str.toLowerCase();
                    str = str.split('');
                    str = _.map(str, function(letter) {
                        if (cards.sortDirection.toLowerCase() === 'desc') {
                            return String.fromCharCode(-(letter.charCodeAt(0)));
                        } else {
                            return String.fromCharCode((letter.charCodeAt(0)));
                        }
                    });
                    return str;
                } else if (sort_by === 'due_date') {
                    if (item.get('due_date') !== null) {
                        var date = item.get('due_date').split(' ');
                        if (!_.isUndefined(date[1])) {
                            _date = date[0] + 'T' + date[1];
                        } else {
                            _date = date[0];
                        }
                        sort_date = new Date(_date);
                        return cards.sortDirection === 'desc' ? -sort_date.getTime() : sort_date.getTime();
                    }
                } else {
                    if (cards.sortDirection === 'desc') {
                        return -item.get(sort_by);
                    } else {
                        return item.get(sort_by);
                    }
                }
            };
            cards.reset(filtered_cards);
            for (var i = 0; i < cards.models.length; i++) {
                var card = cards.models[i];
                var list = self.model.lists.findWhere({
                    id: card.attributes.list_id,
                    is_archived: 0
                });
                if (!_.isUndefined(list)) {
                    is_card_empty = false;
                    card.list_name = _.escape(list.attributes.name);
                    card.list_id = list.attributes.id;
                    card.board_users = self.model.board_users;
                    card.labels.add(card.attributes.card_labels, {
                        silent: true
                    });
                    card.cards.add(self.model.cards, {
                        silent: true
                    });
                    card.list = list;
                    card.board_activities.add(self.model.activities, {
                        silent: true
                    });
                    view = new App.CardView({
                        tagName: 'tr',
                        className: 'js-show-modal-card-view',
                        model: card,
                        template: 'list_view'
                    });
                    $('.js-card-list-view-' + self.model.attributes.id).append(view.render().el);
                }
            }
        }
        if (is_card_empty) {
            view = new App.CardView({
                tagName: 'tr',
                className: '',
                model: null,
                board_id: this.model.id,
                template: 'list_view'
            });
            view.render();
        }
    }
});
