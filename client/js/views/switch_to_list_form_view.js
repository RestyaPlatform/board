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
        _.bindAll(this, 'sortLabelPosition', 'render', 'resetLabelField');
        this.model.bind('change:board_custom_fields', this.sortLabelPosition);
        this.model.bind('change:board_custom_fields', this.resetLabelField);
        this.sort_by = null;
        this.render();
    },
    attributes: {
        id: 'js-board-lists'
    },
    template: JST['templates/switch_to_list_form'],
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
        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_listview_configure', APPS.enabled_apps) !== -1) {
            this.resetLabelField();
            this.sortLabelPosition();
        }
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
                if (!_.isUndefined(list) && !_.isEmpty(list)) {
                    card.set('list_name', _.escape(list.attributes.name));
                }
                card.labels.each(function(label, key) {
                    if (!_.isUndefined(label) && label.attributes.name !== "") {
                        if (key === 0) {
                            card.set('sort_group_label', label.attributes.name);
                        }
                    }
                });
                card.users.each(function(user, key) {
                    if (!_.isUndefined(user) && user.attributes.username !== "") {
                        if (key === 0) {
                            card.set('sort_group_user', user.attributes.username);
                        }
                    }
                });
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
                if (sort_by === 'name' || sort_by === 'list_name' || sort_by === 'sort_group_label' || sort_by === 'sort_group_user') {
                    str = str.toLowerCase();
                    if (str !== 'undefined' && !_.isUndefined(str) && !_.isEmpty(str) && str !== null) {
                        str = str.split('');
                        str = _.map(str, function(letter) {
                            if (cards.sortDirection.toLowerCase() === 'desc') {
                                return String.fromCharCode(-(letter.charCodeAt(0)));
                            } else {
                                return String.fromCharCode((letter.charCodeAt(0)));
                            }
                        });
                        return str;
                    }
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
                        className: 'js-show-modal-card-view cur txt-aligns js-listview-list-id-' + card.attributes.list_id,
                        id: 'js-card-' + card.attributes.id,
                        model: card,
                        template: 'list_view'
                    });
                    $('.js-card-list-view-' + self.model.attributes.id).append(view.render().el);
                }
            }
            if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_listview_configure', APPS.enabled_apps) !== -1) {
                this.resetLabelField();
                this.sortLabelPosition();
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
    },
    /**
     * Listviewposition()
     * toggle thr label filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    sortLabelPosition: function() {
        var wrapper = this.$el.find('#list_view_configuration_label'),
            items = wrapper.children(),
            r_listview_configure_positions, temp_dom = [];
        if (!_.isEmpty(this.model.attributes.board_custom_fields) && !_.isUndefined(this.model.attributes.board_custom_fields)) {
            board_custom_fields = JSON.parse(this.model.attributes.board_custom_fields);
            if (!_.isUndefined(board_custom_fields.r_listview_configure_position) && !_.isUndefined(board_custom_fields.r_listview_configure_position)) {
                r_listview_configure_positions = board_custom_fields.r_listview_configure_position.split(',');
                items.each(function(label, key) {
                    temp_dom.push(key.id);
                });
                wrapper.prepend($.map(r_listview_configure_positions, function(v) {
                    var list_index = temp_dom.findIndex(function(item) {
                        return item === 'list_view_config_label-' + v;
                    });
                    return items[list_index];
                }));
            }
        }
    },
    /**
     * ListviewHide()
     * toggle thr label filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    resetLabelField: function() {
        var r_listview_configure;
        var field_wrapper = this.$el.find('#list_view_configuration_label'),
            field_wrapper_items = field_wrapper.children();
        if (!_.isEmpty(this.model.attributes.board_custom_fields) && !_.isUndefined(this.model.attributes.board_custom_fields)) {
            board_custom_fields = JSON.parse(this.model.attributes.board_custom_fields);
            if (!_.isUndefined(board_custom_fields.r_listview_configure) && !_.isUndefined(board_custom_fields.r_listview_configure)) {
                r_listview_configure = board_custom_fields.r_listview_configure.split(',');
                field_wrapper_items.each(function(label, key) {
                    if (r_listview_configure.indexOf($(key).data('field-name')) === -1) {
                        if ($(key).data('field-name') === 'id') {
                            $(key).addClass('hide');
                        } else {
                            $(key).hide();
                        }
                    } else {
                        if ($(key).data('field-name') === 'id') {
                            $(key).removeClass('hide');
                        } else {
                            $(key).show();
                        }
                    }
                });
            }
        }
    }
});
