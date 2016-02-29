/**
 * @fileOverview This file has functions related to Sort list view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list model. @see Available Object in App.ListView
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * SortList View
 * @class SortListView
 * @constructor
 * @extends Backbone.View
 */
App.SortListView = Backbone.View.extend({
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
    template: JST['templates/sort_list'],
    tagName: 'li',
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
            model: this.model
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
		$('#js-card-listing-' + self.model.attributes.id).html('');
		if (!_.isEmpty(filtered_cards)) {
			_.each(filtered_cards, function(card) {
                card.set('list_name', _.escape(self.model.attributes.name));
            });
            var cards = new App.CardCollection();
			if (this.sort_by === sort_by) {
                cards.sortDirection = 'asc';
                this.sort_by = '-' + sort_by;
            } else {
                cards.sortDirection = 'desc';
                this.sort_by = sort_by;
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
				is_card_empty = false;
				card.list_name = _.escape(self.model.attributes.name);
				card.list_id = self.model.attributes.id;
				card.board_users = self.model.board_users;
				card.labels.add(card.attributes.card_labels, {
					silent: true
				});
				card.cards.add(self.model.cards, {
					silent: true
				});
				card.list = self.model;
				card.board_activities.add(self.model.activities, {
					silent: true
				});
				view = new App.CardView({
					tagName: 'div',
					model: card,
					converter: self.converter
				});
				$('#js-card-listing-' + self.model.attributes.id).append(view.render().el);
            }
        }
		if (is_card_empty) {
			view = new App.CardView({
				tagName: 'div',
				className: '',
				model: null,
				converter: self.converter
			});
            view.render();
        }
    }
});