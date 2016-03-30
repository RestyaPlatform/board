/**
 * @fileOverview This file has functions related to card checklist view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: checklist model. It contain all card based object @see Available Object in App.CardView
 *	this.model.card					: card model. @see Available Object in CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CardCheckList View
 * @class CardCheckListView
 * @constructor
 * @extends Backbone.View
 */
App.CardCheckListView = Backbone.View.extend({
    template: JST['templates/card_checklist'],
    tagName: 'div',
    className: 'js-card-checklist',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-show-checklist-edit-form': 'showChecklistEditForm',
        'submit form.checklist-edit-form': 'updateChecklist',
        'click a.js-hide-checklist-edit-form': 'hideChecklistEditForm',
        'click .js-show-confirm-checklist-delete': 'showConfirmChecklistDelete',
        'click .js-delete-checklist': 'deleteChecklist',
        'click .js-show-checklist-actions': 'showChecklistActions',
        'click .js-back-to-checklist-actions': 'backToChecklistActions',
        'click .js-close-popup': 'closePopup',
        'click .js-show-checklist-item-add-form': 'showChecklistItemAddForm',
        'click .js-hide-checklist-item-add-form': 'hideChecklistItemAddForm',
        'submit form.js-add-item': 'addChecklistItem',
        'click .js-show-item-options': 'showItemOptions',
        'click .js-back-to-item-options': 'backToItemOptions',
        'click .js-show-mention-member-form': 'showMentionMemberForm',
        'click .js-show-emoji-list-form': 'showEmojiList',
        'click .js-add-item-member': 'addItemMember',
        'keyup .js-item-search-member': 'showSearchItemMembers',
        'click .js-no-action': 'noAction',
        'checklistSort': 'checklistSort',
        'keypress textarea': 'onEnter',
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        _.bindAll(this, 'render', 'renderItemsCollection');
        this.model.checklist_items.bind('remove', this.renderItemsCollection);
        var board_user_role_id = this.model.board_users.findWhere({
            user_id: parseInt(authuser.user.id)
        });
        if (!_.isEmpty(board_user_role_id)) {
            this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
        }
    },
    /**
     * checklistSort()
     * save the checklist moved position
     * @param e
     * @type Object(DOM event)
     * @param data
     * @type Object
     *
     */
    checklistSort: function(ev, ui) {
        var target = $(ev.target);
        var previous_checklist_id = target.prev('.js-card-checklist').data('checklist_id');
        var next_checklist_id = target.next('.js-card-checklist').data('checklist_id');
        if (typeof previous_checklist_id == 'undefined' && typeof next_checklist_id == 'undefined') {
            previous_checklist_id = 1;
            next_checklist_id = 1;
        }
        if (typeof previous_checklist_id != 'undefined') {
            this.model.moveAfter(previous_checklist_id);
        } else if (typeof next_checklist_id != 'undefined') {
            this.model.moveBefore(next_checklist_id);
        } else {
            if (this.model.collection.length != 1) {
                throw 'Unable to determine position';
            }
        }
        this.model.url = api_url + 'boards/' + this.model.card.get('board_id') + '/lists/' + this.model.card.get('list_id') + '/cards/' + this.model.card.id + '/checklists/' + this.model.id + '.json';
        this.model.save({
            position: this.model.attributes.position
        }, {
            patch: true
        });
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
            checklist: this.model
        }));
        if (!_.isUndefined(authuser.user)) {
            $('.js-checklist-items-sorting', this.$el).sortable({
                items: 'div.js-checklist-item',
                helper: 'clone',
                connectWith: '.js-checklist-items-sorting',
                dropOnEmpty: true,
                placeholder: 'form-group card-list-placeholder col-xs-12',
                cursor: 'grab',
                axis: 'y',
                scroll: true,
                tolerance: 'pointer',
                handle: '.list-group-item-text',
                update: function(ev, ui) {
                    ui.item.trigger('itemSort', ev, ui);
                },
                start: function(ev, ui) {
                    ui.placeholder.height(ui.item.outerHeight());
                    $(ev.target).find('.js-checklist-item').removeClass('cur-grab');
                    $(ev.target).find('.js-checklist-item').addClass('cur-grabbing');
                },
                stop: function(ev, ui) {
                    $(ev.target).find('.js-checklist-item').addClass('cur-grab');
                    $(ev.target).find('.js-checklist-item').removeClass('cur-grabbing');
                }
            });
        }
        this.renderItemsCollection();
        this.renderProgress();
        this.showTooltip();
        return this;
    },
    /**
     * deleteChecklist()
     * delete check list
     * @return false
     *
     */
    deleteChecklist: function() {
        this.$el.remove();
        this.model.url = api_url + 'boards/' + this.model.card.attributes.board_id + '/lists/' + this.model.card.attributes.list_id + '/cards/' + this.model.card.attributes.id + '/checklists/' + this.model.id + '.json';
        var cnt = 0;
        var completed_cnt = 0;
        var checkLists = this.model.card.list.collection.board.cards.get(this.model.card.attributes.id).checklists;
        checkLists.each(function(list) {
            completed_cnt += parseInt(list.attributes.checklist_item_completed_count);
            cnt += parseInt(list.checklist_items.length);
        });
        var this_complete_count = completed_cnt - parseInt(this.model.attributes.checklist_item_completed_count);
        var this_count = cnt - parseInt(this.model.checklist_items.length);
        if (!this_complete_count.isNan) {
            this.model.set({
                checklist_item_completed_count: this_complete_count
            }, {
                silent: true
            });
            this.model.card.set('checklist_item_completed_count', this_complete_count);
            this.model.card.list.collection.board.cards.get(this.model.card.attributes.id).set({
                checklist_item_completed_count: this_complete_count
            }, {
                silent: true
            });
        }
        if (!this_count.isNan) {
            this.model.set({
                checklist_item_count: this_count
            }, {
                silent: true
            });
            this.model.card.set('checklist_item_count', this_count);
            this.model.card.list.collection.board.cards.get(this.model.card.attributes.id).set({
                checklist_item_count: this_count
            }, {
                silent: true
            });
        }
        this.model.destroy({
            success: function(model, response, options) {
                if (!_.isUndefined(response.activity)) {
                    var activity = new App.Activity();
                    activity.set(response.activity);
                    var view_act = new App.ActivityView({
                        model: activity
                    });
                    self.model.activities.unshift(activity);
                    var view_activity = $('#js-card-activities-' + parseInt(response.activity.card_id));
                    view_activity.prepend(view_act.render().el).find('.timeago').timeago();
                }
            }
        });

        return false;
    },
    /**
     * renderItemsCollection()
     * display items in checklist
     *
     */
    renderItemsCollection: function(is_show_link) {
        var self = this;
        var view_item = this.$('#js-checklist-items-' + this.model.id);
        view_item.html('');
        this.model.checklist_items.sortByColumn('position');
        this.model.checklist_items.each(function(checklist_item) {
            checklist_item.card = self.model.card;
            checklist_item.cards = self.model.cards;
            checklist_item.checklist = new App.CheckList();
            checklist_item.checklist = self.model;
            checklist_item.board_users = self.model.board_users;
            var view = new App.CardCheckListItemView({
                model: checklist_item,
                attributes: {
                    'data-item_id': checklist_item.attributes.id,
                },
            });
            view_item.append(view.render().el);
        });
        if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.board_users.board.acl_links.where({
                slug: 'add_checklist_item',
                board_user_role_id: parseInt(this.model.board_user_role_id)
            }))) && is_show_link !== false) {
            view_item.after(new App.ChecklistItemAddLinkView().el);
        }
    },
    /**
     * showChecklistEditForm()
     * display checklist edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showChecklistEditForm: function(e) {
        var prev_form = $('form.checklist-edit-form');
        prev_form.parent().html($('textarea', prev_form).val());
        prev_form.remove();
        $(e.currentTarget).addClass('hide');
        $(e.currentTarget).after(new App.ChecklistEditFormView({
            model: this.model
        }).el);
        return false;
    },
    /**
     * updateChecklist()
     * update checklist
     * @param e
     * @type Object(DOM event)   
     * @return false
     *
     */
    updateChecklist: function(e) {
        if (!$.trim($('#checklistEditName').val()).length) {
            $('.error-msg').remove();
            $('<div class="error-msg text-primary h6">' + i18next.t('Whitespace alone not allowed') + '</div>').insertAfter('#checklistEditName');
        } else {
            $('.error-msg').remove();
            e.preventDefault();
            var data = $(e.target).serializeObject();
            this.model.url = api_url + 'boards/' + this.model.card.get('board_id') + '/lists/' + this.model.card.get('list_id') + '/cards/' + this.model.card.id + '/checklists/' + this.model.id + '.json';
            this.model.set('card_id', this.model.card.id);
            this.model.set('list_id', this.model.card.attributes.list_id);
            this.model.set('board_id', this.model.card.attributes.board_id);
            this.model.set(data);
            this.render();
            this.model.save(data, {
                patch: true
            });
        }
        return false;
    },
    /**
     * hideChecklistEditForm()
     * hide checklist edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    hideChecklistEditForm: function(e) {
        e.preventDefault();
        var form = $('form.checklist-edit-form');
        form.prev().removeClass('hide');
        $('a', form.prev()).html($('textarea', form).val());
        form.remove();
    },
    /**
     * showConfirmChecklistDelete()
     * display checklist delete form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showConfirmChecklistDelete: function(e) {
        $('#js-checklist-confirm-response-' + this.model.id).html(new App.ChecklistDeleteConfirmFormView({
            model: this.model
        }).el);
        return false;
    },
    /**
     * showChecklistActions()
     * display checklist action lists
     * @param e
     * @type Object(DOM event)
     *
     */
    showChecklistActions: function(e) {
        $('#js-checklist-actions-response-' + this.model.id).html(new App.ChecklistActionsView({
            model: this.model
        }).el);
    },
    /**
     * backToChecklistActions()
     * back to checklist action lists
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    backToChecklistActions: function(e) {
        $('.js-back-to-checklist-actions').remove();
        this.showChecklistActions(e);
        return false;
    },
    /**
     * closePopup()
     * hide checklist action lists
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown, div.dropdown').removeClass('open');
        return false;
    },
    /**
     * showChecklistItemAddForm()
     * display checklist item add form
     * @param e
     * @type Object(DOM event)
     *
     */
    showChecklistItemAddForm: function(e) {
        e.preventDefault();
        $(e.target).removeClass('js-show-checklist-item-add-form').addClass('hide').next('.js-checklist-item-add-form-view').html(new App.ChecklistItemAddFormView({
            model: this.model
        }).el);
        $('.js-add-item').find('textarea').focus();
    },
    /**
     * hideChecklistItemAddForm()
     * hide checklist item add form
     * @param e
     * @type Object(DOM event)
     *
     */
    hideChecklistItemAddForm: function(e) {
        e.preventDefault();
        $(e.target).parents('div.js-checklist-item-add-form-view').prev('a.js-add-item-view').removeClass('hide').addClass('js-show-checklist-item-add-form').html(i18next.t('Add Item'));
        $(e.target).parents('div.js-checklist-item-add-form-view').html('');
    },
    /**
     * addChecklistItem()
     * add item in checklist
     * @param e
     * @type Object(DOM event)
     *
     */
    addChecklistItem: function(e) {
        if (!$.trim($('#ChecklistItem').val()).length) {
            $('.error-msg').remove();
            $('<div class="error-msg text-primary h6">' + i18next.t('Whitespace alone not allowed') + '</div>').insertAfter('#ChecklistItem');
            return false;
        } else {
            $('.error-msg').remove();
            e.preventDefault();
            var self = this;
            var target = $(e.target);
            var data = target.serializeObject();
            var checklist_item = new App.CheckListItem();
            checklist_item.set('card_id', self.model.card.attributes.id);
            checklist_item.set('list_id', self.model.card.attributes.list_id);
            checklist_item.set('board_id', self.model.card.attributes.board_id);
            checklist_item.set('checklist_id', self.model.attributes.id);
            checklist_item.url = api_url + 'boards/' + self.model.card.attributes.board_id + '/lists/' + self.model.card.attributes.list_id + '/cards/' + self.model.card.attributes.id + '/checklists/' + self.model.id + '/items.json';
            $(e.target).find('textarea').val('').focus();
            checklist_item.save(data, {
                success: function(model, response) {
                    if (!_.isUndefined(response.checklist_items)) {
                        _.each(response.checklist_items, function(item) {
                            checklist_item = new App.CheckListItem();
                            checklist_item.set('id', parseInt(item.id));
                            checklist_item.set('card_id', parseInt(item.card_id));
                            checklist_item.set('user_id', parseInt(item.user_id));
                            checklist_item.set('checklist_id', parseInt(item.checklist_id));
                            checklist_item.set('position', parseFloat(item.position));
                            checklist_item.set('name', item.name);
                            checklist_item.set('is_completed', item.is_completed);
                            checklist_item.card = self.model.card;
                            checklist_item.checklist = new App.CheckList();
                            checklist_item.checklist = self.model;
                            self.model.card.list.collection.board.checklist_items.add(checklist_item, {
                                silent: true
                            });
                            self.model.checklist_items.add(checklist_item, {
                                silent: true
                            });
                        });
                        self.model.set({
                            checklist_item_count: parseInt(self.model.attributes.checklist_item_count) + response.checklist_items.length
                        }, {
                            silent: true
                        });
                        self.model.card.set('checklist_item_count', parseInt(self.model.card.attributes.checklist_item_count) + response.checklist_items.length);
                    } else {
                        var items = data.name.split('\n');
                        var i = 1;
                        _.each(items, function(item) {
                            checklist_item = new App.CheckListItem();
                            checklist_item.set('id', new Date().getTime());
                            checklist_item.set('card_id', self.model.card.attributes.id);
                            checklist_item.set('user_id', parseInt(authuser.user.id));
                            checklist_item.set('checklist_id', self.model.id);
                            checklist_item.set('position', i);
                            checklist_item.set('name', _.escape(item.replace('\r', '')));
                            checklist_item.set('is_completed', 0);
                            checklist_item.card = self.model.card;
                            checklist_item.checklist = new App.CheckList();
                            checklist_item.checklist = self.model;
                            self.model.card.list.collection.board.checklist_items.add(checklist_item, {
                                silent: true
                            });
                            self.model.checklist_items.add(checklist_item, {
                                silent: true
                            });
                            i++;
                        });
                        self.model.set({
                            checklist_item_count: parseInt(self.model.attributes.checklist_item_count) + i
                        }, {
                            silent: true
                        });
                        self.model.card.set({
                            checklist_item_count: parseInt(self.model.card.attributes.checklist_item_count) + i
                        });
                    }
                    self.model.card.list.collection.board.cards.get(self.model.card).set({
                        checklist_item_count: self.model.card.attributes.checklist_item_count
                    }, {
                        silent: true
                    });
                    self.renderItemsCollection(false);
                    self.renderProgress();
                    if (!_.isUndefined(response.activities)) {
                        _.each(response.activities, function(_activity) {
                            var activity = new App.Activity();
                            activity.set(_activity);
                            var view = new App.ActivityView({
                                model: activity
                            });
                            self.model.set('activities', activity);
                            var view_activity = $('#js-card-activities-' + self.model.card.attributes.id);
                            view_activity.prepend(view.render().el).find('.timeago').timeago();
                        });
                    }
                }
            });
        }
    },
    /**
     * renderProgress()
     * display checklist item completed progress bar
     * return false
     *
     */
    renderProgress: function() {
        var completed_count = this.model.checklist_items.filter(function(checklist_item) {
            return parseInt(checklist_item.get('is_completed')) === 1;
        }).length;
        var total_count = this.model.checklist_items.length;
        completed_count = 0 < total_count ? Math.round(100 * completed_count / total_count) : 0;
        $('#js-checklist-progress-bar-' + this.model.id).stop().animate({
            'width': completed_count + '%',
            '-moz-transition': 'all .6s ease',
            '-ms-transition': 'all .6s ease',
            '-o-transition': 'all .6s  ease',
            '-webkit-transition': 'all .6s  ease',
            'transition': 'all .6s  ease'
        }, 100);
        $('#js-checklist-progress-percent-' + this.model.id).text(completed_count + '%');
        return false;
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
        $('#js-item-add-option-response-' + this.model.id).html(new App.ChecklistItemActionsView({
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
        $('#js-item-add-option-response-' + this.model.id).html(new App.ChecklistItemActionsView({
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
        $('#js-item-add-option-response-' + this.model.id).html(new App.ChecklistItemMentionMemberSerachFormView().el);
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
        $('#js-item-add-option-response-' + this.model.id).html(new App.ChecklistItemEmojiListView({
            model: emojiListArray
        }).el);
        //$('.js-show-emoji-list-response ul').remove();
        emojify.run();
        return false;
    },
    /**
     * addCardMember()
     * show board member in card
     * @param e
     * @type Object(DOM event)
     * return false
     *
     */
    addItemMember: function(e) {
        e.preventDefault();
        var member_id = $(e.currentTarget).data('member-id');
        var selected_user = this.model.card.list.collection.board.board_users.get({
            id: parseInt(member_id)
        });
        var target = $('form.js-add-item textarea');
        target.val(target.val() + ' @' + selected_user.attributes.username);
        return false;
    },
    /**
     * showSearchMembers()
     * display searched member list
     */
    showSearchItemMembers: function(e) {
        var self = this;
        var q = $(e.target).val();
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
                    self.$el.find('.js-item-member-search-response').append(new App.ChecklistItemMentionMemberView({
                        model: board_user
                    }).el);
                });
            } else {
                $('.js-item-member-search-response').html(new App.ChecklistItemMentionMemberView({
                    model: null
                }).el);
            }
        } else {
            this.$el.find('.js-item-member-search-response').html('');
            this.renderBoardUsers();
        }
    },
    renderBoardUsers: function() {
        var view = this.$el.find('.js-item-member-search-response');
        if (!_.isEmpty(this.model.card.list.collection.board.board_users.models)) {
            this.model.card.list.collection.board.board_users.each(function(board_user) {
                view.append(new App.ChecklistItemMentionMemberView({
                    model: board_user
                }).el);
            });
        } else {
            view.html(new App.ChecklistItemMentionMemberView({
                model: null
            }).el);
        }
    },
    noAction: function(e) {
        e.preventDefault();
        return false;
    },
    onEnter: function(e) {
        if (e.which === 13) {
            e.preventDefault();
            var form = $(e.target).closest('form');
            if (form.attr('name') === 'checklistItemAddForm') {
                $('input[type=submit]', form).trigger('click');
            } else {
                return false;
            }
        }
    }
});
