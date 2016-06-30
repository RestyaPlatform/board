/**
 * @fileOverview This file has functions related to list view. This view calling from board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list model and it's related values
 *	this.model.attachments			: attachments collection(Based on list)
 *	this.model.cards 			   	: cards collection(Based on list)
 *  this.model.collection.board		: board model. It contain all board based object @see Available Object in App.BoardView
 *	this.model.lists_subscribers  	: list user collection(Based on list)
 *	this.model.boards_subscribers  	: board user collection(Based on board)
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * List View
 * @class ListView
 * @constructor
 * @extends Backbone.View
 */
App.ListView = Backbone.View.extend({
    tagName: 'div',
    className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12 js-board-list list',
    converter: new showdown.Converter(),
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.sort_by = null;
        this.authuser = authuser.user;
        this.mov_boards = new App.BoardCollection();
        if (this.model.has('lists_subscribers')) {
            this.model.lists_subscribers.add(this.model.get('lists_subscribers'), {
                silent: true
            });
        }
        if (this.model.has('list_attachments')) {
            this.model.attachments.add(this.model.attributes.list_attachments, {
                silent: true
            });
        }
        if (!_.isUndefined(this.model.collection)) {
            this.total_board_list = this.model.collection.board.attributes.lists;
            this.total_board_list_length = 0;
            if (!_.isEmpty(this.model.collection.board.attributes.lists)) {
                this.total_board_list_length = this.model.collection.board.attributes.lists.length;
            }
            this.board = this.model.collection.board;
        }
        if (this.model.has('board_activities')) {
            this.board_activites = this.model.collection.board.get('board_activities');
        }
        _.bindAll(this, 'render', 'renderCardsCollection', 'removeRender');
        this.model.bind('change:name', this.render);
        if (!_.isUndefined(this.model.collection)) {
            this.model.collection.board.labels.bind('add', this.renderCardsCollection);
            this.model.collection.board.attachments.bind('add', this.renderCardsCollection);
            this.model.collection.board.attachments.bind('remove', this.renderCardsCollection);
            this.model.collection.board.cards.bind('add', this.renderCardsCollection);
            this.model.collection.board.cards.bind('add:name', this.renderCardsCollection);
            this.model.collection.board.cards.bind('add:id', this.renderCardsCollection);
            this.model.collection.board.cards.bind('remove', this.renderCardsCollection);
            this.model.collection.board.cards.bind('change:position', this.renderCardsCollection);
            this.model.collection.board.cards.bind('change:is_archived', this.renderCardsCollection);
            this.model.collection.board.cards.bind('change:list_id', this.renderCardsCollection);
        }
        this.model.bind('remove', this.removeRender);
        if (!_.isUndefined(authuser.user)) {
            var board_user_role_id = this.model.board_users.findWhere({
                user_id: parseInt(authuser.user.id)
            });
            if (!_.isEmpty(board_user_role_id)) {
                this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
            }
        }
    },
    template: JST['templates/list'],
    templateAdd: JST['templates/list_add'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form.js-edit-list': 'editList',
        'click .js-show-list-actions': 'showListActions',
        'click .js-close-popup': 'closePopup',
        'click .js-back-to-list-actions': 'backToListActions',
        'click .js-show-confirm-archive-list': 'showConfirmArchiveList',
        'click .js-archive-list': 'archiveList',
        'click .js-show-confirm-list-delete': 'showConfirmListDelete',
        'click .js-delete-list': 'deleteList',
        'click .js-show-copy-list-form': 'showCopyListForm',
        'click .js-show-move-list-form': 'showMoveListForm',
        'submit form.js-move-list': 'moveList',
        'click .js-list-subscribe': 'listSubscribe',
        'click .js-list-unsubscribe': 'listUnsubscribe',
        'click .js-show-move-card-list-form': 'showMoveCardListForm',
        'click .js-move-cards': 'moveCards',
        'click .js-show-confirm-archive-cards': 'showConfirmArchiveCards',
        'click .js-archive-card': 'archiveCard',
        'click .js-show-add-card-form': 'showAddCardForm',
        'click .js-sort-by': 'sortBy',
        'click .js-show-list-modal': 'showListModal',
        'click .js-no-action': 'noAction',
        'click .js-show-edit-list-form': 'showListEditForm',
        'submit form.js-cardAddForm': 'addCard',
        'keypress textarea': 'onEnter',
        'click .js-copy-from-existing-card': 'copyFromExistingCard',
        'keyup .js-card-add-search': 'cardSearch',
        'click .js-select-card': 'selectCard',
        'change .js-move-change-list': 'moveChangeList',
        'change .js-move-change-position': 'moveChangePosition',
        'change .js-change-list': 'changeList',
        'change .js-change-position': 'changePosition',
        'click .js-copy-existing-card': 'copyExistingCard',
        'click .js-hide-edit-list-form': 'hideListEditForm',
        'listSort': 'listSort',
        'keyup[n] .js-board-list': 'keyboardShowAddCardForm',
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
    listSort: function(ev, ui) {
        var target = $(ev.target);
        var previous_list_id = target.prev('.js-board-list').data('list_id');
        var next_list_id = target.next('.js-board-list').data('list_id');
        if (typeof previous_list_id == 'undefined' && typeof next_list_id == 'undefined') {
            previous_list_id = 1;
            next_list_id = 1;
        }
        if (typeof previous_list_id != 'undefined') {
            this.model.moveAfter(previous_list_id);
        } else if (typeof next_list_id != 'undefined') {
            this.model.moveBefore(next_list_id);
        } else {
            if (this.model.collection.length != 1) {
                throw 'Unable to determine position';
            }
        }
        App.boards.get(this.model.attributes.board_id).lists.get(this.model.attributes.id).set('position', this.model.attributes.position);
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.id + '.json';
        var list_id = this.model.attributes.id;
        var list_position = this.model.attributes.position;
        this.model.save({
            position: this.model.attributes.position
        }, {
            patch: true,
            success: function(model, response) {
                self.model.attributes.lists.forEach(function(list) {
                    if (list.id === parseInt(list_id)) {
                        list.position = list_position;
                    }
                });
            }
        });
    },
    /**
     * drop()
     * handle image upload
     * @param event
     * @type Object(DOM event)
     * @param data
     * @type Object
     *
     */
    drop: function(event, data) {
        event.stopPropagation();
        event.preventDefault();
        var files = event.originalEvent.dataTransfer.files;
        this.processFiles(files, event.currentTarget.dataset.card_id);
        return false;
    },
    /**
     * dragover()
     * prevent default event action
     * @param e
     * @type Object(DOM event)
     */
    dragover: function(e) {
        e.stopPropagation();
        e.preventDefault();
    },
    /**
     * processFiles()
     * handle dropped image
     * @param files
     * @type Object(DOM event)
     * @param card_id
     * @type integer
     */
    processFiles: function(files, card_id) {
        _.each(files, function(file) {
            this.processFile(file, card_id);
        }, this);
    },
    /**
     * processFile()
     * saved dropped images
     * @param file
     * @type Object(DOM event)
     * @param card_id
     * @type integer
     *
     */
    processFile: function(file, card_id) {
        var fileData = new FormData();
        fileData.append('attachment', file);
        var card_attachment = new App.CardAttachment();
        card_attachment.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.id + '/cards/' + card_id + '/attachments.json';
        card_attachment.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false
        });
    },
    /**
     * editList()
     * update list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    editList: function(e) {
        var self = this;
        var list_id = self.model.id;
        var bool = $('.js-list-subscribed-' + list_id).hasClass('hide');
        var data = $(e.target).serializeObject();
        if (data.name === self.model.attributes.name) {
            $(e.target).addClass('hide').prev('.js-show-edit-list-form').removeClass('hide');
            $('#js-show-list-actions-' + self.model.id + ', #js-show-sort-form-' + self.model.id).removeClass('hide');
        } else {
            self.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '.json';
            self.model.save(data, {
                patch: true,
                success: function(model, response) {
                    self.model.collection.board.attributes.lists.forEach(function(list) {
                        if (list.id === parseInt(list_id)) {
                            list.name = data.name;
                        }
                    });
                }
            });
        }
        if (bool) {
            $('.js-list-subscribed-' + list_id).addClass('hide');
        } else {
            $('.js-list-subscribed-' + list_id).removeClass('hide');
        }
        return false;
    },
    /**
     * showListActions()
     * display list actions
     * @param e
     * @type Object(DOM event)
     *
     */
    showListActions: function(e) {
        $('.js-list-actions-response').remove();
        $(e.currentTarget).after(new App.ListActionsView({
            model: this.model,
            subscribers: this.model.lists_subscribers,
            authuser: this.authuser
        }).el);
    },
    /**
     * backToListActions()
     * display list actions
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    backToListActions: function(e) {
        var list_id = $(e.target).parents().find('.js-show-list-actions').attr('data-list-id');
        var list_action = $(e.target).parents().find('#js-show-list-actions-' + list_id);
        $('.js-list-actions-response').remove();
        var subscribers = new App.ListSubscriberCollection();
        subscribers.add(this.model.attributes.lists_subscribers);
        $(list_action).after(new App.ListActionsView({
            model: this.model,
            subscribers: subscribers,
            authuser: this.authuser
        }).el);
        return false;
    },
    /**
     * closePopup()
     * close opened dropdwon
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown:first, div.dropdown:first').removeClass('open');
        return false;
    },
    /**
     * showConfirmArchiveList()
     * display confirmation box for list archive
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showConfirmArchiveList: function(e) {
        $('.js-list-actions-response').html(new App.ListArchiveConfirmView({
            model: this.model
        }).el);
        return false;
    },
    /**
     * archiveList()
     * archive list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    archiveList: function(e) {
        var self = this;
        self.$el.remove();
        var list_id = self.model.id;
        this.model.set('is_archived', 1);
        this.model.url = api_url + 'boards/' + self.board.id + '/lists/' + list_id + '.json';
        App.boards.get(this.model.attributes.board_id).lists.get(this.model.attributes.id).set('is_archived', 1);
        this.model.save({
            is_archived: 1
        }, {
            patch: true,
            success: function(model, response) {
                self.board.attributes.lists.forEach(function(list, index) {
                    if (list.id === parseInt(list_id)) {
                        list.is_archived = 1;
                    }
                });
                self.board.activities.unshift(response.activity);
            }
        });
        return false;
    },
    /**
     * showConfirmListDelete()
     * display delete confirmation
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showConfirmListDelete: function(e) {
        $('.js-list-actions-response').html(new App.ListDeleteConfirmView({
            model: this.model,
        }).el);
        return false;
    },
    /**
     * showConfirmListDelete()
     * delete list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    deleteList: function(e) {
        var self = this;
        self.$el.remove();
        var list_id = self.model.id;
        var removed_list_cards = self.board.cards.where({
            list_id: self.model.attributes.id
        });
        this.model.cards.remove(removed_list_cards, {
            silent: true
        });
        this.model.collection.board.cards.remove(removed_list_cards, {
            silent: true
        });
        this.model.collection.board.lists.remove(self.model);
        App.boards.get(self.model.attributes.board_id).lists.remove(self.model);
        this.board.lists.remove(self.model);
        this.model.url = api_url + 'boards/' + self.board.id + '/lists/' + list_id + '.json';
        this.model.destroy({
            success: function(model, response) {
                self.board.attributes.lists.forEach(function(list, index) {
                    if (list.id === parseInt(list_id)) {
                        self.board.attributes.lists.splice(index, 1);
                    }
                });
                self.board.activities.unshift(response.activity);
            }
        });
        return false;
    },
    /**
     * showCopyListForm()
     * display copy list form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showCopyListForm: function(e) {
        $('.js-list-actions-response').html(new App.CopyListView({
            model: this.model,
        }).el);
        return false;
    },
    /**
     * showMoveListForm()
     * display move list form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showMoveListForm: function(e) {
        e.preventDefault();
        $('.js-list-actions-response').html(new App.MoveListFromView({
            model: this.model,
            boards: App.boards,
            total_board_list_length: this.total_board_list_length
        }).el);
        return false;
    },
    /**
     * moveList()
     * save moved list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    moveList: function(e) {
        e.preventDefault();
        var list_id = this.model.id;
        var current_list = this.model.attributes;
        var data = $(e.target).serializeObject();
        var position = parseInt(data.position);
        if (_.isEmpty(position)) {
            position = $(e.target).find('#list_position').val();
        }
        var board_id = parseInt(data.board_id);
        this.model.collection.sortByColumn('position');
        if (board_id !== this.model.attributes.board_id) {
            this.model.collection.remove({
                id: list_id
            });
            this.$el.remove();
            var i = 0;
            var current_position = 0;
            App.boards.get(board_id).lists.sortByColumn('position');
            App.boards.get(board_id).lists.each(function(list) {
                i++;
                if (typeof next_list_id != 'undefined') {
                    return false;
                }
                if (position == i) {
                    current_position = list.get('position');
                    if (position == 1) {
                        next_list_id = list.get('id');
                    }
                } else if (current_position !== 0) {
                    next_list_id = list.get('id');
                } else {
                    previous_list_id = list.get('id');
                }
            });
            var moved_list;
            var previous_list_position = 0;
            if (typeof previous_list_id != 'undefined') {
                previous_list_position = App.boards.get(board_id).lists.get(previous_list_id).get('position');
                moved_list = App.boards.get(board_id).lists.get(previous_list_id).moveAfter(previous_list_id);
                data.position = moved_list.attributes.position;
                App.boards.get(board_id).lists.get(previous_list_id).set('position', previous_list_position);
            } else if (typeof next_list_id != 'undefined') {
                previous_list_position = App.boards.get(board_id).lists.get(next_list_id).get('position');
                moved_list = App.boards.get(board_id).lists.get(next_list_id).moveBefore(next_list_id);
                data.position = moved_list.attributes.position;
                App.boards.get(board_id).lists.get(next_list_id).set('position', previous_list_position);
            }
            moved_list = App.boards.get(this.model.attributes.board_id).lists.get(list_id);
            moved_list.attributes.board_id = board_id;
            moved_list.attributes.position = data.position;
            App.boards.get(board_id).lists.add(moved_list);
            App.boards.get(this.model.attributes.board_id).lists.remove(list_id);
        } else {
            var previous_position = position - 1;
            var current_index = this.$el.index() + 1;
            if (position !== current_index) {
                if ($('.js-board-list').length === position || current_index < position) {
                    this.$el.insertAfter('.js-board-list:nth-child(' + position + ')');
                } else {
                    this.$el.insertBefore('.js-board-list:nth-child(' + position + ')');
                }
                var target = $('.js-board-list:nth-child(' + position + ')');
                var previous_list_id = target.prev('.js-board-list').data('list_id');
                var next_list_id = target.next('.js-board-list').data('list_id');
                if (typeof previous_list_id == 'undefined' && typeof next_list_id == 'undefined') {
                    previous_list_id = 1;
                    next_list_id = 1;
                }
                if (typeof previous_list_id != 'undefined') {
                    this.model.moveAfter(previous_list_id);
                } else if (typeof next_list_id != 'undefined') {
                    this.model.moveBefore(next_list_id);
                } else {
                    if (this.model.collection.length != 1) {
                        throw 'Unable to determine position';
                    }
                }
            } else {
                this.closePopup(e);
            }
            var list = App.boards.get(this.model.attributes.board_id).lists.get(this.model.attributes.id);
            if (!_.isUndefined(list)) {
                list.set('position', this.model.attributes.position);
            }
            data.position = this.model.attributes.position;
        }
        data.board_id = board_id;
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '.json';
        this.model.save(data, {
            patch: true,
            success: function(model, response) {
                self.model.attributes.lists.forEach(function(list) {
                    if (list.id === parseInt(list_id)) {
                        list.position = data.position;
                    }
                });
            }
        });
        this.closePopup(e);
        return false;
    },
    /**
     * listSubscribe()
     * subscribe list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    listSubscribe: function(e) {
        var list_id = this.model.id;
        var subscribe_id = $(e.currentTarget).data('subscribe-id');
        $(e.currentTarget).removeClass('js-list-subscribe').addClass('js-list-unsubscribe');
        $('i.icon-ok', e.currentTarget).removeClass('hide');
        $('.js-subscribe-text', e.currentTarget).html(i18next.t('Subscribed'));
        $('.js-list-subscribed-' + list_id).removeClass('hide');
        var list_subscribe = new App.ListSubscriber();
        list_subscribe.set('user_id', parseInt(authuser.user.id));
        list_subscribe.set('is_subscribed', 1);
        this.model.lists_subscribers.add(list_subscribe);
        if (typeof subscribe_id === 'undefined' || subscribe_id === 'undefined' || subscribe_id === '') {
            var subscribe = {
                subscribe: {
                    is_subscribed: 1
                }
            };
            list_subscribe.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '/list_subscribers.json';
            list_subscribe.save({
                is_subscribed: 1
            });
            if (!_.isUndefined(this.model.attributes.lists_subscribers)) {
                this.model.attributes.lists_subscribers.forEach(function(list) {
                    if (list.user_id === parseInt(authuser.user.id)) {
                        list.is_subscribed = 1;
                    }
                });
            }
        } else {
            list_subscribe.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '/list_subscribers/' + subscribe_id + '.json';
            list_subscribe.save({
                id: parseInt(subscribe_id),
                is_subscribed: 1
            });
        }
        return false;
    },
    /**
     * listUnsubscribe()
     * unsubscribe list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    listUnsubscribe: function(e) {
        $(e.currentTarget).removeClass('js-list-unsubscribe').addClass('js-list-subscribe');
        $('i.icon-ok', e.currentTarget).addClass('hide');
        $('.js-subscribe-text', e.currentTarget).html(i18next.t('Subscribe'));
        var subscribe_id = $(e.currentTarget).data('subscribe-id');
        var list_id = this.model.id;
        $('.js-list-subscribed-' + list_id).addClass('hide');
        var list_subscribe = new App.ListSubscriber();
        this.model.lists_subscribers.remove(this.model.lists_subscribers.findWhere({
            user_id: parseInt(authuser.user.id),
            is_subscribed: 1
        }));
        if (typeof subscribe_id === 'undefined' || subscribe_id === 'undefined' || subscribe_id === '') {
            list_subscribe.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '/list_subscribers.json';
            list_subscribe.save({
                is_subscribed: 0
            });
            if (!_.isUndefined(this.model.attributes.lists_subscribers)) {
                this.model.attributes.lists_subscribers.forEach(function(list) {
                    if (list.user_id === parseInt(authuser.user.id)) {
                        list.is_subscribed = 0;
                    }
                });
            }
        } else {
            this.model.attributes.lists_subscribers.forEach(function(list) {
                if (list.user_id === parseInt(authuser.user.id)) {
                    list.is_subscribed = 0;
                }
            });
            list_subscribe.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '/list_subscribers/' + subscribe_id + '.json';
            list_subscribe.save({
                id: parseInt(subscribe_id),
                is_subscribed: 0
            });
        }
        return false;
    },
    /**
     * showMoveCardListForm()
     * display move card form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showMoveCardListForm: function(e) {
        var list_id = this.model.id;
        var board_list = new App.ListCollection();
        board_list.add(this.model.collection.models);
        var filtered_lists = board_list.where({
            is_archived: 0
        });
        this.$('.js-list-actions-response').html(new App.MoveCardsFromListView({
            filtered_lists: filtered_lists,
            model: this.model
        }).el);
        return false;
    },
    /**
     * moveCards()
     * save moved card
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    moveCards: function(e) {
        $('li.dropdown').removeClass('open');
        var list_id = this.model.id;
        var self = this;
        var move_list_id = parseInt($(e.currentTarget).data('move-list-id'));
        var copied_cards = this.model.collection.board.cards.where({
            list_id: list_id
        });
        this.model.cards.set(copied_cards);
        var view_card = $('#js-card-listing-' + move_list_id);
        var i = 1;
        _.each(copied_cards, function(copied_card) {
            var options = {
                silent: true
            };
            if (i === copied_cards.length) {
                options.silent = false;
            }
            self.model.collection.board.cards.get(copied_card.id).set({
                list_id: move_list_id
            }, options);
            i++;
        });
        var attachments = this.model.collection.board.attachments.where({
            list_id: this.model.id
        });
        var j = 1;
        _.each(attachments, function(attachment) {
            var options = {
                silent: true
            };
            if (j === attachments.length) {
                options.silent = false;
            }
            self.model.collection.board.attachments.get(attachment.id).set({
                list_id: move_list_id
            }, options);
            j++;
        });
        this.model.id = list_id;
        this.model.url = api_url + 'boards/' + this.board.id + '/lists/' + list_id + '/cards.json';
        this.model.save({
            list_id: move_list_id
        }, {
            patch: true
        });
        return false;
    },
    /**
     * showConfirmArchiveCards()
     * display card archive confirmation
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showConfirmArchiveCards: function(e) {
        $('.js-list-actions-response').html(new App.ListCardsArchiveConfirmView({
            model: this.model
        }).el);
        return false;
    },
    /**
     * archiveCard()
     * save archived card
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    archiveCard: function(e, ui) {
        this.closePopup(e);
        var self = this;
        var list_id = this.model.id;
        var archived_cards = this.model.collection.board.cards.where({
            list_id: list_id
        });
        _.each(archived_cards, function(archived_card) {
            self.model.collection.board.cards.get(archived_card.attributes.id).set('is_archived', 1, {
                silent: true
            });
        });
        this.renderCardsCollection();
        var card = new App.Card();
        card.set('id', list_id);
        card.url = api_url + 'boards/' + this.board.id + '/lists/' + list_id + '/cards.json';
        card.save({
            is_archived: 1
        }, {
            patch: true
        });
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
        this.$el.html(this.template({
            list: this.model
        }));
        this.renderCardsCollection();
        if (!_.isUndefined(authuser.user)) {
            if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.collection.board.acl_links.where({
                    slug: 'move_list_cards',
                    board_user_role_id: parseInt(this.model.board_user_role_id)
                })))) {
                $('.js-board-list-cards', this.$el).sortable({
                    containment: 'window',
                    items: 'div.js-board-list-card',
                    connectWith: '.js-board-list-cards',
                    placeholder: 'card-list-placeholder',
                    appendTo: document.body,
                    dropOnEmpty: true,
                    cursor: 'grab',
                    helper: 'clone',
                    tolerance: 'pointer',
                    scrollSensitivity: 100,
                    scrollSpeed: 50,
                    update: function(ev, ui) {
                        if (this === ui.item.parent()[0]) {
                            ui.item.trigger('cardSort', ev, ui);
                        }
                    },
                    start: function(ev, ui) {
                        ui.placeholder.height(ui.item.outerHeight());
                        $('.js-show-modal-card-view ').removeClass('cur');
                    },
                    stop: function(ev, ui) {
                        $('.js-show-modal-card-view ').addClass('cur');
                        clearInterval(App.sortable.setintervalid_horizontal);
                        clearInterval(App.sortable.setintervalid_vertical);
                        App.sortable.is_create_setinterval_horizontal = true;
                        App.sortable.is_create_setinterval_vertical = true;
                        App.sortable.previous_offset_horizontal = 0;
                        App.sortable.previous_offset_vertical = 0;
                    },
                    over: function(ev, ui) {
                        if ($(ui.placeholder).parents('.js-board-list-cards').attr('id') == App.sortable.previous_id) {
                            clearInterval(App.sortable.setintervalid_horizontal);
                        }
                        var scrollLeft = 0;
                        var list_per_page = Math.floor($(window).width() / 270);
                        if (App.sortable.previous_offset_horizontal !== 0 && App.sortable.previous_offset_horizontal != ui.offset.left) {
                            if (App.sortable.previous_offset_horizontal > ui.offset.left) {
                                App.sortable.is_moving_right = false;
                            } else {
                                App.sortable.is_moving_right = true;
                            }
                        }
                        if (App.sortable.previous_move_horizontal !== App.sortable.is_moving_right) {
                            clearInterval(App.sortable.setintervalid_horizontal);
                            App.sortable.is_create_setinterval_horizontal = true;
                        }
                        if (App.sortable.is_moving_right === true && ui.offset.left > (list_per_page - 1) * 230) {
                            if (App.sortable.is_create_setinterval_horizontal) {
                                App.sortable.setintervalid_horizontal = setInterval(function() {
                                    scrollLeft = parseInt($('#js-board-lists').scrollLeft()) + 50;
                                    $('#js-board-lists').animate({
                                        scrollLeft: scrollLeft
                                    }, 10);
                                }, 100);
                                App.sortable.is_create_setinterval_horizontal = false;
                            }
                        } else if (App.sortable.is_moving_right === false && ui.offset.left < (list_per_page - 1) * 100) {
                            if (App.sortable.is_create_setinterval_horizontal) {
                                App.sortable.setintervalid_horizontal = setInterval(function() {
                                    scrollLeft = parseInt($('#js-board-lists').scrollLeft()) - 50;
                                    $('#js-board-lists').animate({
                                        scrollLeft: scrollLeft
                                    }, 10);
                                }, 100);
                                App.sortable.is_create_setinterval_horizontal = false;
                            }
                        }
                        App.sortable.previous_offset_horizontal = ui.offset.left;
                        App.sortable.previous_move_horizontal = App.sortable.is_moving_right;
                    },
                    sort: function(event, ui) {
                        App.sortable.previous_id = $(ui.placeholder).parents('.js-board-list-cards').attr('id');
                        var scrollTop = 0;
                        var decrease_height = 0;
                        var list_height = $('#' + App.sortable.previous_id).height();
                        var additional_top = parseInt($('#js-board-lists').position().top) + parseInt($('#' + App.sortable.previous_id).position().top);
                        var total_top = parseInt(list_height) + parseInt(additional_top);
                        if (ui.placeholder.height() > list_height) {
                            decrease_height = parseInt(ui.placeholder.height()) - parseInt(list_height);
                        } else {
                            decrease_height = parseInt(list_height) - parseInt(ui.placeholder.height());
                        }
                        var total_top1 = (parseInt($('#js-board-lists').position().top) + parseInt(ui.placeholder.position().top)) - decrease_height;
                        if (App.sortable.previous_offset_vertical !== 0) {
                            if (App.sortable.previous_offset_vertical > ui.offset.top) {
                                App.sortable.is_moving_top = false;
                            } else {
                                App.sortable.is_moving_top = true;
                            }
                        }
                        if (App.sortable.previous_move_vertical !== App.sortable.is_moving_top) {
                            clearInterval(App.sortable.setintervalid_vertical);
                            App.sortable.is_create_setinterval_vertical = true;
                        }
                        if (App.sortable.is_moving_top === true && (ui.offset.top > total_top || (total_top1 > 0 && ui.offset.top > total_top1))) {
                            if (App.sortable.is_create_setinterval_vertical) {
                                App.sortable.setintervalid_vertical = setInterval(function() {
                                    scrollTop = parseInt($('#' + App.sortable.previous_id).scrollTop()) + 50;
                                    $('#' + App.sortable.previous_id).animate({
                                        scrollTop: scrollTop
                                    }, 50);
                                }, 100);
                                App.sortable.is_create_setinterval_vertical = false;
                            }
                        } else if (App.sortable.is_moving_top === false && ui.offset.top < (additional_top - 20)) {
                            if (App.sortable.is_create_setinterval_vertical) {
                                App.sortable.setintervalid_vertical = setInterval(function() {
                                    scrollTop = parseInt($('#' + App.sortable.previous_id).scrollTop()) - 50;
                                    $('#' + App.sortable.previous_id).animate({
                                        scrollTop: scrollTop
                                    }, 50);
                                }, 100);
                                App.sortable.is_create_setinterval_vertical = false;
                            }
                        }
                        App.sortable.previous_offset_vertical = ui.offset.top;
                        App.sortable.previous_move_vertical = App.sortable.is_moving_top;
                    }
                });
            }
        }
        this.showTooltip();
        return this;
    },
    /**
     * renderListAdd()
     * display list add form
     * @return false
     *
     */
    renderListAdd: function() {
        this.$el.html(this.templateAdd());
        return this;
    },
    /**
     * renderCardsCollection()
     * display cards in list
     *
     */
    renderCardsCollection: function() {
        var self = this;
        var view_card = this.$('#js-card-listing-' + this.model.id);
        view_card.html('&nbsp;');
        this.model.cards.sortByColumn('position');
        if (!_.isUndefined(this.model.collection)) {
            var filtered_cards = this.model.collection.board.cards.where({
                list_id: parseInt(this.model.id)
            });
            var cards = new App.CardCollection();
            cards.reset(filtered_cards);
            this.model.cards.add(cards.toJSON(), {
                silent: true
            });
            this.model.cards.sortByColumn('position');
            cards.sortByColumn('position');
            cards.each(function(card) {
                var card_id = card.id;
                if (parseInt(card.get('is_archived')) === 0) {
                    card.board_users = self.model.board_users;
                    var filter_labels = self.model.labels.filter(function(model) {
                        return parseInt(model.get('card_id')) === parseInt(card_id);
                    });
                    var labels = new App.CardLabelCollection();
                    labels.add(filter_labels, {
                        silent: true
                    });
                    card.labels = labels;
                    card.card_voters.add(card.get('card_voters'), {
                        silent: true
                    });
                    card.cards = self.model.collection.board.cards;
                    card.list = self.model;
                    card.board_activities.add(self.model.activities, {
                        silent: true
                    });
                    filter_attachments = self.model.attachments.where({
                        card_id: card.id
                    });
                    card.attachments.add(filter_attachments, {
                        silent: true
                    });
                    card.board = self.model.board;
                    var view = new App.CardView({
                        tagName: 'div',
                        model: card,
                        converter: this.converter
                    });
                    view_card.append(view.render().el);
                }
            });
        }

    },
    /**
     * showAddCardForm()
     * display cards add form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showAddCardForm: function(e) {
        e.preventDefault();
        $('.js-cancel-card-add').trigger('click');
        var target = $(e.target);
        var el = this.$el;
        var view_card = this.$('.js-card-add-form-' + this.model.id);
        el.find('.js-show-add-card-form').addClass('hide');
        target.parents('.dropdown').removeClass('open');
        el.find('#cardAddForm').remove();
        var card = new App.Card();
        card.set('list_id', (!isNaN(this.model.id)) ? this.model.id : this.model.attributes.temp_id);
        card.set('board_id', this.model.get('board_id'));
        card.board_users = this.model.board_users;
        card.list = this.model;
        card.collection = this.model.cards;
        var view = new App.CardView({
            model: card,
            attributes: '',
            id: 'js-list-card-add-form-' + this.model.id
        });
        $('#js-list-card-add-form-' + this.model.id).remove();
        if (target.hasClass('js-bottom')) {
            view_card.append(view.renderAdd().el).find('textarea').focus();
        } else {
            view_card.prepend(view.renderAdd().el).find('textarea').focus();
        }
        $('#js-card-listing-' + this.model.id).scrollTop($('#js-card-listing-' + this.model.id)[0].scrollHeight);
        return false;
    },
    /**
     * showListModal()
     * display list attachments
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showListModal: function(e) {
        var modalView = new App.ModalListView({
            model: this.model
        });
        modalView.show();
        return false;
    },
    /**
     * showListEditForm()
     * display list edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showListEditForm: function(e) {
        e.preventDefault();
        this.closePopup(e);
        $(e.currentTarget).addClass('hide').next('form').removeClass('hide');
        this.$('#js-show-list-actions-' + this.model.attributes.id + ', #js-show-sort-form-' + this.model.attributes.id).addClass('hide');
        return false;
    },
    /**
     * hideEditListForm()
     * hide the list edit form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    hideListEditForm: function(e) {
        e.preventDefault();
        var toggle = $(e.currentTarget);
        toggle.parents('form').addClass('hide').prev('.js-show-edit-list-form').removeClass('hide');
        this.$('#js-show-list-actions-' + this.model.attributes.id + ', #js-show-sort-form-' + this.model.attributes.id).removeClass('hide');
        return false;
    },
    /**
     * addCard()
     * save newly added card
     * @param e
     * @type Object(DOM event)
     *
     */
    addCard: function(e) {
        if (!$.trim($('#AddCard').val()).length) {
            $('.error-msg').remove();
            $('<div class="error-msg text-primary h6">Whitespace alone not allowed</div>').insertAfter('#AddCard');
            return false;
        } else {
            $('.error-msg').remove();
            e.preventDefault();
            var self = this;
            var data = $(e.target).serializeObject();
            $('.js-card-add-list').val(this.model.id);
            $('.js-card-user-ids').val('');
            $('.js-card-add-labels').val('');
            $('.js-card-add-position').val('');
            data.uuid = new Date().getTime();
            data.list_id = parseInt(data.list_id);
            data.board_id = parseInt(data.board_id);
            var cards = this.model.collection.board.cards.where({
                list_id: data.list_id
            });
            var list_cards = new App.CardCollection();
            list_cards.add(cards);
            list_cards.sortByColumn('position');
            if (data.position === undefined || data.position === '') {
                data.position = list_cards.length + 1;
            }
            $(e.target).find('textarea').val('').focus();
            var view_card = $('#js-card-listing-' + data.list_id);
            var card = new App.Card();
            card.set('is_offline', true);
            card.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.id + '/cards.json';
            card.set({
                name: data.name,
                is_archived: 0,
                list_id: parseInt(data.list_id),
                board_id: parseInt(data.board_id),
                due_date: null,
                checklist_item_count: 0,
                checklist_item_completed_count: 0
            }, {
                silent: true
            });
            card.board_users = self.model.board_users;
            card.list = self.model;
            var view = new App.CardView({
                tagName: 'div',
                model: card,
                converter: this.converter
            });
            var next = view_card.find('.js-board-list-card:nth-child(' + data.position + ')');
            var prev = view_card.find('.js-board-list-card:nth-child(' + (data.position - 1) + ')');
            var before = '';
            var after = '';
            var difference = '';
            var newPosition = '';
            if (prev.length !== 0) {
                before = list_cards.get(parseInt(prev.data('card_id')));
                after = list_cards.at(list_cards.indexOf(before) + 1);
                if (typeof after == 'undefined') {
                    afterPosition = before.position() + 2;
                } else {
                    afterPosition = after.position();
                }
                difference = (afterPosition - before.position()) / 2;
                newPosition = difference + before.position();
                card.set({
                    position: newPosition
                });
                data.position = newPosition;
                prev.after(view.render().el);
            } else if (next.length !== 0) {
                after = list_cards.get(parseInt(next.data('card_id')));
                before = list_cards.at(list_cards.indexOf(after) - 1);
                if (typeof before == 'undefined') {
                    beforePosition = 0.0;
                } else {
                    beforePosition = before.position();
                }
                if (typeof after == 'undefined') {
                    afterPosition = 0.0;
                } else {
                    afterPosition = after.position();
                }
                difference = (afterPosition - beforePosition) / 2;
                newPosition = difference + beforePosition;
                card.set({
                    position: newPosition
                });
                data.position = newPosition;
                next.before(view.render().el);
            } else {
                view_card.append(view.render().el);
                data.position = 1;
            }
            $('#js-card-listing-' + this.model.id).scrollTop($('#js-card-listing-' + this.model.id)[0].scrollHeight);
            card.save(data, {
                success: function(model, response, options) {
                    $('.js-lables-list').empty();
                    if (_.isUndefined(options.temp_id)) {
                        card.set('is_offline', false);
                    }
                    card.board_activities.add(self.model.activities);
                    if (!_.isUndefined(response.cards_users) && response.cards_users.length > 0) {
                        card.set('cards_users', response.cards_users);
                        card.users.add(response.cards_users);
                    }
                    if (!_.isUndefined(response.cards_labels) && response.cards_labels.length > 0) {
                        self.board.labels.add(response.cards_labels, {
                            silent: true
                        });
                        card.labels.add(response.cards_labels);
                    }
                    var list = App.boards.get(card.attributes.board_id).lists.get(card.attributes.list_id);
                    if (!_.isUndefined(list)) {
                        list.set('card_count', list.attributes.card_count + 1);
                    }

                    if (!_.isUndefined(response.id) && _.isUndefined(options.temp_id)) {
                        card.set({
                            id: parseInt(response.id)
                        });
                    } else {
                        global_uuid[data.uuid] = options.temp_id;
                        card.set('id', data.uuid);
                    }
                    self.model.collection.board.cards.add(card, {
                        silent: true
                    });
                    self.model.cards.add(card, {
                        silent: true
                    });
                }
            });
        }
    },
    /**
     * copyFromExistingCard()
     * save copied card
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    copyFromExistingCard: function(e) {
        e.preventDefault();
        this.$el.find('.js-card-action-list-response').remove();
        this.$el.find('.js-show-card-action-list').after(new App.CardCopyView({
            model: this.model
        }).el);
        return false;
    },
    /**
     * cardSearch()
     * search cards
     * @param e
     * @type Object(DOM event)
     *
     */
    cardSearch: function(e) {
        var self = this;
        var search_q = $(e.currentTarget).val();
        var filtered_cards = self.board.cards.search(search_q);
        var cards = new App.CardCollection();
        cards.add(filtered_cards._wrapped);
        cards.each(function(card) {
            self.$el.find('.js-card-add-search-response').html(new App.CardSearchResultView({
                model: card,
                attributes: {
                    'data-card-id': card.id
                }
            }).el);

        });

    },
    /**
     * selectCard()
     * add selected card in lis
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    selectCard: function(e) {
        var self = this;
        self.boards = new App.BoardCollection();
        self.boards.url = api_url + 'users/' + authuser.user.id + '/boards.json?type=simple';
        self.boards.fetch({
            success: function() {
                self.$el.find('.js-show-card-action-list').next().remove();
                var card_id = $(e.currentTarget).attr('data-card-id');
                var card = self.board.cards.findWhere({
                    id: parseInt(card_id)
                });
                self.$el.find('.js-show-card-action-list').after(new App.CopyFromExistingCardView({
                    model: card,
                    boards: self.boards
                }).el);

            }

        });
        return false;
    },
    /**
     * moveChangeList()
     * change list based on selected board
     * @param string
     * @type string
     */
    moveChangeList: function(e) {
        var target = $(e.currentTarget);
        var self = this;
        var board_id = parseInt(target.val());
        var content_position = '';
        if (board_id == this.model.attributes.board_id) {
            this.showMoveListForm(e);
        } else {

            var board = App.boards.findWhere({
                id: parseInt(board_id),
                is_closed: 0
            });
            board.lists.add(board.attributes.lists);
            var board_lists = board.lists.where({
                is_archived: 0,
                is_deleted: 0
            });
            var current_position = this.model.collection.indexOf(this.model) + 1;
            for (var i = 1; i <= board_lists.length; i++) {
                if (self.model.attributes.board_id == board.attributes.id && i == current_position) {
                    content_position += '<option value="' + i + '" selected="selected">' + i + i18next.t('(current)') + '</option>';
                } else {
                    content_position += '<option value="' + i + '">' + i + '</option>';
                }
            }
            if (self.model.attributes.board_id != board.attributes.id) {
                var next_position = parseInt(board_lists.length) + 1;
                content_position += '<option value="' + next_position + '">' + next_position + '</option>';
            }
            self.$el.find('.js-move-change-position').html(content_position);
        }
    },
    /**
     * moveChangePosition()
     * change position based on selected list
     * @param string
     * @type string
     */
    moveChangePosition: function(e) {
        var target = $(e.currentTarget);
        var self = this;
        var list_id = target.val();
        var board_id = target.parent().prev().find('.js-change-list').val();
        var content_position = '';
        var board = App.boards.findWhere({
            id: parseInt(board_id)
        });
        if (!_.isUndefined(board)) {
            var list = board.lists.findWhere({
                id: parseInt(list_id)
            });
            var current_position = this.model.collection.indexOf(this.model) + 1;
            for (var i = 1; i <= list.attributes.card_count; i++) {
                if (self.model.attributes.list_id == list.attributes.id && i == current_position) {
                    content_position += '<option value="' + self.model.attributes.position + '" selected="selected">' + self.model.attributes.position + i18next.t('(current)') + '</option>';
                } else {
                    content_position += '<option value="' + i + '">' + i + '</option>';
                }
            }
            if (this.model.attributes.list_id != list.attributes.id) {
                var next_position = parseInt(list.attributes.card_count) + 1;
                content_position += '<option value="' + next_position + '">' + next_position + '</option>';
            }
            self.$el.find('.js-position').html(content_position);
        }
    },
    /**
     * changeList()
     * change list based on selected board
     * @param e
     * @type Object(DOM event)
     *
     */
    changeList: function(e) {
        var target = $(e.currentTarget);
        var self = this;
        var board_id = target.val();
        var content_list = '';
        var content_position = '';
        var board = self.boards.findWhere({
            id: parseInt(board_id)
        });
        board.lists.add(board.attributes.lists);
        var is_first_list = true;
        board.lists.each(function(list) {
            if (self.model.attributes.list_id == self.model.attributes.id) {
                content_list += '<option value="' + list.id + '" selected="selected">' + list.attributes.name + i18next.t('(current)') + '</option>';
                is_first_list = true;
            } else {
                content_list += '<option value="' + list.id + '">' + list.attributes.name + '</option>';
            }
            if (is_first_list) {
                is_first_list = false;
                for (var i = 1; i <= list.attributes.card_count; i++) {
                    content_position += '<option value="' + i + '">' + i + '</option>';
                }
            }
        });
        self.$el.find('.js-change-position').html(content_list);
        self.$el.find('.js-position').html(content_position);
    },
    /**
     * changePosition()
     * change position based on list
     * @param e
     * @type Object(DOM event)
     *
     */
    changePosition: function(e) {
        var target = $(e.currentTarget);
        var self = this;
        var list_id = target.val();
        var board_id = target.parent().prev().find('.js-change-list').val();
        var content_position = '';
        var board = self.boards.findWhere({
            id: parseInt(board_id)
        });
        board.cards.add(board.attributes.cards);
        var filtered_cards = board.cards.where({
            board_id: parseInt(board_id),
            list_id: parseInt(list_id)
        });
        var cards = new App.CardCollection();
        cards.add(filtered_cards);
        cards.each(function(card) {
            content_position += '<option value="' + card.attributes.position + '">' + card.attributes.position + '</option>';
        });
        if (content_position === '') {
            content_position += '<option value="1">1</option>';
        }
        self.$el.find('.js-position').html(content_position);
    },
    /**
     * copyExistingCard()
     * save copied card
     * @param e
     * @type Object(DOM event)
     *
     */
    copyExistingCard: function(e) {
        var self = this;
        self.closePopup(e);
        var data = $(e.currentTarget).parents('form.js-copy-existing-card-form').serializeObject();
        var card = new App.Card();
        data.keep_attachments = 1;
        data.keep_activities = 1;
        data.keep_labels = 1;
        data.keep_users = 1;
        card.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + this.model.attributes.id + '/cards/' + data.copied_card_id + '/copy.json';
        card.save(data, {
            patch: true,
            success: function(model, response) {
                var view_card = self.$el.find('#js-card-listing-' + self.model.id);
                var card_view = new App.CardView({
                    tagName: 'div',
                    model: card
                });
                card_view.hideAddCardFrom(e);
                view_card.append(card_view.render().el);
                var activity = new App.Activity();
                activity.set(response.activity);
                var view = new App.ActivityView({
                    model: activity
                });
                var view_activity = $('#js-card-activities-' + data.copied_card_id);
                view_activity.prepend(view.render().el).find('.timeago').timeago();
            }
        });
    },
    noAction: function(e) {
        e.preventDefault();
        return false;
    },
    removeRender: function() {
        this.$el.remove();
    },
    onEnter: function(e) {
        if (e.which === 13) {
            e.preventDefault();
            var form = $(e.target).closest('form');
            if (form.attr('name') === 'cardAddForm') {
                $('input[type=submit]', form).trigger('click');
            } else {
                return false;
            }
        }
    },
    keyboardShowAddCardForm: function(e) {
        if ($('.js-board-list .js-board-list-cards .js-board-list-card').hasClass('active')) {
            $('.active').parents('.js-board-list').find('.js-show-add-card-form').trigger('click');
        }
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
        $('#js-card-listing-' + self.model.attributes.id).html('&nbsp;');
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
                is_card_empty = false;
                card.list_name = _.escape(self.model.attributes.name);
                card.list_id = self.model.attributes.id;
                card.board_users = self.model.board_users;
                filter_attachments = self.model.attachments.where({
                    card_id: card.id
                });
                card.attachments.add(filter_attachments, {
                    silent: true
                });
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
