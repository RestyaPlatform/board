/**
 * @fileOverview This file has functions related to activity view.
 * This view calling from board, card checklist, card checklist item, footer, list, modal card, modal activity and modal user activity view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activity model and it's related values
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * Activity View
 * @class ActivityView
 * @constructor
 * @extends Backbone.View
 */
App.ActivityView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.type = options.type;
        this.board = options.board;
    },
    converter: new Showdown.converter(),
    template: JST['templates/activity'],
    tagName: 'li',
    className: 'btn-block col-xs-12 js-activity',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-undo': 'undo',
        'click .js-undo2': 'undo_all',
        'click .js-open-card-view': 'triggerOpenModal',

    },
    triggerOpenModal: function(e) {
        var self = this;
        var target = $(e.target);
        var card_id = target.data('card_id');
        if (card_id !== undefined && card_id !== null && ($('#js-card-' + card_id).length !== 0)) {
            $('#js-card-' + card_id).trigger('click');
        } else {
            return true;
        }
        return false;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var current_user_can_undo_it = false;
        if (!_.isUndefined(App.boards) && !_.isEmpty(this.model) && !_.isUndefined(this.model.attributes.board_id) && !_.isUndefined(App.boards.get(this.model.attributes.board_id))) {
            var board_users = App.boards.get(this.model.attributes.board_id).attributes.users;
            _.each(board_users, function(board_user) {
                if (parseInt(board_user.user_id) === parseInt(authuser.user.id) && board_user.is_admin === true) {
                    current_user_can_undo_it = true;
                }
            });
        }
        this.$el.html(this.template({
            activity: this.model,
            type: this.type,
            converter: this.converter,
            current_user_can_undo_it: current_user_can_undo_it
        }));
        if (!_.isEmpty(this.model)) {
            this.$el.addClass('js-list-activity-' + this.model.attributes.id);
            if (this.model.attributes.depth !== 0) {
                var col_offset = parseInt(this.model.attributes.depth);
                this.$el.addClass('col-lg-offset-' + col_offset);
            }
        }
        this.showTooltip();
        return this;
    },
    /**
     * undo()
     * revert changes to the previous version
     * @param NULL
     * @return false
     */
    undo: function(e) {
        var self = this;
        e.preventDefault();
        this.model.url = api_url + 'activities/undo/' + this.model.id + '.json';
        this.model.save({}, {
            patch: true,
            success: function(model, response) {
                if (!_.isUndefined(response.undo.card)) {
                    var card = self.board.cards.findWhere({
                        id: parseInt(response.undo.card.id)
                    });
                    card.set(response.undo.card);
                    _.each(response.undo.card, function(val, key) {
                        if (key === 'id' || key === 'list_id' || key === 'board_id') {
                            card.set(key, parseInt(val));
                        }
                        var activity = new App.Activity();
                        activity.set(response.activity);
                        card.activities.unshift(activity);
                    });

                    var view_activity = this.$('#js-card-activities-' + response.undo.card.id);
                    view_activity.html('');
                    if (!_.isEmpty(card.activities)) {
                        card.activities.each(function(activity) {
                            $('#js-loader-img').removeClass('hide');
                            if (!_.isEmpty(self.model.collection)) {
                                activity.cards.add(self.model.collection.models);
                            }
                            if (!_.isUndefined(response.undo.update_card_comment)) {
                                if (activity.attributes.id == response.undo.update_card_comment) {
                                    activity.attributes.comment = response.undo.card.comment;
                                }
                            }
                            var view = new App.ActivityView({
                                model: activity,
                                board: self.board
                            });
                            view_activity.append(view.render().el).find('.timeago').timeago();
                            $('#js-loader-img').addClass('hide');
                        });
                    }
                } else if (!_.isUndefined(response.undo.list)) {
                    var list = self.board.lists.findWhere({
                        id: parseInt(response.undo.list.id)
                    });
                    list.set(response.undo.list);
                    _.each(response.undo.list, function(val, key) {
                        if (key === 'id' || key === 'board_id') {
                            list.set(key, parseInt(val));
                        }
                    });
                } else if (!_.isUndefined(response.undo.board)) {
                    board.set(response.undo.board);
                    _.each(response.undo.board, function(val, key) {
                        if (key === 'id' || key === 'user_id') {
                            board.set(key, parseInt(val));
                        }
                    });
                }
                return false;
            }
        });
        return false;
    },
    /**
     * undo_all()
     * revert changes to the previous version
     * @param NULL
     * @return false
     */
    undo_all: function(e) {
        var self = this;
        e.preventDefault();
        this.model.url = api_url + 'activities/undo/' + this.model.id + '.json';
        this.model.save({}, {
            patch: true,
            success: function(model, response) {
                self.flash('danger', "Undo Succeed");
            }
        });
        return false;
    }
});
