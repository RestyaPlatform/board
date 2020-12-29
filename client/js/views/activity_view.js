/**
 * @fileOverview This file has functions related to activity view.
 * This view calling from board, card checklist, card checklist item, footer, list, modal card, modal activity and modal user activity view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: activity model and it's related values
 */
if (typeof App === 'undefined') {
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
        var self = this;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        _.bindAll(this, 'render', 'undo', 'undo_all');
        this.type = options.type;
        this.is_from = options.is_from;
        this.flag = 2;
        if (!_.isUndefined(options.flag)) {
            this.flag = options.flag;
        }
        if (!_.isUndefined(options.board)) {
            this.board = options.board;
        }
        if (!_.isUndefined(authuser.user) && !_.isEmpty(this.model) && !_.isUndefined(this.model.board_users)) {
            var board_user_role_id = this.model.board_users.findWhere({
                user_id: parseInt(authuser.user.id)
            });
            if (!_.isEmpty(board_user_role_id)) {
                this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
            }
        }
        emojify.run();
    },
    converter: new showdown.Converter({
        extensions: window.extensionslist
    }),
    template: JST['templates/activity'],
    tagName: 'li',
    className: 'js-activity activity-github-styles',
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
        this.converter.setFlavor('github');
        this.$el.html(this.template({
            activity: this.model,
            type: this.type,
            converter: this.converter,
            board: this.board
        }));
        var listing_type = '';
        if (this.type) {
            listing_type = this.type;
        }
        if (!_.isEmpty(this.model)) {
            this.$el.addClass('js-list-activity-' + this.model.attributes.id);
            if (this.model.attributes.depth !== 0) {
                if (listing_type === 'modal_card') {
                    var column = 12 - parseInt(this.model.attributes.depth);
                    var col_offset = parseInt(this.model.attributes.depth);
                    this.$el.addClass('col-xs-' + column);
                    this.$el.addClass('col-lg-offset-' + col_offset);
                } else if (this.$el.attr('class').indexOf('col-xs-12') === -1) {
                    this.$el.addClass('col-xs-12');
                }
            } else {
                this.$el.addClass('col-xs-12');
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
                    if (!_.isUndefined(self.board) && !_.isEmpty(self.board) && self.board !== null && !_.isUndefined(self.board.cards) && !_.isEmpty(self.board.cards) && self.board.cards !== null) {
                        var card = self.board.cards.findWhere({
                            id: parseInt(response.undo.card.id)
                        });
                        if (!_.isUndefined(card) && !_.isEmpty(card) && card !== null) {
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
                                    if (!_.isUndefined(response.undo.edit_comment)) {
                                        if (activity.attributes.id == response.undo.edit_comment) {
                                            activity.attributes.comment = response.undo.card.comment;
                                        }
                                    }
                                    var view = new App.ActivityView({
                                        model: activity,
                                        board: self.board
                                    });
                                    view_activity.append(view.render().el);
                                    emojify.run();
                                    $('#js-loader-img').addClass('hide');
                                });
                            }
                        }
                    }
                } else if (!_.isUndefined(response.undo.list)) {
                    if (!_.isUndefined(self.board) && !_.isEmpty(self.board) && self.board !== null && !_.isUndefined(self.board.lists) && !_.isEmpty(self.board.lists) && self.board.lists !== null) {
                        var list = self.board.lists.findWhere({
                            id: parseInt(response.undo.list.id)
                        });
                        if (!_.isUndefined(list) && !_.isEmpty(list) && list !== null) {
                            list.set(response.undo.list);
                            _.each(response.undo.list, function(val, key) {
                                if (key === 'id' || key === 'board_id') {
                                    list.set(key, parseInt(val));
                                }
                            });
                        }
                    }
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
        e.preventDefault();
        var self = this;
        this.model.url = api_url + 'activities/undo/' + this.model.id + '.json';
        this.model.save({}, {
            patch: true,
            success: function(model, response) {
                self.flash('danger', i18next.t('Undo Succeed'));
                if (!_.isUndefined(self.board) && !_.isEmpty(self.board) && self.board !== null) {
                    if (!_.isUndefined(response.undo.card)) {
                        if (!_.isUndefined(self.board.cards) && !_.isEmpty(self.board.cards) && self.board.cards !== null) {
                            var card = self.board.cards.findWhere({
                                id: parseInt(response.undo.card.id)
                            });
                            if (!_.isUndefined(card) && !_.isEmpty(card) && card !== null) {
                                card.set(response.undo.card);
                                _.each(response.undo.card, function(val, key) {
                                    if (key === 'id' || key === 'list_id' || key === 'board_id') {
                                        card.set(key, parseInt(val));
                                    }
                                    var activity = new App.Activity();
                                    activity.set(response.activity);
                                    if (!_.isUndefined(card.activities)) {
                                        card.activities.unshift(activity);
                                    }
                                });
                                var view_activity = this.$('#js-card-activities-' + response.undo.card.id);
                                view_activity.html('');
                                if (!_.isEmpty(card.activities)) {
                                    card.activities.each(function(activity) {
                                        $('#js-loader-img').removeClass('hide');
                                        if (!_.isEmpty(self.model.collection)) {
                                            activity.cards.add(self.model.collection.models);
                                        }
                                        if (!_.isUndefined(response.undo.edit_comment)) {
                                            if (activity.attributes.id == response.undo.edit_comment) {
                                                activity.attributes.comment = response.undo.card.comment;
                                            }
                                        }
                                        var view = new App.ActivityView({
                                            model: activity,
                                            board: self.board
                                        });
                                        view_activity.append(view.render().el);
                                        emojify.run();
                                        $('#js-loader-img').addClass('hide');
                                    });
                                }
                            }
                        }
                    } else if (!_.isUndefined(response.undo.list)) {
                        if (!_.isUndefined(self.board.lists) && !_.isEmpty(self.board.lists) && self.board.lists !== null) {
                            var list = self.board.lists.findWhere({
                                id: parseInt(response.undo.list.id)
                            });
                            if (!_.isUndefined(response.undo.list.is_archived)) {
                                response.undo.list.is_archived = (response.undo.list.is_archived == 'f') ? 0 : 1;
                            }
                            if (!_.isUndefined(list) && !_.isEmpty(list) && list !== null) {
                                list.set(response.undo.list);
                                _.each(response.undo.list, function(val, key) {
                                    if (key === 'id' || key === 'board_id') {
                                        list.set(key, parseInt(val));
                                    }
                                });
                            }
                        }
                    } else if (!_.isUndefined(response.undo.board)) {
                        self.board.set(response.undo.board);
                        _.each(response.undo.board, function(val, key) {
                            if (key === 'id' || key === 'user_id') {
                                self.board.set(key, parseInt(val));
                            }
                        });
                    } else if (!_.isUndefined(response.undo.checklist)) {
                        if (!_.isUndefined(self.board.checklists) && !_.isEmpty(self.board.checklists) && self.board.checklists !== null) {
                            var checklist = self.board.checklists.findWhere({
                                id: parseInt(response.undo.checklist.id)
                            });
                            if (!_.isUndefined(checklist) && !_.isEmpty(checklist) && checklist !== null) {
                                checklist.set(response.undo.checklist);
                            }
                        }
                    } else if (!_.isUndefined(response.undo.checklist_item)) {
                        if (!_.isUndefined(self.board.checklist_items) && !_.isEmpty(self.board.checklist_items) && self.board.checklist_items !== null) {
                            var checklist_item = self.board.checklist_items.findWhere({
                                id: parseInt(response.undo.checklist_item.id)
                            });
                            if (!_.isUndefined(checklist_item) && !_.isEmpty(checklist_item) && checklist_item !== null) {
                                checklist_item.set(response.undo.checklist_item);
                            }
                        }
                    }
                }
                return false;
            }
        });
        return false;
    }
});
