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
if (typeof App == 'undefined') {
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
    converter: new Showdown.converter(),
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
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
        this.model.bind('remove', this.removeRender);
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
        'listSort': 'listSort'
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
        this.model.save({
            position: this.model.attributes.position
        }, {
            patch: true
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
        e.preventDefault();
        var temp_data = {};
        var list_id = this.model.id;
        var bool = $('.js-list-subscribed-' + list_id).hasClass('hide');
        var data = $(e.target).serializeObject();
        temp_data.name = data.name + 0;
        this.model.set(temp_data);
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '.json';
        this.model.save(data, {
            patch: true
        });
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
        this.model.set('is_archived', true);
        this.model.url = api_url + 'boards/' + self.board.id + '/lists/' + list_id + '.json';
        App.boards.get(this.model.attributes.board_id).lists.get(this.model.attributes.id).set('is_archived', true);
        this.model.save({
            is_archived: true
        }, {
            patch: true,
            success: function(model, response) {
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
        var list_id = this.model.id;
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
        }
        App.boards.get(this.model.attributes.board_id).lists.get(this.model.attributes.id).set('position', this.model.attributes.position);
        data.position = this.model.attributes.position;
        data.board_id = board_id;
        this.model.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '.json';
        this.model.save(data, {
            patch: true
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
        $('.js-subscribe-text', e.currentTarget).html('Subscribed');
        $('.js-list-subscribed-' + list_id).removeClass('hide');
        var list_subscribe = new App.ListSubscriber();
        list_subscribe.set('user_id', parseInt(authuser.user.id));
        list_subscribe.set('is_subscribed', true);
        this.model.lists_subscribers.add(list_subscribe);
        if (typeof subscribe_id === 'undefined' || subscribe_id === 'undefined' || subscribe_id === '') {
            var subscribe = {
                subscribe: {
                    is_subscribed: 't'
                }
            };
            list_subscribe.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '/list_subscribers.json';
            list_subscribe.save({
                is_subscribed: true
            });
        } else {
            list_subscribe.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '/list_subscribers/' + subscribe_id + '.json';
            list_subscribe.save({
                id: parseInt(subscribe_id),
                is_subscribed: true
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
        $('.js-subscribe-text', e.currentTarget).html('Subscribe');
        var subscribe_id = $(e.currentTarget).data('subscribe-id');
        var list_id = this.model.id;
        $('.js-list-subscribed-' + list_id).addClass('hide');
        var list_subscribe = new App.ListSubscriber();
        this.model.lists_subscribers.remove(this.model.lists_subscribers.findWhere({
            user_id: parseInt(authuser.user.id),
            is_subscribed: true
        }));
        if (typeof subscribe_id === 'undefined' || subscribe_id === 'undefined' || subscribe_id === '') {
            list_subscribe.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '/list_subscribers.json';
            list_subscribe.save({
                is_subscribed: false
            });
        } else {
            list_subscribe.url = api_url + 'boards/' + this.model.attributes.board_id + '/lists/' + list_id + '/list_subscribers/' + subscribe_id + '.json';
            list_subscribe.save({
                id: parseInt(subscribe_id),
                is_subscribed: false
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
        var current_list = this.model;
        var board_list = new App.ListCollection();
        board_list.add(this.model.collection.models);
        var filtered_lists = board_list.where({
            is_archived: false
        });
        this.$('.js-list-actions-response').html(new App.MoveCardsFromListView({
            filtered_lists: filtered_lists,
            model: this.model,

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
            self.model.collection.board.cards.get(archived_card.attributes.id).set('is_archived', true);
        });
        var card = new App.Card();
        card.set('id', list_id);
        card.url = api_url + 'boards/' + this.board.id + '/lists/' + list_id + '/cards.json';
        card.save({
            is_archived: true
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
            $('.js-board-list-cards', this.$el).sortable({
                containment: 'window',
                items: 'div.js-board-list-card',
                connectWith: '.js-board-list-cards',
                placeholder: 'card-list-placeholder',
                appendTo: document.body,
                dropOnEmpty: true,
                cursor: 'grabbing',
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
                },
                over: function(ev, ui) {
                    var scrollLeft = 0;
                    if ((($(window).width() - ui.offset.left) < 520) || (ui.offset.left > $(window).width())) {
                        scrollLeft = $('#js-board-lists').stop().scrollLeft() + ($(window).width() - ui.offset.left);
                        $('#js-board-lists').animate({
                            scrollLeft: scrollLeft
                        }, 800);
                    } else if (ui.offset.left <= 260) {
                        scrollLeft = $('#js-board-lists').stop().scrollLeft() - ($(window).width() - ui.offset.left);
                        $('#js-board-lists').animate({
                            scrollLeft: scrollLeft
                        }, 800);
                    }

                },
                change: function(event, ui) {
                    var scrollTop = 0;
                    if ((($(window).height() - ui.offset.top) < 350) || (ui.offset.top > $(window).height())) {
                        scrollTop = $(this).scrollTop() + ($(window).height() - ui.offset.top);
                        $(this).stop().animate({
                            scrollTop: scrollTop
                        }, 800);
                    } else if (ui.offset.top <= 230) {
                        scrollTop = $(this).scrollTop() - ($(window).height() - ui.offset.top);
                        $(this).stop().animate({
                            scrollTop: scrollTop
                        }, 800);
                    }
                }
            });
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
                list_id: this.model.id
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
                if (card.get('is_archived') === false || card.get('is_archived') === 'f') {
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
            className: 'col-xs-12',
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
        this.$('#js-show-list-actions-' + this.model.attributes.id).addClass('hide');
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
        this.$('#js-show-list-actions-' + this.model.attributes.id).removeClass('hide');
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
            is_archived: false,
            list_id: parseInt(data.list_id),
            board_id: parseInt(data.board_id),
            due_date: null,
            checklist_item_count: 0,
            checklist_item_completed_count: 0
        }, {
            silent: true
        });
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
                is_closed: false
            });
            board.lists.add(board.attributes.lists);
            var board_lists = board.lists.where({
                is_archived: false,
                is_deleted: false
            });
            var current_position = this.model.collection.indexOf(this.model) + 1;
            for (var i = 1; i <= board_lists.length; i++) {
                if (self.model.attributes.board_id == board.attributes.id && i == current_position) {
                    content_position += '<option value="' + i + '" selected="selected">' + i + '(current)</option>';
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
                    content_position += '<option value="' + self.model.attributes.position + '" selected="selected">' + self.model.attributes.position + '(current)</option>';
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
                content_list += '<option value="' + list.id + '" selected="selected">' + list.attributes.name + '(current)</option>';
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
    }
});
