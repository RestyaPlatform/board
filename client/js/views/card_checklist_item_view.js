/**
 * @fileOverview This file has functions related to card checklist item view. This view calling from card checklist view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: checklist item model.
 *	this.model.checklist			: checklist model. @see Available Object in CardCheckListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardCheckListItem View
 * @class CardCheckListItemView
 * @constructor
 * @extends Backbone.View
 */
App.CardCheckListItemView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        _.bindAll(this, 'render', 'renderChecklistitemsCollection');
        this.model.bind('change:is_completed', this.renderChecklistitemsCollection);
        var board_user_role_id = this.model.board_users.findWhere({
            user_id: parseInt(authuser.user.id)
        });
        if (!_.isEmpty(board_user_role_id)) {
            this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
        }
    },
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
    template: JST['templates/card_checklist_item'],
    className: function() {
        var class_name = 'js-checklist-item btn-block pull-left';
        if (!_.isUndefined(authuser.user)) {
            class_name += ' cur-grab';
        }
        return class_name;

    },
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-show-item-edit-form': 'showItemEditForm',
        'submit form.js-item-edit-form': 'updateItem',
        'click a.js-hide-item-edit-form': 'hideChecklistEditForm',
        'click .js-show-confirm-item-delete': 'showConfirmItemDelete',
        'click .js-delete-item': 'deleteItem',
        'click .js-markas-completed': 'markAsCompleted',
        'click .js-markas-incomplete': 'markAsIncomplete',
        'click .js-show-item-options': 'showItemOptions',
        'click .js-show-mention-member-form': 'showMentionMemberForm',
        'click .js-show-emoji-list-form': 'showEmojiList',
        'click .js-convert-to-card': 'convertToCard',
        'keyup .js-item-search-member': 'showSearchItemMembers',
        'click .js-back-to-item-options': 'backToItemOptions',
        'click .js-edit-item-member': 'editItemMember',
        'click .js-no-action': 'noAction',
        'itemSort': 'itemSort'
    },
    /**
     * listSort()
     * save the list moved position
     * @param e
     * @type Object(DOM event)
     * @param data
     * @type Object
     *
     */
    itemSort: function(ev, ui) {
        var target = $(ev.target);
        var data = {},
            before, after, difference, newPosition;
        var checklist_id = parseInt(target.parents('.js-checklist-items-sorting:first').data('checklist_id'));
        var previous_item_id = target.prev('.js-checklist-item').data('item_id');
        var next_item_id = target.next('.js-checklist-item').data('item_id');
        var checklistItems = this.model.card.list.collection.board.checklist_items.where({
            card_id: parseInt(this.model.card.id)
        });
        var checklist_items = new App.CheckListItemCollection();
        checklist_items.add(checklistItems);
        this.model.url = api_url + 'boards/' + this.model.card.get('board_id') + '/lists/' + this.model.card.get('list_id') + '/cards/' + this.model.card.id + '/checklists/' + this.model.attributes.checklist_id + '/items/' + this.model.id + '.json';
        if ((typeof previous_item_id == 'undefined' && typeof next_item_id == 'undefined') || checklist_id != this.model.attributes.checklist_id) {
            this.model.card.list.collection.board.checklists.get(this.model.attributes.checklist_id).checklist_items.remove(this.model, {
                silent: true
            });
            data.checklist_id = checklist_id;
        }
        if (typeof previous_item_id != 'undefined') {
            before = checklist_items.get(previous_item_id);
            after = checklist_items.next(before);
            if (typeof after == 'undefined') {
                afterPosition = before.position() + 2;
            } else {
                afterPosition = after.position();
            }
            difference = (afterPosition - before.position()) / 2;
            newPosition = difference + before.position();
            this.model.set({
                position: newPosition
            });
        } else if (typeof next_item_id != 'undefined') {
            after = checklist_items.get(next_item_id);
            before = checklist_items.previous(after);
            if (typeof before == 'undefined') {
                beforePosition = 0.0;
            } else {
                beforePosition = before.position();
            }
            difference = (after.position() - beforePosition) / 2;
            newPosition = difference + beforePosition;
            this.model.set({
                position: newPosition
            });
            this.model.collection.sort({
                silent: true
            });
        }
        this.model.set('checklist_id', checklist_id);
        data.position = this.model.attributes.position;
        this.model.card.list.collection.board.checklists.get(checklist_id).checklist_items.add(this.model, {
            silent: true
        });
        this.model.save(data, {
            patch: true
        });
        this.renderProgress();
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
            checklist_item: this.model,
            converter: this.converter,
        }));
        this.showTooltip();
        emojify.run();
        return this;
    },
    /**
     * renderChecklistitemsCollection()
     * display checklist item completed progress bar
     * return object
     *
     */
    renderChecklistitemsCollection: function() {
        this.render();
        this.renderProgress();
    },
    /**
     * renderProgress()
     * display checklist item completed progress bar
     * return object
     *
     */
    renderProgress: function() {
        var checklist_id = this.model.get('checklist_id');
        var checklist_items = this.model.collection.where({
            checklist_id: checklist_id
        });
        items = new App.CheckListItemCollection();
        items.add(checklist_items);
        var completed_count = items.filter(function(checklist_item) {
            return parseInt(checklist_item.get('is_completed')) === 1;
        }).length;
        var total_count = items.models.length;
        completed_count = 0 < total_count ? Math.round(100 * completed_count / total_count) : 0;
        $('#js-checklist-progress-percent-' + checklist_id).text(completed_count + '%');
        $('#js-checklist-progress-bar-' + checklist_id).stop().animate({
            'width': completed_count + '%',
            '-moz-transition': 'all .6s ease',
            '-ms-transition': 'all .6s ease',
            '-o-transition': 'all .6s  ease',
            '-webkit-transition': 'all .6s  ease',
            'transition': 'all .6s  ease'
        }, 100);
        emojify.run();
        return this;
    },
    /**
     * showItemEditForm()
     * show checklist item edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showItemEditForm: function(e) {
        var target = $(e.target);
        if (target.is('a')) {
            return true;
        } else {
            var prev_form = $('form.js-item-edit-form');
            $(prev_form).parent().find('.js-show-item-edit-form').removeClass('hide');
            prev_form.remove();
            $('#js-checklist-item-' + this.model.id).addClass('hide');
            $('#js-checklist-item-' + this.model.id).after(new App.ChecklistItemEditFormView({
                model: this.model
            }).el);
            return false;
        }
    },
    /**
     * hideChecklistEditForm()
     * hide checklist item edit form
     * @param e
     * @type Object(DOM event)
     *
     */
    hideChecklistEditForm: function(e) {
        e.preventDefault();
        var form = $('form.js-item-edit-form');
        form.prev('.js-show-item-edit-form').removeClass('hide');
        $('#js-checklist-item-' + this.model.id).html(this.converter.makeHtml($('textarea', form).val()));
        form.remove();
        emojify.run();
    },
    /**
     * updateItem()
     * update checklist item edit
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    updateItem: function(e) {
        e.preventDefault();
        var data = $(e.target).serializeObject();
        this.model.url = api_url + 'boards/' + this.model.card.get('board_id') + '/lists/' + this.model.card.get('list_id') + '/cards/' + this.model.card.id + '/checklists/' + this.model.attributes.checklist_id + '/items/' + this.model.id + '.json';
        this.model.set(data);
        this.render();
        this.model.save(data, {
            patch: true,
            success: function(model, response) {
                if (!_.isUndefined(response.activity)) {
                    response.activity = activityCommentReplace(response.activity);
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    var view_act = new App.ActivityView({
                        model: activity
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + parseInt(response.activity.card_id));
                    view_activity.prepend(view_act.render().el);
                }
            }
        });
        emojify.run();
        return false;
    },
    /**
     * showConfirmItemDelete()
     * display checklist item delete confirmation form
     * @param e
     * @type Object(DOM event)
     *
     */
    showConfirmItemDelete: function(e) {
        e.preventDefault();
        $('#js-item-actions-response-' + this.model.id).html(new App.ChecklistItemDeleteConfirmFormView({
            model: this.model
        }).el);
    },
    /**
     * deleteItem()
     * delete checklist item
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    deleteItem: function() {
        this.$el.remove();
        this.model.url = api_url + 'boards/' + this.model.card.get('board_id') + '/lists/' + this.model.card.get('list_id') + '/cards/' + this.model.card.id + '/checklists/' + this.model.attributes.checklist_id + '/items/' + this.model.id + '.json';
        var checklist_item_id = this.model.id;
        var checkList_item;
        _.each(this.model.card.list.collection.board.checklist_items.models, function(checklistItem) {
            if (checklist_item_id === checklistItem.attributes.id) {
                checkList_item = checklistItem;
            }
        });
        var bool = checkList_item.attributes.is_completed;
        if (bool) {
            this.model.set('is_completed', 1);
            this.model.checklist.set('checklist_item_completed_count', parseInt(this.model.checklist.get('checklist_item_completed_count')) - 1);
            this.model.checklist.card.set('checklist_item_completed_count', parseInt(this.model.checklist.card.attributes.checklist_item_completed_count) - 1);
            this.model.checklist.card.list.collection.board.cards.get(this.model.checklist.card).set('checklist_item_completed_count', this.model.checklist.card.attributes.checklist_item_completed_count, {
                silent: true
            });
        } else {
            this.model.checklist.set('checklist_item_pending_count', parseInt(this.model.checklist.get('checklist_item_pending_count')) - 1);
            this.model.checklist.card.set('checklist_item_pending_count', parseInt(this.model.checklist.card.attributes.checklist_item_pending_count) - 1);
            this.model.checklist.card.list.collection.board.cards.get(this.model.checklist.card).set('checklist_item_pending_count', this.model.checklist.card.attributes.checklist_item_pending_count, {
                silent: true
            });
        }
        this.model.checklist.set('checklist_item_count', parseInt(this.model.checklist.get('checklist_item_count')) - 1);
        this.model.checklist.card.set('checklist_item_count', parseInt(this.model.checklist.card.attributes.checklist_item_count) - 1);
        this.model.checklist.card.list.collection.board.cards.get(this.model.checklist.card).set('checklist_item_count', this.model.checklist.card.attributes.checklist_item_count, {
            silent: true
        });
        this.render();
        this.renderProgress();
        this.model.destroy({
            success: function(model, response) {
                if (!_.isUndefined(response.activity)) {
                    response.activity = activityCommentReplace(response.activity);
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    var view_act = new App.ActivityView({
                        model: activity
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + parseInt(response.activity.card_id));
                    view_activity.prepend(view_act.render().el);
                }
            }
        });
        return false;
    },
    /**
     * markAsCompleted()
     * mark checklist item as completed
     * @param e
     * @type Object(DOM event)
     *
     */
    markAsCompleted: function(e) {
        e.preventDefault();
        var self = this;
        this.model.url = api_url + 'boards/' + this.model.card.get('board_id') + '/lists/' + this.model.card.get('list_id') + '/cards/' + this.model.card.id + '/checklists/' + this.model.attributes.checklist_id + '/items/' + this.model.id + '.json';
        this.model.set('is_completed', 1);
        this.model.checklist.checklist_item_completed_count = parseInt(this.model.checklist.get('checklist_item_completed_count')) + 1;
        this.model.checklist.checklist_item_pending_count = parseInt(this.model.checklist.get('checklist_item_pending_count')) - 1;
        this.model.checklist.card.list.collection.board.cards.get(this.model.checklist.card).checklist_item_completed_count = this.model.checklist.card.attributes.checklist_item_completed_count;
        this.model.checklist.card.list.collection.board.cards.get(this.model.checklist.card).checklist_item_pending_count = this.model.checklist.card.attributes.checklist_item_pending_count;
        this.model.checklist.card.set('checklist_item_completed_count', parseInt(this.model.checklist.card.attributes.checklist_item_completed_count) + 1);
        this.model.checklist.card.set('checklist_item_pending_count', parseInt(this.model.checklist.card.attributes.checklist_item_pending_count) - 1);
        this.model.save({
            is_completed: 1
        }, {
            silent: true,
            patch: true,
            success: function(model, response) {
                var activity = new App.Activity();
                response.activity = activityCommentReplace(response.activity);
                activity.set(response.activity);
                var view = new App.ActivityView({
                    model: activity
                });
                model.set('activities', activity, {
                    silent: true
                });
                var view_activity = $('#js-card-activities-' + self.model.card.id);
                view_activity.prepend(view.render().el);
            }
        });
    },
    /**
     * markAsIncomplete()
     * mark checklist item as incompleted
     * @param e
     * @type Object(DOM event)
     *
     */
    markAsIncomplete: function(e) {
        e.preventDefault();
        var self = this;
        this.model.url = api_url + 'boards/' + this.model.card.get('board_id') + '/lists/' + this.model.card.get('list_id') + '/cards/' + this.model.card.id + '/checklists/' + this.model.attributes.checklist_id + '/items/' + this.model.id + '.json';
        this.model.set('is_completed', 0);
        this.model.checklist.checklist_item_completed_count = parseInt(this.model.checklist.get('checklist_item_completed_count')) - 1;
        this.model.checklist.checklist_item_pending_count = parseInt(this.model.checklist.get('checklist_item_pending_count')) + 1;
        this.model.checklist.card.set('checklist_item_completed_count', parseInt(this.model.checklist.card.attributes.checklist_item_completed_count) - 1);
        this.model.checklist.card.set('checklist_item_pending_count', parseInt(this.model.checklist.card.attributes.checklist_item_pending_count) + 1);
        this.model.checklist.card.list.collection.board.cards.get(this.model.checklist.card).checklist_item_completed_count = this.model.checklist.card.attributes.checklist_item_completed_count;
        this.model.checklist.card.list.collection.board.cards.get(this.model.checklist.card).checklist_item_pending_count = this.model.checklist.card.attributes.checklist_item_pending_count;
        this.model.save({
            is_completed: 0
        }, {
            silent: true,
            patch: true,
            success: function(model, response) {
                var activity = new App.Activity();
                response.activity = activityCommentReplace(response.activity);
                activity.set(response.activity);
                var view = new App.ActivityView({
                    model: activity
                });
                model.set('activities', activity, {
                    silent: true
                });
                var view_activity = $('#js-card-activities-' + self.model.card.id);
                view_activity.prepend(view.render().el);
            }
        });
    },
    /**
     * showItemOptions()
     * show checklist item actions
     * @param e
     * @type Object(DOM event)
     *
     */
    showItemOptions: function(e) {
        e.preventDefault();
        $('#js-item-option-response-' + this.model.id).html(new App.ChecklistItemActionsView({
            model: this.model
        }).el);
    },
    /**
     * backToItemOptions()
     * show checklist item actions
     * @param e
     * @type Object(DOM event)
     *
     */
    backToItemOptions: function(e) {
        e.preventDefault();
        $('#js-item-option-response-' + this.model.id).html(new App.ChecklistItemActionsView({
            model: this.model
        }).el);
        return false;
    },
    /**
     * showMentionMemberForm()
     * show board member list form
     * @param e
     * @type Object(DOM event)
     * return false
     *
     */
    showMentionMemberForm: function(e) {
        e.preventDefault();
        $('#js-item-option-response-' + this.model.id).html(new App.ChecklistItemMentionMemberSerachFormView().el);
        this.$el.find('.js-item-member-search-response').html('');
        this.renderBoardUsers();
        return false;
    },
    /**
     * showEmojiList()
     * Show the emoji list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showEmojiList: function(e) {
        e.preventDefault();
        var emojiList = "smile,thumbsup,warning,sunglasses";
        var emojiListArray = emojiList.split(",");
        $('#js-item-option-response-' + this.model.id).html(new App.ChecklistItemEmojiListView({
            model: emojiListArray
        }).el);
        //$('.js-show-emoji-list-response ul').remove();
        emojify.run();
        return false;
    },
    /**
     * convertToCard()
     * convert checklist item to card
     *
     */
    convertToCard: function(e) {
        var self = this;
        e.preventDefault();
        var checklist_item_id = self.model.id;
        var checkList_item;
        _.each(self.model.card.list.collection.board.checklist_items.models, function(checklistItem) {
            if (checklist_item_id === checklistItem.attributes.id) {
                checkList_item = checklistItem;
            }
        });
        var option = {
            silent: true
        };
        var bool = checkList_item.attributes.is_completed;
        if (bool) {
            self.model.set('is_completed', 1, option);
            self.model.checklist.set('checklist_item_completed_count', parseInt(self.model.checklist.get('checklist_item_completed_count')) - 1, option);
            self.model.checklist.card.set('checklist_item_completed_count', parseInt(self.model.checklist.card.attributes.checklist_item_completed_count) - 1, option);
            self.model.checklist.card.list.collection.board.cards.get(self.model.checklist.card).set('checklist_item_completed_count', self.model.checklist.card.attributes.checklist_item_completed_count, {
                silent: true
            });
        } else {
            self.model.checklist.set('checklist_item_pending_count', parseInt(self.model.checklist.get('checklist_item_pending_count')) - 1, option);
            self.model.checklist.card.set('checklist_item_pending_count', parseInt(self.model.checklist.card.attributes.checklist_item_pending_count) - 1, option);
            self.model.checklist.card.list.collection.board.cards.get(self.model.checklist.card).set('checklist_item_pending_count', self.model.checklist.card.attributes.checklist_item_pending_count, {
                silent: true
            });
        }
        self.model.checklist.set('checklist_item_count', parseInt(self.model.checklist.get('checklist_item_count')) - 1, option);
        self.model.checklist.card.set('checklist_item_count', parseInt(self.model.checklist.card.attributes.checklist_item_count) - 1, option);
        self.model.checklist.card.list.collection.board.cards.get(self.model.checklist.card).set('checklist_item_count', self.model.checklist.card.attributes.checklist_item_count, {
            silent: true
        });
        var cards = self.model.card.list.collection.board.cards.where({
            list_id: parseInt(self.model.card.attributes.list_id)
        });
        var list_cards = new App.CardCollection();
        list_cards.add(cards);
        var currentdate = new Date();
        var tmp_created_date = currentdate.getFullYear() + '-' + (((currentdate.getMonth() + 1) < 10) ? '0' + (currentdate.getMonth() + 1) : (currentdate.getMonth() + 1)) + '-' + ((currentdate.getDate() < 10) ? '0' + currentdate.getDate() : currentdate.getDate()) + 'T' + currentdate.getHours() + ':' + (currentdate.getMinutes() < 10 ? '0' : '') + currentdate.getMinutes() + ':' + (currentdate.getSeconds() < 10 ? '0' : '') + currentdate.getSeconds();
        var tmp_card = new App.Card();
        tmp_card.set('is_offline', true);
        tmp_card.set('position', list_cards.length + 1);
        tmp_card.set('checklist_item_completed_count', 0);
        tmp_card.set('checklist_item_count', 0);
        tmp_card.set('checklist_item_pending_count', 0);
        var uuid = new Date().getTime();
        tmp_card.set({
            name: self.model.attributes.name,
            is_archived: 0,
            id: uuid,
            list_id: parseInt(self.model.card.attributes.list_id),
            board_id: parseInt(self.model.card.attributes.board_id),
            created: tmp_created_date,
            card_voter_count: 0,
            attachment_count: 0,
        }, {
            silent: true
        });
        list_cards.add(tmp_card);
        if (sort_by !== null && sort_direction !== null) {
            list_cards.sortByColumn(sort_by, sort_direction);
        } else {
            list_cards.sortByColumn('position');
        }
        var newpostionIndex;
        if (list_cards.models.length > 0) {
            for (i = 0; i < list_cards.models.length; i++) {
                if (list_cards.models[i].id === uuid) {
                    newpostionIndex = i;
                    break;
                }
            }
        }
        var position = newpostionIndex + 1;
        var card = new App.Card();
        card.url = api_url + 'boards/' + self.model.card.get('board_id') + '/lists/' + self.model.card.get('list_id') + '/cards/' + self.model.card.id + '/checklists/' + self.model.attributes.id + '/items/' + self.model.id + '/convert_to_card.json';
        card.save({}, {
            success: function(model, response) {
                self.deleteItem();
                card.set(response.cards);
                card.set('id', parseInt(response.cards.id));
                card.set('list_id', parseInt(response.cards.list_id));
                card.set('board_id', parseInt(response.cards.board_id));
                card.set('created', tmp_created_date);
                card.set('is_archived', 0);
                card.set('activity_count', 0);
                card.set('comment_count', 0);
                card.set('attachment_count', 0);
                card.set('card_voter_count', 0);
                card.set('cards_subscriber_count', 0);
                card.set('cards_user_count', 0);
                card.set('checklist_count', 0);
                card.set('checklist_item_count', 0);
                card.set('checklist_item_completed_count', 0);
                card.set('checklist_item_pending_count', 0);
                card.set('position', position);
                self.model.card.list.collection.board.cards.add(card);
            }
        });
    },
    /**
     * showSearchMembers()
     * display searched member list
     */
    showSearchItemMembers: function(e) {
        var self = this;
        var q = $(e.target).val();
        var view = this.$el.find('.js-item-member-search-response');
        if (q !== '') {
            var filtered_users = this.model.card.list.collection.board.board_users.search(q);
            var users = new App.UserCollection();
            if (!_.isEmpty(filtered_users._wrapped)) {
                $.unique(filtered_users._wrapped);
            }
            users.add(filtered_users._wrapped);
            $('.js-item-member-search-response').html('');
            if (!_.isEmpty(users.models)) {
                users.each(function(board_user) {
                    view.append(new App.ChecklistItemMentionMemberView({
                        model: board_user
                    }).el);
                });
            } else {
                view.html(new App.ChecklistItemMentionMemberView({
                    model: null
                }).el);
            }
        } else {
            view.html('');
            this.renderBoardUsers();
        }
    },
    renderBoardUsers: function() {
        var view = this.$el.find('.js-item-member-search-response');
        if (!_.isEmpty(this.model.card.list.collection.board.board_users.models)) {
            this.model.card.list.collection.board.board_users.each(function(board_user) {
                view.append(new App.ChecklistItemMentionMemberView({
                    model: board_user,
                    class_name: 'js-edit-item-member'
                }).el);
            });
        } else {
            view.html(new App.ChecklistItemMentionMemberView({
                model: null
            }).el);
        }
    },
    /**
     * editCardMember()
     * show board member in checklist item
     * @param e
     * @type Object(DOM event)
     * return false
     *
     */
    editItemMember: function(e) {
        e.preventDefault();
        var member_id = $(e.currentTarget).data('member-id');
        var selected_user = this.model.board_users.get({
            id: member_id
        });
        var target = $('form.js-item-edit-form textarea');
        target.val(target.val() + ' @' + selected_user.attributes.username);
        return false;
    },
    noAction: function(e) {
        e.preventDefault();
        return false;
    }
});
