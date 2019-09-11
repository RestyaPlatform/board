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
    className: 'board-list-outer js-board-list',
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
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
        _.bindAll(this, 'render', 'renderCardsCollection', 'removeRender', 'colorListviewcollection');
        this.model.bind('change:name', this.render);
        this.model.bind('change:custom_fields', this.render);
        this.model.bind('change:color add:color remove:color', this.colorListviewcollection);
        if (!_.isUndefined(this.model.collection)) {
            this.model.collection.board.labels.bind('add', this.renderCardsCollection);
            this.model.collection.board.attachments.bind('add', this.renderCardsCollection);
            this.model.collection.board.attachments.bind('remove', this.renderCardsCollection);
            this.model.collection.board.cards.bind('add', this.renderCardsCollection);
            this.model.collection.board.cards.bind('add', function(e) {
                this.renderCardNumbers();
            }, this);
            this.model.collection.board.cards.bind('add:name', this.renderCardsCollection);
            this.model.collection.board.cards.bind('add:id', this.renderCardsCollection);
            this.model.collection.board.cards.bind('remove', this.renderCardsCollection);
            this.model.collection.board.cards.bind('change:position', this.renderCardsCollection);
            this.model.collection.board.cards.bind('change:is_archived', this.renderCardsCollection);
            this.model.collection.board.cards.bind('change:is_archived', function(e) {
                this.renderCardNumbers();
            }, this);
            this.model.collection.board.cards.bind('change:comment_count', this.renderCardsCollection);
            this.model.collection.board.cards.bind('change:list_id', this.renderCardsCollection);
            this.model.collection.board.cards.bind('change:list_id', function(e) {
                this.renderCardNumbers();
            }, this);
            this.model.collection.board.cards.bind('change:is_filtered', function(e) {
                this.renderCardNumbers();
            }, this);
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
        'click .js-list-color-pick': 'colorPicker',
        'click .js-list-customcolor-card': 'customColorPicker',
        'click .js-remove-list-color': 'removelistColor',
        'click .js-trigger-minimize': 'triggerListMinView',
        'click  a.js-trigger-maximum': 'triggerListMaxView',
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
        var self = this;
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
                if (!_.isUndefined(self.board.attributes) && !_.isUndefined(self.board.attributes.lists) && self.board.attributes.lists !== null) {
                    self.board.attributes.lists.forEach(function(list) {
                        if (list.id === parseInt(list_id)) {
                            list.position = list_position;
                        }
                    });
                }
                self.model.collection.sortByColumn('position');
            }
        });
    },
    /**
     * removelistColor()
     * add selected card in lis
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    removelistColor: function(e) {
        var color_label = '';
        var data = {
            color: color_label
        };
        var self = this;
        var list_id = self.model.id;
        if ($(e.target).parents().find('#js-list-custom-color').length > 0) {
            $(e.target).parents().find('#js-list-custom-color').val(' ');
            $('#list-custom-colorpicker-' + list_id + ' .custom-background-box').css("background-color", color_label);
        }
        $('#js-list-color-' + list_id).attr('style', 'background-color: ' + color_label + ' !important');
        $('#js-list-demo-' + list_id).attr('style', 'border-bottom: ' + color_label);
        $('.js-remove-list-color').addClass('hide');
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + list_id + '.json';
        self.model.save(data, {
            patch: true,
            success: function(model, response) {
                var current_board = App.boards.findWhere({
                    id: parseInt(self.model.attributes.board_id)
                });
                var current_list = current_board.lists.findWhere({
                    id: parseInt(list_id)
                });
                current_list.set('color', color_label);
            }
        });
        return false;
    },
    triggerListMinView: function(e) {
        var self = this;
        var list_id = $(e.currentTarget).data('list_id');
        $(e.currentTarget).parents('#js-board-lists').find('.js-list-' + list_id).addClass('Minimized_list').removeClass('list');
        $(e.currentTarget).parents('#js-board-lists').find('.js-list_maximize_content-' + list_id).addClass('hide');
        $(e.currentTarget).parents('#js-board-lists').find('.list-minimize-view-' + list_id).removeClass('hide');
        var formData = {
            list_collapse: true
        };
        if (!_.isUndefined(self.model.attributes.custom_fields) && !_.isEmpty(self.model.attributes.custom_fields) && self.model.attributes.custom_fields) {
            var list_custom_fields;
            list_custom_fields = JSON.parse(self.model.attributes.custom_fields);
            list_custom_fields.list_collapse = true;
            formData = list_custom_fields;
        }
        var data = {
            custom_fields: JSON.stringify(formData)
        };
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + list_id + '.json';
        self.model.save(data, {
            patch: true,
            success: function(model, response) {
                var current_board = App.boards.findWhere({
                    id: parseInt(self.model.attributes.board_id)
                });
                var current_list = current_board.lists.findWhere({
                    id: parseInt(list_id)
                });
                current_list.set('custom_fields', JSON.stringify(formData));
            }
        });
        return false;
    },
    triggerListMaxView: function(e) {
        var self = this;
        var list_id = $(e.currentTarget).data('list_id');
        $(e.currentTarget).parents('#js-board-lists').find('.js-list-' + list_id).removeClass('Minimized_list').addClass('list');
        $(e.currentTarget).parents('#js-board-lists').find('.js-list_maximize_content-' + list_id).removeClass('hide');
        $(e.currentTarget).parents('#js-board-lists').find('.list-minimize-view-' + list_id).addClass('hide');
        var formData = {
            list_collapse: false
        };
        if (!_.isUndefined(self.model.attributes.custom_fields) && !_.isEmpty(self.model.attributes.custom_fields) && self.model.attributes.custom_fields) {
            var list_custom_fields;
            list_custom_fields = JSON.parse(self.model.attributes.custom_fields);
            list_custom_fields.list_collapse = false;
            formData = list_custom_fields;
        }
        var data = {
            custom_fields: JSON.stringify(formData)
        };
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + list_id + '.json';
        self.model.save(data, {
            patch: true,
            success: function(model, response) {
                var current_board = App.boards.findWhere({
                    id: parseInt(self.model.attributes.board_id)
                });
                var current_list = current_board.lists.findWhere({
                    id: parseInt(list_id)
                });
                current_list.set('custom_fields', JSON.stringify(formData));
            }
        });
        return false;
    },
    /**
     * colorPicker()
     * add selected card in lis
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    colorPicker: function(e) {
        var color_label = $(e.target).closest('li').data('color');
        var data = {
            color: color_label
        };
        var self = this;
        var list_id = self.model.id;
        if ($(e.target).parents().find('#js-list-custom-color').length > 0 && color_label) {
            $(e.target).parents().find('#js-list-custom-color').val(color_label);
            $('#list-custom-colorpicker-' + list_id + ' .custom-background-box').css("background-color", color_label);
        }
        $('#js-list-color-' + list_id).attr('style', 'background-color: ' + color_label + ' !important');
        $('#js-list-demo-' + list_id).attr('style', 'border-bottom: 2px solid' + color_label + ' !important');
        $('.js-remove-list-color').removeClass('hide');
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + list_id + '.json';
        self.model.save(data, {
            patch: true,
            success: function(model, response) {
                var current_board = App.boards.findWhere({
                    id: parseInt(self.model.attributes.board_id)
                });
                var current_list = current_board.lists.findWhere({
                    id: parseInt(list_id)
                });
                current_list.set('color', color_label);
            }
        });
        return false;
    },
    /**
     * customColorPicker()
     * add selected card in lis
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    customColorPicker: function(e) {
        var color_label = $(e.target).parents().find('#js-list-custom-color').val();
        var data = {
            color: color_label
        };
        var self = this;
        var list_id = self.model.id;
        $('#js-list-color-' + list_id).attr('style', 'background-color: ' + color_label + ' !important');
        $('#js-list-demo-' + list_id).attr('style', 'border-bottom: 2px solid' + color_label + ' !important');
        $('.js-remove-list-color').removeClass('hide');
        self.model.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + list_id + '.json';
        self.model.save(data, {
            patch: true,
            success: function(model, response) {
                var current_board = App.boards.findWhere({
                    id: parseInt(self.model.attributes.board_id)
                });
                var current_list = current_board.lists.findWhere({
                    id: parseInt(list_id)
                });
                current_list.set('color', color_label);
            }
        });
        return false;
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
            $('.js-list-header-' + self.model.id).removeClass('hide');
            self.$el.find('.js-wip-limit-section-' + self.model.id).removeClass('hide');
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
                    App.current_board.lists.forEach(function(list) {
                        if (list.id === parseInt(list_id)) {
                            list.name = data.name;
                        }
                    });
                    $('body').trigger('editListRendered');
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
        var self = this;
        $('.js-list-actions-response').remove();
        $(e.currentTarget).after(new App.ListActionsView({
            model: this.model,
            subscribers: this.model.lists_subscribers,
            authuser: this.authuser
        }).el);
        _(function() {
            if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
                if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                    $('body').trigger('listActionRendered', [self.model.id, self.model]);
                }
            }
        }).defer();
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
        var self = this;
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
        _(function() {
            if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
                if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                    $('body').trigger('listActionRendered', [self.model.id, self.model]);
                }
            }
        }).defer();
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
        if (App.boards.get(self.model.attributes.board_id).attributes && !_.isUndefined(App.boards.get(self.model.attributes.board_id).attributes.lists) && App.boards.get(self.model.attributes.board_id).attributes.lists !== null) {
            if (App.boards.get(self.model.attributes.board_id).attributes.lists.length > 0) {
                var boards_attr_list = App.boards.get(self.model.attributes.board_id).attributes.lists.filter(function(list) {
                    return parseInt(list.id) === parseInt(list_id);
                });
                if (boards_attr_list.length > 0) {
                    var boards_attr_list_index = App.boards.get(self.model.attributes.board_id).attributes.lists.indexOf(boards_attr_list[0]);
                    App.boards.get(self.model.attributes.board_id).attributes.lists.splice(boards_attr_list_index, 1);
                }
            }
        }
        this.board.lists.remove(self.model);
        this.model.url = api_url + 'boards/' + self.board.id + '/lists/' + list_id + '.json';
        this.model.destroy({
            success: function(model, response) {
                if (!_.isUndefined(self.board.attributes) && !_.isUndefined(self.board.attributes.lists) && self.board.attributes.lists !== null) {
                    self.board.attributes.lists.forEach(function(list, index) {
                        if (list.id === parseInt(list_id)) {
                            self.board.attributes.lists.splice(index, 1);
                        }
                    });
                }
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
        var self = this;
        var list_id = this.model.id;
        var current_list = this.model.attributes;
        var data = $(e.target).serializeObject();
        var position = parseInt(data.position);
        if (_.isEmpty(position)) {
            position = $(e.target).find('#list_position').val();
        }
        var board_id = parseInt(data.board_id);
        if (sort_by !== null && sort_direction !== null) {
            this.model.collection.sortByColumn(sort_by, sort_direction);
        } else {
            this.model.collection.sortByColumn('position');
        }
        if (board_id !== this.model.attributes.board_id) {
            this.model.collection.remove({
                id: list_id
            });
            this.$el.remove();
            var i = 0;
            var current_position = 0;
            if (sort_by !== null && sort_direction !== null) {
                App.boards.get(board_id).lists.sortByColumn(sort_by, sort_direction);
            } else {
                App.boards.get(board_id).lists.sortByColumn('position');
            }
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
            if (parseFloat(position) !== parseFloat(current_index)) {
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
                if (parseInt(board_id) !== parseInt(self.model.attributes.board_id)) {
                    if (!_.isUndefined(self.board.attributes) && !_.isUndefined(self.board.attributes.lists) && self.board.attributes.lists !== null) {
                        self.board.attributes.lists.forEach(function(list) {
                            if (list.id === parseInt(list_id)) {
                                list.position = data.position;
                            }
                        });
                    }
                }
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
        $(e.currentTarget).removeClass('js-list-subscribe');
        $('i.icon-ok', e.currentTarget).removeClass('hide');
        $('.js-subscribe-text', e.currentTarget).html(i18next.t('Subscribed'));
        $('.js-list-subscribed-' + list_id).removeClass('hide');
        if (!_.isEmpty(this.model.collection.board.acl_links.where({
                slug: "unsubscribe_list",
                board_user_role_id: parseInt(this.model.board_user_role_id)
            })) && !_.isEmpty(subscribe) || (!_.isEmpty(role_links.where({
                slug: "unsubscribe_list"
            })) && this.model.collection.board.attributes.board_visibility == 2)) {
            $(e.currentTarget).addClass('js-list-unsubscribe');
        } else if (typeof subscribe_id === 'undefined' || subscribe_id === 'undefined' || subscribe_id === '') {
            $(e.currentTarget).addClass('hide');
        }
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
            if (!_.isUndefined(this.model.attributes.lists_subscribers) && this.model.attributes.lists_subscribers !== null) {
                this.model.attributes.lists_subscribers.forEach(function(list) {
                    if (list.user_id === parseInt(authuser.user.id)) {
                        list.is_subscribed = 1;
                    }
                });
            }
        } else if (!_.isEmpty(this.model.collection.board.acl_links.where({
                slug: "unsubscribe_list",
                board_user_role_id: parseInt(this.model.board_user_role_id)
            })) || (!_.isEmpty(role_links.where({
                slug: "unsubscribe_list"
            })) && list.collection.board.attributes.board_visibility == 2)) {
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
        $(e.currentTarget).removeClass('js-list-unsubscribe');
        $('i.icon-ok', e.currentTarget).addClass('hide');
        if (!_.isEmpty(this.model.collection.board.acl_links.where({
                slug: "subscribe_list",
                board_user_role_id: parseInt(this.model.board_user_role_id)
            })) && !_.isEmpty(subscribe) || (!_.isEmpty(role_links.where({
                slug: "subscribe_list"
            })) && this.model.collection.board.attributes.board_visibility == 2)) {
            $(e.currentTarget).addClass('js-list-subscribe');
            $('.js-subscribe-text', e.currentTarget).html(i18next.t('Subscribe'));
        } else if (typeof subscribe_id === 'undefined' || subscribe_id === 'undefined' || subscribe_id === '') {
            $(e.currentTarget).addClass('hide');
        }
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
            if (!_.isUndefined(this.model.attributes.lists_subscribers) && this.model.attributes.lists_subscribers !== null) {
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
        board_list.add(this.model.board.lists.models);
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
        var list_id = this.model.id,
            move_list_card_count;
        var self = this;
        var move_list_id = parseInt($(e.currentTarget).data('move-list-id'));
        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_agile_wip', APPS.enabled_apps) !== -1) {
            var move_list = this.model.collection.board.lists.findWhere({
                id: move_list_id
            });
            if (!_.isUndefined(move_list.attributes.custom_fields) && !_.isEmpty(move_list.attributes.custom_fields)) {
                var move_list_custom_fields = JSON.parse(move_list.attributes.custom_fields);
                move_list_card_count = isNaN(move_list.attributes.card_count) ? 0 : move_list.attributes.card_count;
                var list_card_count = isNaN(self.model.attributes.card_count) ? 0 : self.model.attributes.card_count;
                move_list_card_count = move_list_card_count + list_card_count;
                if (!_.isUndefined(move_list_custom_fields.wip_limit) && !_.isEmpty(move_list_custom_fields.wip_limit)) {
                    if (parseInt(move_list_card_count) > parseInt(move_list_custom_fields.wip_limit) && !_.isUndefined(move_list_custom_fields.hard_wip_limit) && !_.isEmpty(move_list_custom_fields.hard_wip_limit)) {
                        self.flash('danger', i18next.t('Agile WIP limit will be exceeded'));
                        return false;
                    }
                }
            }
        }
        var copied_cards = this.model.collection.board.cards.where({
            list_id: list_id
        });
        move_list_card_count = self.model.collection.board.lists.get(move_list_id).attributes.card_count;
        if (parseInt(move_list_card_count) === 0) {
            $('#js-card-listing-' + move_list_id).find('.js-list-placeholder-' + move_list_id).remove();
            /* $('#js-card-listing-' + move_list_id).html(function(i, h) {
                return h.replace(/&nbsp;/g, '');
            }); */
        }
        var view_card = $('#js-card-listing-' + move_list_id);
        _.each(copied_cards, function(copied_card) {
            var options = {
                silent: false
            };
            self.model.collection.board.cards.get(copied_card.id).set({
                list_id: move_list_id
            }, options);
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
        this.model.cards.set(copied_cards);
        this.model.id = list_id;
        this.model.url = api_url + 'boards/' + this.board.id + '/lists/' + list_id + '/cards.json';
        this.model.save({
            list_id: move_list_id
        }, {
            patch: true,
            success: function(model, response) {
                self.model.set('cards_count', 0);
                var options = {
                    silent: true
                };
                var current_board_prev_list = App.current_board.lists.findWhere({
                    id: parseInt(list_id)
                });
                var current_board_new_list = App.current_board.lists.findWhere({
                    id: parseInt(move_list_id)
                });
                var previous_list_card_count = self.model.collection.board.lists.get(list_id).attributes.card_count;
                move_list_card_count = move_list_card_count ? move_list_card_count : 0;
                previous_list_card_count = previous_list_card_count ? previous_list_card_count : 0;
                move_list_card_count = move_list_card_count + previous_list_card_count;
                self.model.collection.board.lists.get(move_list_id).set('cards_count', move_list_card_count, options);
                self.model.collection.board.lists.get(list_id).set('cards_count', 0);
                current_board_prev_list.set('card_count', 0);
                current_board_new_list.set('card_count', move_list_card_count);
                App.boards.get(self.model.attributes.board_id).lists.get(move_list_id).set('cards_count', move_list_card_count, options);
                App.boards.get(self.model.attributes.board_id).lists.get(list_id).set('cards_count', 0);
                self.board.lists.get(move_list_id).set('cards_count', move_list_card_count, options);
                self.board.lists.get(list_id).set('cards_count', 0);
                $('#js-card-listing-' + list_id).html('<span class="js-list-placeholder-' + list_id + '">&nbsp;</span>');
                // $('#js-card-listing-' + list_id).html('&nbsp;');
                App.current_board.lists.get(list_id).set('cards_count', 0);
                App.current_board.lists.get(move_list_id).set('cards_count', move_list_card_count);
                if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_agile_wip', APPS.enabled_apps) !== -1) {
                    if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                        $('body').trigger('listmoveActionRendered', [self.model.id, move_list_id, move_list_card_count]);
                    }
                }
            }
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
        var list = App.boards.get(this.model.attributes.board_id).lists.get(this.model.id);
        if (!_.isUndefined(list)) {
            list.set('card_count', 0);
        }
        this.model.set('card_count', 0);
        this.renderCardsCollection();
        var card = new App.Card();
        card.set('id', list_id);
        card.url = api_url + 'boards/' + this.board.id + '/lists/' + list_id + '/cards.json';
        card.save({
            is_archived: 1
        }, {
            patch: true
        });
        $('#js-card-listing-' + self.model.id).html('<span class="js-list-placeholder-' + self.model.id + '">&nbsp;</span>');
        // $('#js-card-listing-' + self.model.id).html('&nbsp;');
        _(function() {
            if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_agile_wip', APPS.enabled_apps) !== -1) {
                    $('body').trigger('cardAddRendered', [self.model.id, self.model]);
                }
            }
        }).defer();
        return false;
    },
    /**
     * colorListviewcollection()
     * Bidding the color for list
     * @param NULL
     * @return object
     *
     */
    colorListviewcollection: function() {
        var self = this;
        var list_id = self.model.id,
            color = self.model.attributes.color;
        $('#js-list-color-' + list_id).attr('style', 'background-color: ' + color + ' !important');
        $('#js-list-demo-' + list_id).attr('style', 'border-bottom: 2px solid' + color + ' !important');
        if (!_.isUndefined(color) && !_.isEmpty(color) && color !== null) {
            $('#js-remove-list-color-' + list_id).removeClass('hide');
        } else {
            $('#js-list-demo-' + list_id).attr('style', 'border-bottom: ' + color);
            $('#js-remove-list-color-' + list_id).addClass('hide');
        }
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
        touchPunchDelay = 100;
        this.$el.html(this.template({
            list: this.model
        }));
        if (!_.isUndefined(this.model.attributes.custom_fields) && !_.isEmpty(this.model.attributes.custom_fields) && this.model.attributes.custom_fields && typeof this.model.attributes.custom_fields === 'string') {
            var list_custom_fields = JSON.parse(this.model.attributes.custom_fields);
            if (!_.isUndefined(list_custom_fields.list_collapse) && list_custom_fields.list_collapse) {
                this.$el.find('.js-list-' + this.model.attributes.id).addClass('Minimized_list').removeClass('list');
                this.$el.find('.js-list_maximize_content-' + this.model.attributes.id).addClass('hide');
                this.$el.find('.list-minimize-view-' + this.model.attributes.id).removeClass('hide');

            }
        }
        this.renderCardsCollection();
        if (!_.isUndefined(authuser.user)) {
            if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.collection.board.acl_links.where({
                    slug: 'move_list_cards',
                    board_user_role_id: parseInt(this.model.board_user_role_id)
                })))) {
                $('.js-board-list-cards', this.$el).sortable({
                    containment: 'window',
                    items: 'div.js-board-list-card',
                    connectWith: '.js-board-list-cards:not(.js-wip-limit-reached)',
                    placeholder: 'card-list-placeholder',
                    appendTo: document.body,
                    dropOnEmpty: true,
                    distance: 10,
                    cursor: 'grab',
                    helper: 'clone',
                    tolerance: 'pointer',
                    scrollSensitivity: 100,
                    scrollSpeed: 50,
                    update: function(ev, ui) {
                        if (this === ui.item.parent()[0]) {
                            var list_id = parseInt($(ev.target).parents('.js-board-list:first').data('list_id'));
                            var current_list = App.current_board.lists.get(parseInt(list_id));
                            if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_agile_wip', APPS.enabled_apps) !== -1) {
                                var list_custom_fields = current_list.attributes.custom_fields;
                                if (!_.isUndefined(list_custom_fields) && !_.isEmpty(list_custom_fields) && list_custom_fields !== null) {
                                    var card_count = isNaN(current_list.attributes.card_count) ? 0 : current_list.attributes.card_count;
                                    card_count = parseInt(card_count);
                                    card_count = card_count + 1;
                                    list_custom_fields = JSON.parse(list_custom_fields);
                                    if (!_.isUndefined(list_custom_fields.wip_limit) && !_.isEmpty(list_custom_fields.wip_limit) && list_custom_fields.wip_limit !== null) {
                                        if (!_.isUndefined(list_custom_fields.hard_wip_limit) && !_.isEmpty(list_custom_fields.hard_wip_limit) && parseInt(card_count) > parseInt(list_custom_fields.wip_limit)) {
                                            $(this).sortable("cancel");
                                        } else {
                                            ui.item.trigger('cardSort', ev, ui);
                                        }
                                    } else {
                                        ui.item.trigger('cardSort', ev, ui);
                                    }
                                } else {
                                    ui.item.trigger('cardSort', ev, ui);
                                }
                            } else {
                                ui.item.trigger('cardSort', ev, ui);
                            }
                        }
                    },
                    start: function(ev, ui) {
                        ui.helper.height(ui.item.outerHeight() + 10);
                        ui.placeholder.height(ui.item.outerHeight());
                        $('.js-show-modal-card-view ').removeClass('cur');
                    },
                    receive: function(ev, ui) {
                        var list_id = parseInt($(ui.item).parents('.js-board-list:first').data('list_id'));
                        var current_list = App.current_board.lists.get(parseInt(list_id));
                        $('.js-list-header-section').removeClass('animation');
                        $('.js-wip-section').removeClass('tada-animation');
                        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_agile_wip', APPS.enabled_apps) !== -1 && !_.isUndefined(current_list) && !_.isEmpty(current_list) && current_list !== null) {
                            var list_custom_fields = current_list.attributes.custom_fields;
                            if (!_.isUndefined(list_custom_fields) && !_.isEmpty(list_custom_fields) && list_custom_fields !== null) {
                                var card_count = isNaN(current_list.attributes.card_count) ? 0 : current_list.attributes.card_count;
                                card_count = parseInt(card_count);
                                card_count = card_count + 1;
                                list_custom_fields = JSON.parse(list_custom_fields);
                                if (!_.isUndefined(list_custom_fields.wip_limit) && !_.isEmpty(list_custom_fields.wip_limit) && list_custom_fields.wip_limit !== null) {
                                    if (!_.isUndefined(list_custom_fields.hard_wip_limit) && !_.isEmpty(list_custom_fields.hard_wip_limit) && parseInt(card_count) > parseInt(list_custom_fields.wip_limit)) {
                                        ui.sender.sortable("cancel");
                                        $('.js-list-header-' + list_id).removeClass('animation');
                                        $('.js-wip-limit-section-' + list_id).removeClass('tada-animation');
                                    }
                                }
                            }
                        }
                    },
                    stop: function(ev, ui) {
                        $('.js-show-modal-card-view ').addClass('cur');
                        $('.board-list-outer > div.js-list-sort').removeClass('active');
                        clearInterval(App.sortable.setintervalid_horizontal);
                        clearInterval(App.sortable.setintervalid_vertical);
                        App.sortable.is_create_setinterval_horizontal = true;
                        App.sortable.is_create_setinterval_vertical = true;
                        App.sortable.previous_offset_horizontal = 0;
                        App.sortable.previous_offset_vertical = 0;
                        App.sortable.is_create_setinterval_mobile = true;
                        App.sortable.previous_offset_mobile = 0;
                        clearInterval(App.sortable.setintervalidMobile);
                        App.sortable.is_moving_right_mobile = 0;
                        App.sortable.previous_move_mobile = 0;
                        App.sortable.previous_move_horizontal = 0;
                        App.sortable.previous_move_vertical = 0;
                    },
                    over: function(ev, ui) {
                        var list = $(ui.placeholder).parents('.js-board-list-cards').attr('id');
                        var list_id = list.split('js-card-listing-');
                        list_id = list_id['1'];
                        var current_list = App.current_board.lists.get(parseInt(list_id));
                        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_agile_wip', APPS.enabled_apps) !== -1) {
                            $('.js-list-header-section').removeClass('animation');
                            $('.js-wip-section').removeClass('tada-animation');
                            $('.board-list-outer > div.js-list-sort').removeClass('active');
                            var list_custom_fields = current_list.attributes.custom_fields;
                            if (!_.isUndefined(list_custom_fields) && !_.isEmpty(list_custom_fields)) {
                                var card_count = isNaN(current_list.attributes.card_count) ? 0 : current_list.attributes.card_count;
                                card_count = parseInt(card_count);
                                card_count = card_count + 1;
                                list_custom_fields = JSON.parse(list_custom_fields);
                                if (!_.isUndefined(list_custom_fields.wip_limit) && !_.isEmpty(list_custom_fields.wip_limit)) {
                                    if (card_count > parseInt(list_custom_fields.wip_limit) && (_.isUndefined(list_custom_fields.hard_wip_limit) || _.isEmpty(list_custom_fields.hard_wip_limit))) {
                                        $('#' + list).parents('.js-list-' + list_id).addClass('active');
                                    } else if (!_.isUndefined(list_custom_fields.hard_wip_limit) && !_.isEmpty(list_custom_fields.hard_wip_limit) && parseInt(card_count) > parseInt(list_custom_fields.wip_limit)) {
                                        $('.js-list-header-' + list_id).addClass('animation');
                                        $('.js-wip-limit-section-' + list_id).addClass('tada-animation');
                                    }
                                }
                            }
                        }
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
                        $.browser.device = (/android|webos|iphone|ipad|ipod|blackberry|iemobile|opera mini/i.test(navigator.userAgent.toLowerCase()));
                        if ($.browser.device) {
                            var list_per_page = Math.floor($(window).width() / 230);
                            if (App.sortable.previous_offset_mobile !== 0 && App.sortable.previous_offset_mobile != ui.offset.left) {
                                if (App.sortable.previous_offset_mobile > ui.offset.left) {
                                    App.sortable.is_moving_right_mobile = false;
                                } else {
                                    App.sortable.is_moving_right_mobile = true;
                                }
                            }
                            if (App.sortable.previous_move_mobile !== App.sortable.is_moving_right_mobile) {
                                clearInterval(App.sortable.setintervalidMobile);
                                App.sortable.is_create_setinterval_mobile = true;
                            }
                            if (App.sortable.is_moving_right_mobile === true && ui.offset.left > (list_per_page - 1) * 230) {
                                if (App.sortable.is_create_setinterval_mobile) {
                                    App.sortable.setintervalidMobile = setInterval(function() {
                                        scrollLeft = parseInt($('#js-board-lists').scrollLeft()) + 10;
                                        $('#js-board-lists').animate({
                                            scrollLeft: scrollLeft
                                        }, 10);
                                    }, 100);
                                    App.sortable.is_create_setinterval_mobile = false;
                                }
                            } else if (App.sortable.is_moving_right_mobile === false && ui.offset.left < 50) {
                                if (App.sortable.is_create_setinterval_mobile) {
                                    App.sortable.setintervalidMobile = setInterval(function() {
                                        scrollLeft = parseInt($('#js-board-lists').scrollLeft()) - 10;
                                        $('#js-board-lists').animate({
                                            scrollLeft: scrollLeft
                                        }, 10);
                                    }, 100);
                                    App.sortable.is_create_setinterval_mobile = false;
                                }
                            }

                            App.sortable.previous_offset_mobile = ui.offset.left;
                            App.sortable.previous_move_mobile = App.sortable.is_moving_right_mobile;

                        } else {
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
                                        }, 10);
                                    }, 100);
                                    App.sortable.is_create_setinterval_vertical = false;
                                }
                            } else if (App.sortable.is_moving_top === false && ui.offset.top < (additional_top - 20)) {
                                if (App.sortable.is_create_setinterval_vertical) {
                                    App.sortable.setintervalid_vertical = setInterval(function() {
                                        scrollTop = parseInt($('#' + App.sortable.previous_id).scrollTop()) - 50;
                                        $('#' + App.sortable.previous_id).animate({
                                            scrollTop: scrollTop
                                        }, 10);
                                    }, 100);
                                    App.sortable.is_create_setinterval_vertical = false;
                                }
                            }
                            App.sortable.previous_offset_vertical = ui.offset.top;
                            App.sortable.previous_move_vertical = App.sortable.is_moving_top;
                        }
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
    renderCardsCollection: function(e) {
        this.converter.setFlavor('github');
        var filtered_cards = '';
        var self = this;
        this.renderCardNumbers();
        if (!_.isUndefined(e) && e.storeName === 'card') {
            if (e.attributes.list_id === self.model.id) {
                e.attributes.triggersort = true;
                if (_.isUndefined(e.list)) {
                    e.list = self.model;
                }
                if (!_.isUndefined(e.board_users) && !_.isEmpty(e.board_users) && e.board_users !== null) {
                    if (_.isUndefined(e.board_users.board) || _.isEmpty(e.board_users.board) || e.board_users.board === null) {
                        e.board_users.board = self.model.board;
                    }
                } else {
                    e.board_users = self.model.board_users;
                }
                var view;
                view = new App.CardView({
                    tagName: 'div',
                    model: e,
                    converter: self.converter
                });
                var current_param_split = Backbone.history.fragment.split('/');
                if (!_.isUndefined(current_param_split['2']) && current_param_split['2'] !== null && (current_param_split['2'].indexOf('list') !== -1 || current_param_split['2'].indexOf('gantt') !== -1 || current_param_split['2'].indexOf('report') !== -1 || current_param_split['2'].indexOf('calendar') !== -1)) {
                    return true;
                }
                if (parseInt(e.attributes.is_archived) === 0) {
                    if ($('#js-card-' + e.attributes.id).length === 1) {
                        $('#js-card-' + e.attributes.id).replaceWith(view.render().el);
                    } else {
                        filtered_cards = self.model.board.cards.where({
                            is_archived: 0,
                            list_id: parseInt(self.model.id)
                        });
                        if (filtered_cards.length === 1 || self.model.board.cards.length === 0) {
                            $('#js-card-listing-' + e.attributes.list_id).append(view.render().el);
                        } else {
                            self.model.cards.reset(filtered_cards);
                            if (sort_by !== null && sort_direction !== null) {
                                self.model.cards.sortByColumn(sort_by, sort_direction);
                            } else {
                                self.model.cards.sortByColumn('position');
                            }
                            var bool = true;
                            i = 0;
                            var cards_length = self.model.cards.length;
                            self.model.cards.each(function(card) {
                                if (bool) {
                                    if (parseInt(card.attributes.id) === parseInt(e.attributes.id)) {
                                        if (!_.isUndefined(self.model.cards.models[i - 1])) {
                                            var prev_card_id = self.model.cards.models[i - 1].id;
                                            $('#js-card-' + prev_card_id).after(view.render().el);
                                            bool = false;
                                        } else {
                                            $('#js-card-listing-' + e.attributes.list_id).prepend(view.render().el);
                                            bool = false;
                                        }
                                    }
                                    i++;
                                }
                            });
                        }
                    }
                    _(function() {
                        localforage.getItem('unreaded_cards', function(err, value) {
                            if (value) {
                                if (value[e.attributes.id]) {
                                    if ($('#js-card-' + e.attributes.id).find('.js-unread-notification').length === 0) {
                                        $('#js-card-' + e.attributes.id).find('.js-list-card-data').prepend('<li class="js-unread-notification"><small title = "' + i18next.t('unread notifications') + '"><span class="label label-primary"><span class="icon-bell"></span><span>' + value[e.attributes.id] + '</span></span></small>');
                                    } else {
                                        $('#js-card-' + e.attributes.id).find('.js-unread-notification').html('<small title = "' + i18next.t('unread notifications') + '"><span class="label label-primary"><span class="icon-bell"></span><span>' + value[e.attributes.id] + '</span></span></small>');
                                    }
                                }
                            }
                        });
                    }).defer();
                } else {
                    $('#js-card-' + e.attributes.id).remove();
                }
            }
        } else {
            $('#js-list-card-add-form-' + this.model.id).remove();
            $('.js-show-add-card-form', $('#js-card-listing-' + this.model.id).next()).removeClass('hide');
            var view_card = this.$('#js-card-listing-' + this.model.id);
            view_card.html('');
            _(function() {
                unarchived_cards = self.model.board.cards.where({
                    list_id: parseInt(self.model.id),
                    is_archived: 0
                });
                if (parseInt(unarchived_cards.length) === 0) {
                    view_card.html('<span class="js-list-placeholder-' + self.model.id + '">&nbsp;</span>');
                }
            }).defer();
            if (sort_by !== null && sort_direction !== null) {
                this.model.cards.sortByColumn(sort_by, sort_direction);
            } else {
                this.model.cards.sortByColumn('position');
            }
            if (!_.isUndefined(this.model.collection)) {
                filtered_cards = this.model.collection.board.cards.where({
                    list_id: parseInt(this.model.id)
                });
                var cards = new App.CardCollection();
                cards.reset(filtered_cards);
                this.model.cards.add(cards.toJSON(), {
                    silent: true
                });
                if (sort_by !== null && sort_direction !== null) {
                    this.model.cards.sortByColumn(sort_by, sort_direction);
                    cards.sortByColumn(sort_by, sort_direction);
                } else {
                    this.model.cards.sortByColumn('position');
                    cards.sortByColumn('position');
                }
                cards.each(function(card) {
                    var card_id = card.id;
                    var filter_labels = self.model.labels.filter(function(model) {
                        return parseInt(model.get('card_id')) === parseInt(card_id);
                    });
                    var labels = new App.CardLabelCollection();
                    labels.add(filter_labels, {
                        silent: true
                    });
                    card.labels = labels;
                    if (parseInt(card.get('is_archived')) === 0) {
                        card.board_users = self.model.board_users;
                        card.card_voters.add(card.get('card_voters'), {
                            silent: true
                        });
                        card.cards = self.model.board.cards;
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
                        if (_.isUndefined(card.attributes.checklist_item_completed_count)) {
                            var checklist_item_pending_count = card.attributes.checklist_item_count - card.attributes.checklist_item_completed_count;
                            card.set('checklist_item_pending_count', checklist_item_pending_count, {
                                silent: false
                            });
                        }
                        var view = new App.CardView({
                            tagName: 'div',
                            model: card,
                            converter: this.converter
                        });
                        view_card.append(view.render().el);
                        _(function() {
                            localforage.getItem('unreaded_cards', function(err, value) {
                                if (value) {
                                    $.each(value, function(index, count) {
                                        if (count) {
                                            if ($('#js-card-' + index).find('.js-unread-notification').length === 0) {
                                                $('#js-card-' + index).find('.js-list-card-data').prepend('<li class="js-unread-notification"><small title = "' + i18next.t('unread notifications') + '"><span class="label label-primary"><span class="icon-bell"></span><span>' + count + '</span></span></small>');
                                            } else {
                                                $('#js-card-' + index).find('.js-unread-notification').html('<small title = "' + i18next.t('unread notifications') + '"><span class="label label-primary"><span class="icon-bell"></span><span>' + count + '</span></span></small>');
                                            }
                                        }
                                    });
                                }
                            });
                        }).defer();
                    }
                });
            }
        }
    },

    renderCardNumbers: function() {
        var self = this;
        _(function() {
            if (!_.isUndefined(APPS) && APPS !== null) {
                if (!_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
                    if ($.inArray('r_card_counter', APPS.enabled_apps) !== -1) {
                        if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                            $('body').trigger('cardCounterRendered', [self.model.id, self.model]);
                        }
                    }
                }
            }
        }).defer();
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
        var self = this;
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
        _(function() {
            if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                $('body').trigger('addCardRendered', self.model.id, self.model);
            }
        }).defer();
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
        $('.js-list-header-' + this.model.attributes.id).addClass('hide');
        this.$el.find('.js-wip-limit-section-' + this.model.attributes.id).addClass('hide');
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
        toggle.parents('.js-board-list').find('#inputListName').val($('.get-name-' + this.model.attributes.id).html());
        toggle.parents('form').addClass('hide').prev('.js-show-edit-list-form').removeClass('hide');
        this.$('#js-show-list-actions-' + this.model.attributes.id + ', #js-show-sort-form-' + this.model.attributes.id).removeClass('hide');
        $('.js-list-header-' + this.model.attributes.id).removeClass('hide');
        this.$el.find('.js-wip-limit-section-' + this.model.attributes.id).removeClass('hide');
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
            $('<div class="error-msg text-primary h6">Whitespace is not allowed</div>').insertAfter('#AddCard');
            return false;
        } else {
            $('.error-msg').remove();
            e.preventDefault();
            var self = this;
            var data = $(e.target).serializeObject();
            $('.js-remove-card-template').remove();
            $(e.target).find('.js-card-add-list').val(this.model.id);
            $(e.target).find('.js-card-user-ids').val('');
            $(e.target).find('.js-card-add-labels').val('');
            $(e.target).find('.js-card-label').val('');
            $(e.target).find('.js-card-add-position').val('');
            $(e.target).find('.js-users-list').find('ul').empty();
            $(e.target).find('.js-checklist-list').find('ul').empty();
            $(e.target).find('.js-custom_fields-list').find('ul').empty();
            $(e.target).parents('.js-show-modal-card-view').find('.js-lables-list').empty();
            data.uuid = new Date().getTime();
            data.list_id = parseInt(data.list_id);
            data.board_id = parseInt(data.board_id);
            var cards = this.model.collection.board.cards.where({
                list_id: data.list_id
            });
            var list_cards = new App.CardCollection();
            list_cards.add(cards);
            var currentdate = new Date();
            var tmp_created_date = currentdate.getFullYear() + '-' + (((currentdate.getMonth() + 1) < 10) ? '0' + (currentdate.getMonth() + 1) : (currentdate.getMonth() + 1)) + '-' + ((currentdate.getDate() < 10) ? '0' + currentdate.getDate() : currentdate.getDate()) + 'T' + currentdate.getHours() + ':' + (currentdate.getMinutes() < 10 ? '0' : '') + currentdate.getMinutes() + ':' + (currentdate.getSeconds() < 10 ? '0' : '') + currentdate.getSeconds();
            var tmp_card = new App.Card();
            tmp_card.set('is_offline', true);
            tmp_card.set('position', list_cards.length + 1);
            tmp_card.set('checklist_item_completed_count', 0);
            if (!_.isEmpty(data.cards_checklist_item_count)) {
                tmp_card.set('checklist_item_count', parseInt(data.cards_checklist_item_count));
                tmp_card.set('checklist_item_pending_count', parseInt(data.cards_checklist_item_count));
            } else {
                tmp_card.set('checklist_item_count', 0);
                tmp_card.set('checklist_item_pending_count', 0);
            }

            tmp_card.set({
                name: data.name,
                is_archived: 0,
                id: data.uuid,
                list_id: parseInt(data.list_id),
                board_id: parseInt(data.board_id),
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
                    if (list_cards.models[i].id === data.uuid) {
                        newpostionIndex = i;
                        break;
                    }
                }
            }
            if (data.position === undefined || data.position === '') {
                data.position = newpostionIndex + 1;
            }
            $(e.target).find('textarea').val('').focus();
            var view_card = $('#js-card-listing-' + data.list_id);
            var card = new App.Card();
            card.set('is_offline', true);
            data.cards_checklist_item_count = data.cards_checklist_item_count ? data.cards_checklist_item_count : 0;
            card.url = api_url + 'boards/' + self.model.attributes.board_id + '/lists/' + self.model.id + '/cards.json';
            card.set({
                name: data.name,
                is_archived: 0,
                title: data.name,
                list_id: parseInt(data.list_id),
                board_id: parseInt(data.board_id),
                due_date: null,
                end: null,
                checklist_item_count: parseInt(data.cards_checklist_item_count),
                checklist_item_pending_count: parseInt(data.cards_checklist_item_count),
                checklist_item_completed_count: 0
            }, {
                silent: true
            });
            card.board_users = self.model.board_users;
            card.board = self.model.board;
            card.list = self.model;
            var view = new App.CardView({
                tagName: 'div',
                model: card,
                converter: this.converter
            });
            var next = view_card.find('.js-board-list-card:nth-child(' + parseInt(data.position) + ')');
            var prev = view_card.find('.js-board-list-card:nth-child(' + (parseInt(data.position) - 1) + ')');
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
            }
            $('#js-card-listing-' + this.model.id).scrollTop($('#js-card-listing-' + this.model.id)[0].scrollHeight);
            card.save(data, {
                success: function(model, response, options) {
                    if (!_.isUndefined(response) && !_.isEmpty(response) && response !== null && !_.isUndefined(response.activity) && !_.isEmpty(response.activity) && response.activity !== null) {
                        card.set('created', response.activity.created);
                        card.set('card_created_user', response.activity.full_name);
                        card.set('description', response.activity.card_description);
                    }
                    if (!_.isUndefined(response.cards_custom_fields) && !_.isEmpty(response.cards_custom_fields)) {
                        card.set('cards_custom_fields', response.cards_custom_fields);
                    }
                    if (_.isUndefined(options.temp_id)) {
                        card.set('is_offline', false);
                    }
                    card.board_activities.add(self.model.activities);
                    if (!_.isUndefined(response.cards_users) && response.cards_users.length > 0) {
                        response.cards_users.forEach(function(user) {
                            user.card_id = parseInt(user.card_id);
                            user.id = parseInt(user.id);
                            user.user_id = parseInt(user.user_id);
                        });
                        card.set('cards_users', response.cards_users);
                        card.users.add(response.cards_users);
                    }
                    if (!_.isUndefined(response.cards_labels) && response.cards_labels.length > 0) {
                        response.cards_labels.forEach(function(label) {
                            label.card_id = parseInt(label.card_id);
                            label.board_id = parseInt(label.board_id);
                            label.label_id = parseInt(label.label_id);
                            label.list_id = parseInt(label.list_id);
                        });
                        self.board.labels.add(response.cards_labels, {
                            silent: true
                        });
                        if (!_.isUndefined(card.list) && !_.isUndefined(card.list.labels)) {
                            card.list.labels.add(response.cards_labels);
                        }
                        card.labels.add(response.cards_labels);
                    }
                    if (!_.isUndefined(response.cards_checklists) && response.cards_checklists.length > 0) {
                        var option = {
                            silent: true
                        };
                        _.each(response.cards_checklists, function(checklist) {
                            var card_checklist = new App.CheckList();
                            card_checklist.set('is_offline', true);
                            card_checklist.set('card_id', parseInt(response.id));
                            card_checklist.set('list_id', parseInt(card.list.id));
                            card_checklist.set('board_id', parseInt(card.list.attributes.board_id));
                            card_checklist.set({
                                id: parseInt(checklist.id)
                            });
                            card_checklist.set('checklist_item_completed_count', 0);
                            card_checklist.set('checklist_item_count', parseInt(checklist.checklist_item_count));
                            card_checklist.set('checklist_item_pending_count', parseInt(checklist.checklist_item_count));
                            card_checklist.set('name', _.escape(checklist.name));
                            card_checklist.set('card_id', parseInt(response.id));
                            card_checklist.set('list_id', parseInt(card.list.id));
                            card_checklist.set('board_id', parseInt(card.list.attributes.board_id));
                            card_checklist.card = card;
                            if (!_.isUndefined(checklist) && !_.isUndefined(checklist.checklists_items)) {
                                var checklist_items = JSON.parse(checklist.checklists_items);
                                card_checklist.set('checklist_items', checklist_items);
                                _.each(checklist_items, function(item) {
                                    checklist_item = new App.CheckListItem();
                                    checklist_item.set('id', parseInt(item.id));
                                    checklist_item.set('card_id', parseInt(response.id));
                                    checklist_item.set('user_id', parseInt(item.user_id));
                                    checklist_item.set('checklist_id', card_checklist.id);
                                    checklist_item.set('name', item.name);
                                    checklist_item.set('is_completed', 0);
                                    checklist_item.card = card;
                                    checklist_item.checklist = card_checklist;
                                    card.list.collection.board.checklist_items.add(checklist_item, option);
                                });

                            }
                            card.list.collection.board.checklists.add(card_checklist, option);
                            card.checklists.add(card_checklist, option);
                        });
                        var __checklist_items = card.list.collection.board.checklist_items.where({
                            card_id: parseInt(response.id)
                        });
                        items = new App.CheckListItemCollection();
                        items.add(__checklist_items, option);
                        var total_count = items.models.length;
                        card.set('checklist_item_completed_count', 0);
                        card.set('checklist_item_pending_count', total_count);
                        card.set('checklist_item_count', total_count);
                    }
                    var cards_count = isNaN(self.model.attributes.card_count) ? 0 : self.model.attributes.card_count;
                    self.model.set('card_count', parseInt(cards_count) + 1);
                    if (parseInt(self.model.attributes.card_count) === 1) {
                        // Removing the &nbsp; in the card listing after adding card
                        $('#js-card-listing-' + self.model.id).find('.js-list-placeholder-' + self.model.id).remove();
                        /* $('#js-card-listing-' + self.model.id).html(function(i, h) {
                            return h.replace(/&nbsp;/g, '');
                        }); */
                    }
                    var list = App.boards.get(card.attributes.board_id).lists.get(card.attributes.list_id);
                    if (!_.isUndefined(list)) {
                        list.set('card_count', parseInt(cards_count) + 1);
                    }
                    if (!_.isUndefined(response.id) && _.isUndefined(options.temp_id)) {
                        card.set({
                            id: parseInt(response.id)
                        });
                    } else {
                        global_uuid[data.uuid] = options.temp_id;
                        card.set('id', data.uuid);
                    }
                    card.set('comment_count', 0);
                    self.model.collection.board.cards.add(card);
                    self.model.cards.add(card);
                    _(function() {
                        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_agile_wip', APPS.enabled_apps) !== -1) {
                            if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                                $('body').trigger('cardAddRendered', [self.model.id, self.model]);
                            }
                        }
                    }).defer();
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
                view_activity.prepend(view.render().el);
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
        if ($('.js-sort-by-' + self.model.attributes.id).hasClass('active')) {
            $('.js-sort-by-' + self.model.attributes.id).removeClass('active');
        }
        $('.js-sort-down-' + self.model.attributes.id).remove();
        $('.js-sort-up-' + self.model.attributes.id).remove();
        if (!_.isUndefined(self.model.collection)) {
            var filtered_cards = self.model.collection.board.cards.where({
                list_id: parseInt(self.model.id)
            });
            var is_card_empty = true;
            var view = '';
            $('#js-card-listing-' + self.model.attributes.id).html('<span class="js-list-placeholder-' + self.model.attributes.id + '">&nbsp;</span>');
            if (!_.isEmpty(filtered_cards)) {
                _.each(filtered_cards, function(card) {
                    card.set('list_name', _.escape(self.model.attributes.name));
                });
                var cards = new App.CardCollection();
                cards.reset(filtered_cards);
                this.model.cards.add(cards.toJSON(), {
                    silent: true
                });
                if (this.sort_by === sort_by) {
                    $(e.target).parent().addClass('active');
                    $(e.target).html('<i class="icon icon-arrow-up js-sort-up-' + self.model.attributes.id + '"></i>' + i18next.t($(e.target).text()));
                    this.sort_by = sort_by;
                    self.model.cards.sortByColumn(this.sort_by, 'asc');
                    cards.sortByColumn(this.sort_by, 'asc');
                } else {
                    $(e.target).parent().addClass('active');
                    $(e.target).html('<i class="icon icon-arrow-down js-sort-down-' + self.model.attributes.id + '"></i>' + i18next.t($(e.target).text()));
                    this.sort_by = sort_by;
                    self.model.cards.sortByColumn(this.sort_by, 'desc');
                    cards.sortByColumn(this.sort_by, 'desc');
                }

                cards.each(function(card) {
                    is_card_empty = false;
                    if (parseInt(card.get('is_archived')) === 0) {
                        card.list_name = _.escape(self.model.attributes.name);
                        card.list_id = self.model.attributes.id;
                        card.board_users = self.model.board_users;
                        filter_attachments = self.model.attachments.where({
                            card_id: card.id
                        });
                        card.attachments.add(filter_attachments, {
                            silent: true
                        });
                        var filter_labels = self.model.labels.filter(function(model) {
                            return parseInt(model.get('card_id')) === parseInt(card.id);
                        });
                        var labels = new App.CardLabelCollection();
                        labels.add(filter_labels, {
                            silent: true
                        });
                        card.labels = labels;
                        card.card_voters.add(card.get('card_voters'), {
                            silent: true
                        });
                        card.cards.add(self.model.cards, {
                            silent: true
                        });
                        card.list = self.model;
                        card.board = self.model.board;
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
                });
                $('#js-card-listing-' + self.model.attributes.id).find('.js-list-placeholder-' + self.model.attributes.id).remove();
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
    }
});
