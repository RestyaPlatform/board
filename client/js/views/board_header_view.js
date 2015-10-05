/**
 * @fileOverview This file has functions related to board header view. This view calling from board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model and it's related values
 *	this.model.activities			: activities collection(Based on board)
 *	this.model.attachments			: attachments collection(Based on board)
 *  this.model.board_stars			: starred board collection(Based on logged in user)
 *	this.model.board_users  	  	: board user collection(Based on board)
 *	this.model.boards_subscribers  	: board user collection(Based on board)
 *	this.model.cards 			   	: cards collection(Based on board)
 *	this.model.checklists			: checklists collection(Based on card)
 *	this.model.checklist_items		: checklist items collection(Based on checklist)
 *	this.model.custom_attachments	: custom attachments collection(Based on board)
 *	this.model.lists				: lists collection(Based on board)
 *	this.model.labels 			   	: labels collection(Based on board)
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * Board Header View
 * @class BoardHeaderView
 * @constructor
 * @extends Backbone.View
 */
App.BoardHeaderView = Backbone.View.extend({
    className: 'navbar navbar-default',
    attributes: {
        role: 'navigation'
    },
    template: JST['templates/board_header'],
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.model.lists.bind('remove', this.showArchivedListLists, this);
        this.model.cards.bind('add', this.renderCardsCollection);
        this.model.lists.bind('change:is_archived', this.showArchivedListLists, this);
        this.model.cards.bind('change:name', this.showArchivedCardsList, this);
        this.model.cards.bind('change:due_date', this.showArchivedCardsList, this);
        this.model.cards.bind('change:is_archived', this.showArchivedCardsList, this);
        this.model.cards.bind('remove', this.showArchivedCardsList, this);
        this.model.bind('change:organization_id', this.render, this);
        this.model.bind('change:background_picture_url', this.showChangeBackground, this);
        this.model.bind('change:background_pattern_url', this.showChangeBackground, this);
        this.model.bind('change:music_name', this.showChangeBackground, this);
        this.model.bind('change:music_content', this.showChangeBackground, this);
        this.model.board_users.bind('add', this.showFilters, this);
        this.model.board_users.bind('remove', this.showFilters, this);
        this.model.labels.bind('add', this.showFilters, this);
        this.model.labels.bind('change', this.showFilters, this);
        this.model.labels.bind('remove', this.showFilters, this);
        this.authuser = authuser.user;
        this.renderAdminBoardUsers();
    },
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#js-add-board-member-form': function(e) {
            e.preventDefault();
            return false;
        },
        'click .js-star-board': 'starredBoard',
        'click .js-close-popover': 'closePopup',
        'click .js-close-sidebar-popover': 'closeSidebarPopup',
        'click .js-board-visibility': 'showBoardVisibility',
        'click .js-add-board-member-dropdown': 'addBoardMemberDropdown',
        'click .js-close-popover-board-member-dropdown': 'closeBoardMemberDropdown',
        'click .js-subscribe-board': 'subcribeBoard',
        'click .js-switch-grid-view': 'switchGridView',
        'click .js-switch-list-view': 'switchListView',
        'click .js-switch-time-view': 'switchTimeView',
        'click .js-switch-calendar-view': 'switchCalendarView',
        'click .js-show-filters': 'showFilters',
        'click .js-archived-items': 'showArchivedItems',
        'click .js-sync-google-dropdown': 'syncGoogleDropdown',
        'click .js-show-copy-board': 'showCopyBoard',
        'click .js-syn-google-calendar': 'showSyncGoogleCalendar',
        'click .js-close-sub-popover': 'closeSubPopup',
        'click #js-select-google-sync-url': 'selectGoogleSyncUrl',
        'click .js-change-background': 'showChangeBackground',
        'click .js-open-dropdown': 'openDropdown',
        'click .js-change-visibility': 'showAllVisibility',
        'click .js-show-board-modal': 'showListModal',
        'click .js-additional-settings': 'showAdditionalSettings',
        'click .js-close-board': 'closeBoard',
        'click .js-toggle-label-filter': 'toggleCardFilter',
        'click .js-toggle-member-filter': 'toggleCardFilter',
        'click .js-due-filter': 'toggleCardFilter',
        'click .js-back-to-sidebar': 'backToSidebar',
        'click .js-board-user-avatar-click': 'boardUserAvatarDropdown',
        'click .js-close-board-user-avatar': 'closeBoardUserAvatarDropdown',
        'click .js-change-background-image': 'changeBackgroundImage',
        'click .js-change-background-pattern': 'changeBackgroundPattern',
        'click .js-change-custom-background': 'changeCustomBackground',
        'click .js-modal-fliker-trigger': 'modalFlickrTtrigger',
        'click .js-delete-background-img': 'ClearBackground',
        'click .js-modal-music-trigger': 'modalMusicTtrigger',
        'click .js-music-clear': 'ClearMusic',
        'click .js-show-archived-card-lists': 'showArchivedCardsList',
        'click .js-show-archived-lists': 'showArchivedListLists',
        'keyup .js-search-archived-lists': 'showFilteredArchivedListLists',
        'keyup .js-search-archived-cards': 'showFilteredArchivedCardsList',
        'click .js-send-card-to-board': 'sendCardTobard',
        'keyup #inputBoardUserSearch': 'showSearchBoardMembers',
        'click #submitBoardRename': 'boardRename',
        'click .js-close-span-popover': 'closeSpanPopover',
        'click .js-set-privte-board': 'setPrivteBoard',
        'click .js-set-public-board': 'setPublicBoard',
        'click .js-show-board-organization': 'showBoardOrganization',
        'submit .js-save-board-visibility': 'saveBoardVisibility',
        'click .js-change-color': 'changeBackgroundColor',
        'click .js-send-list-to-board': 'sendListToboard',
        'click .js-enable-covers': 'toggleAdditionalSettings',
        'click .js-computer-open-board-background': 'computerOpenBoardBackground',
        'change #js-custom-background-attachment': 'addBoardBackground',
        'click .js-no-action': 'noAction',
        'click .js-back-to-board-visibility': 'showBoardVisibility',
        'click .js-select': 'selectBoardVisibility',
    },
    /**
     * openDropdown()
     * copy the existing card
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    openDropdown: function(e) {
        e.preventDefault();
        var target = $(e.target);
        target.parents('li.dropdown:first, div.dropdown:first').addClass('open');
        return false;
    },


    /**
     * syncGoogleDropdown()
     * show the sync the board cards duedate to google calander URL
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    syncGoogleDropdown: function(e) {
        e.preventDefault();
        $('.js-sync-google-dropdown').addClass('open');
        return false;
    },
    /**
     * boardRename()
     * close the dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var el = this.$el;
        var target = el.find(e.target);
        target.parents('div.dropdown:first, li.dropdown:first').removeClass('open');
        return false;
    },
    /**
     * closeSidebarPopup()
     * close the dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closeSidebarPopup: function(e) {
        var el = this.$el;
        var target = el.find(e.target);
        target.parents('div.dropdown:first').removeClass('open');
        return false;
    },
    /**
     * closeSubPopup()
     * close the sub dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closeSubPopup: function(e) {
        var el = this.$el;
        var target = el.find(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    },
    /**
     * showBoardVisibility()
     * display the board visibility
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardVisibility: function(e) {
        var target = $(e.target);
        this.$('.js-back-to-board-visibility').addClass('hide');
        var parent = target.parents('.js-visibility-list-dropdown');
        var visibility = this.model.attributes.board_visibility;
        var insert = $('.js-visibility-list', parent);
        insert.nextAll().remove();
        $(new App.ShowBoardVisibilityView({
            model: visibility
        }).el).insertAfter(insert);
        parent.addClass('open');
        return false;
    },
    /**
     * subcribeBoard()
     * subcribe the board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    subcribeBoard: function(e) {
        e.preventDefault();
        var name = $(e.currentTarget).attr('name');
        var value = 'unsubscribe';
        var content = '<i class="icon-eye-close"></i>Unsubscribe';
        if (name == 'unsubscribe') {
            value = 'subscribe';
            content = '<i class="icon-eye-open"></i>Subscribe';
        }
        $(e.currentTarget).attr('name', value);
        $(e.currentTarget).attr('title', value);
        $(e.currentTarget).html(content);
        var boardSubscriber = new App.BoardSubscriber();
        if (!_.isUndefined(this.model.board_subscriber) && this.model.board_subscriber.attributes.id) {
            value = '';
            if ($('#inputBoardSubscribe').val() == 'false') {
                value = 'true';
                $('#inputBoardSubscribe').val(value);
            } else {
                value = 'false';
                $('#inputBoardSubscribe').val(value);
            }
            var data = $('form#BoardSubscribeForm').serializeObject();
            boardSubscriber.url = api_url + 'boards/' + this.model.id + '/board_subscribers/' + this.model.board_subscriber.attributes.id + '.json';
            boardSubscriber.set('id', this.model.board_subscriber.attributes.id);
            boardSubscriber.save(data, {
                success: function(model, response) {}
            });
        } else {
            var subscribe_data = {
                board_id: this.model.id,
                is_subscribed: true
            };
            var self = this;
            boardSubscriber.url = api_url + 'boards/' + this.model.id + '/board_subscribers.json';
            boardSubscriber.save(subscribe_data, {
                success: function(model, response) {
                    boardSubscriber.set('id', parseInt(response.id));
                    boardSubscriber.set('user_id', parseInt(response.user_id));
                    boardSubscriber.set('board_id', parseInt(response.board_id));
                    boardSubscriber.set('board_id', (response.is_subscribed === 't') ? true : false);
                    self.model.board_subscriber = boardSubscriber;
                    self.model.board_subscribers.add(boardSubscriber);
                    self.render();
                }
            });
        }
        return false;
    },
    /**
     * starredBoard()
     * subcribe the board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    starredBoard: function(e) {
        e.preventDefault();
        var name = $(e.currentTarget).attr('name');
        var value = 'unstar';
        var is_starred = true;
        var self = this;
        var content = '<i class="icon-star text-primary"></i>';
        if (name == 'unstar') {
            value = 'star';
            is_starred = false;
            content = '<i class="icon-star-empty"></i>';
        }
        $(e.currentTarget).attr('name', value);
        $(e.currentTarget).html(content);
        self.boardStar = new App.BoardStar();
        var subscribe_data = {};
        self.boardStar.url = api_url + 'boards/' + this.model.id + '/boards_stars.json';
        self.boardStar.set('board_id', this.model.attributes.id);
        self.boardStar.set('user_id', parseInt(authuser.user.id));
        self.boardStar.set('is_starred', is_starred);
        self.boardStar.save(subscribe_data, {
            success: function(model, response) {
                App.boards.get(self.model.attributes.id).boards_stars.reset(self.boardStar);
                self.model.boards_stars.add(self.boardStar);
                self.footerView = new App.FooterView({
                    model: authuser
                }).renderStarredBoards();
            }
        });
        return false;
    },
    /**
     * closeBoard()
     * close the board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closeBoard: function(e) {
        e.preventDefault();
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        App.boards.get(this.model.id).set('is_closed', true);
        this.footerView = new App.FooterView({
            model: authuser,
            board_id: this.model.id
        }).renderClosedBoards();
        var board_id = this.model.id;
        this.model.save({
            is_closed: true
        }, {
            patch: true,
            success: function(model, response) {}
        });
        return false;
    },
    showAllVisibility: function(e) {
        var target = $(e.target);
        var parent = target.parents('.js-visibility-chooser-copy-board-dropdown');
        var visibility = $('#inputBoardVisibility').val();
        var insert = $('.js-visibility-chooser-copy-board', parent);
        insert.nextAll().remove();
        $(new App.ShowAllVisibilityView({
            model: visibility
        }).el).insertAfter(insert);
        parent.addClass('open');
        return false;
    },
    /**
     * showChangeBackground()
     * display the board background change form
     * @return false
     *
     */
    showChangeBackground: function() {
        $('.js-side-bar-' + this.model.id).addClass('side-bar-large');
        var el = this.$el;
        el.find('.js-setting-response').html(new App.BoardBackgroundView({
            model: this.model
        }).el);
        var self = this;
        _(function() {
            Backbone.TemplateManager.baseUrl = '{name}';
            var uploadManager = new Backbone.UploadManager({
                uploadUrl: api_url + 'boards/' + self.model.id + '/custom_backgrounds.json?token=' + api_token,
                autoUpload: true,
                singleFileUploads: true,
                dropZone: $('#custom-background-dropzone'),
                formData: $('form.js-cusotm-background-add').serialize(),
                fileUploadHTML: '<input id="cusotmBackgroundUpload" type="file" name="attachment"/>',
            });
            uploadManager.on('fileadd', function(file) {
                $('#custom-dropzone-cssloader').addClass('cssloader');
            });
            uploadManager.on('filedone', function(file, data) {
                $('#custom-dropzone-cssloader').removeClass('cssloader');
                self.model.set({
                    background_picture_url: ''
                }, {
                    silent: true
                });
                self.model.set({
                    background_picture_url: data.result.background_picture_url + "?fx=" + _.random(1000, 9999)
                });
            });
            uploadManager.renderTo($('#manager-area'));
        }).defer();
        var headerH = $('header').height();
        var windowH = $(window).height();
        var footerH = $('footer').height();
        var boardH = windowH - headerH - footerH - 14;
        $('.member-modal.js-pre-scrollable').css({
            'max-height': boardH - 50,
            'overflow-y': 'auto'
        });
        return false;
    },
    /**
     * showArchivedItems()
     * display the archived items
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showArchivedItems: function(e) {
        var el = this.$el;
        e.preventDefault();
        el.find('.side-bar').addClass('side-bar-large');
        el.find('.js-setting-response').html(new App.ArchivedItemsView({
            model: this.model
        }).el);
        this.showArchivedCardsList();
        var headerH = $('header').height();
        var windowH = $(window).height();
        var footerH = $('footer').height();
        var boardH = windowH - headerH - footerH - 14;
        $('.member-modal.js-pre-scrollable').css({
            'max-height': boardH - 50,
            'overflow-y': 'auto'
        });
        return false;
    },
    /**
     * showArchivedCardsList()
     * display the archived cards list
     * @return false
     *
     */
    showArchivedCardsList: function() {
        if (!_.isEmpty(role_links.where({
                slug: 'view_archived_cards'
            }))) {
            var el = this.$el;
            var filtered_cards = this.model.cards.where({
                is_archived: true
            });
            el.find('.js-archived-items-container').html(new App.ArchivedCardsView({
                model: this.model
            }).el);
            if (!_.isEmpty(filtered_cards)) {
                _.each(filtered_cards, function(card) {
                    el.find('.js-archived-cards-container').append(new App.ArchivedCardView({
                        model: card
                    }).el);
                });
            } else {
                el.find('.js-archived-cards-container').append(new App.ArchivedCardView({
                    model: null
                }).el);
            }
        }
        return false;
    },
    /**
     * showFilteredArchivedCardsList()
     * display the filtered archived cards list
     * @return false
     *
     */
    showFilteredArchivedCardsList: function(e) {
        if (!_.isEmpty(role_links.where({
                slug: 'view_archived_cards'
            }))) {
            var el = this.$el;
            var search_q = $(e.currentTarget).val();
            var filtered_cards = '';
            if (!_.isEmpty(search_q)) {
                filtered_cards = this.model.cards.filter(function(model) {
                    return ~model.get('name').indexOf(search_q);
                });
            } else {
                filtered_cards = this.model.cards.where({
                    is_archived: true
                });
            }
            el.find('.js-archived-cards-container').html("");
            if (!_.isEmpty(filtered_cards)) {
                var _i = 0;
                _.each(filtered_cards, function(card) {
                    if (card.attributes.is_archived === true) {
                        el.find('.js-archived-cards-container').append(new App.ArchivedCardView({
                            model: card
                        }).el);
                        _i++;
                    }
                });
                if (_i === 0) {
                    el.find('.js-archived-cards-container').append(new App.ArchivedCardView({
                        model: null
                    }).el);
                }

            } else {
                el.find('.js-archived-cards-container').append(new App.ArchivedCardView({
                    model: null
                }).el);
            }
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
        var self = this;
        this.is_admin = false;
        changeTitle('Board - ' + _.escape(this.model.attributes.name));
        if (!_.isUndefined(this.authuser)) {
            this.model.board_subscriber = this.model.board_subscribers.findWhere({
                user_id: parseInt(this.authuser.id)
            });
            this.model.board_star = this.model.board_stars.findWhere({
                user_id: parseInt(this.authuser.id)
            });
            var admin = this.model.board_users.findWhere({
                user_id: parseInt(authuser.user.id),
                is_admin: true
            });
            this.is_admin = (!_.isEmpty(admin) || (!_.isUndefined(authuser.user) && authuser.user.role_id === 1)) ? true : false;
        }
        this.$el.html(this.template({
            board: this.model,
            subscriber: this.model.board_subscriber,
            star: this.model.board_star,
            is_admin: this.is_admin
        }));
        $('a.js-switch-grid-view').parent().addClass('active');
        this.showTooltip();
        this.renderBoardUsers();
        return this;
    },
    /**
     * showAdditionalSettings()
     * show the Additional Settings
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showAdditionalSettings: function(e) {
        e.preventDefault();
        var el = this.$el;
        el.find('.js-setting-response').html(new App.BoardAdditionalSettingsView({
            model: this.model,
        }).el);
        return false;
    },
    /**
     * showFilters()
     * show the filter list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showFilters: function() {
        $('.js-side-bar-' + this.model.id).addClass('side-bar-large');
        var el = this.$el;
        el.find('.js-setting-response').html(new App.BoardFilterView({
            model: this.model,
            labels: this.model.labels
        }).el);
        var headerH = $('header').height();
        var windowH = $(window).height();
        var footerH = $('footer').height();
        var boardH = windowH - headerH - footerH - 14;
        $('.member-modal.js-pre-scrollable').css({
            'max-height': boardH - 50,
            'overflow-y': 'auto'
        });
        return false;
    },
    /**
     * modalMusicTtrigger()
     * display the attachment in the list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    modalMusicTtrigger: function(e) {
        $('#music-modal').remove();
        var modalView = new App.ModalMusicView({
            model: this.model
        });
        modalView.show();
        return false;
    },
    /**
     * modalFlickrTtrigger()
     * display the attachment in the list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    modalFlickrTtrigger: function(e) {
        var type = $(e.currentTarget).data('type');
        $('#flickr-modal').remove();
        var modalView = new App.ModalFlickrPhotoView({
            model: this.model,
            type: type
        });
        modalView.show();
        return false;
    },
    /**
     * showListModal()
     * display the attachment in the list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showListModal: function(e) {
        var modalView = new App.ModalBoardView({
            model: this.model
        });
        modalView.show();
        return false;
    },
    /**
     * switchListView()
     * swith to the list view
     * @param e
     * @type Object(DOM event)
     *
     */
    switchListView: function() {
        $('body').removeClass('modal-open');
        $('#boards-view').removeClass('col-xs-12');
        $('#switch-board-view').removeClass('calendar-view');
        $('#switch-board-view').addClass('board-viewlist col-xs-12');
        $('li.js-switch-view').removeClass('active');
        $('a.js-switch-list-view').parent().addClass('active');
        $('.js-list-form').removeClass('hide');
        var current_param = Backbone.history.fragment;
        if (current_param.indexOf('/list') === -1) {
            app.navigate('#/board/' + this.model.id + '/list', {
                trigger: false,
                trigger_function: false,
            });
        }
        var self = this;
        $('div.js-baord-view-' + self.model.id).html(new App.SwitchToListView({
            model: self.model
        }).el);
        var is_card_empty = true;
        var board_view = $('.js-card-list-view-' + self.model.attributes.id);
        var lists = self.model.lists;
        var list_length = lists.models.length;
        for (var list_i = 0; list_i < list_length; list_i++) {
            var list = lists.models[list_i];
            if (_.isUndefined(list.get('is_new')) && list.get('is_archived') === false) {
                self.model.cards.sortByColumn('position');
                var filtered_cards = self.model.cards.where({
                    list_id: list.attributes.id,
                    is_archived: false
                });
                if (!_.isEmpty(filtered_cards)) {
                    is_card_empty = false;
                }
                var cards = new App.CardCollection();
                cards.reset(filtered_cards, {
                    silent: true
                });
                var card_length = cards.models.length;
                for (var i = 0; i < card_length; i++) {
                    var card = cards.models[i];
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
                    var view = new App.CardView({
                        tagName: 'tr',
                        className: 'js-show-modal-card-view',
                        model: card,
                        template: 'list_view'
                    });
                    board_view.append(view.render().el);
                }
            }
        }
        if (is_card_empty) {
            var empty_view = new App.CardView({
                tagName: 'tr',
                className: '',
                model: null,
                board_id: self.model.id,
                template: 'list_view'
            });
            empty_view.render();
        } else {
            if (!_.isUndefined(card_ids) && card_ids !== null && card_ids !== '') {
                _.defer(function(view) {
                    trigger_dockmodal = true;
                    var trigger_card_ids = card_ids.split(',');
                    for (var i = 0; i < trigger_card_ids.length; i++) {
                        $('#js-card-' + trigger_card_ids[i]).trigger('click');
                    }
                    card_ids = null;
                    trigger_dockmodal = false;
                }, this);

            }
        }
        return false;
    },
    /**
     * switchTimeView()
     * swith to the list view
     * @param e
     * @type Object(DOM event)
     *
     */
    switchTimeView: function() {
        $('body').removeClass('modal-open');
        $('#boards-view').addClass('col-xs-12');
        $('#switch-board-view').addClass('Timesheet-view calendar-view');
        $('#switch-board-view').removeClass('board-viewlist col-xs-12');
        $('li.js-switch-view').removeClass('active');
        $('a.js-switch-time-view').parent().addClass('active');
        $('.js-list-form').removeClass('hide');
        var current_param = Backbone.history.fragment;
        if (current_param.indexOf('/timeline') === -1) {
            app.navigate('#/board/' + this.model.id + '/timeline', {
                trigger: false,
                trigger_function: false,
            });
        }

        var timedata = this.model.cards.invoke('pick', ['title', 'due_date']);
        var timesheetData = '';
        $.each(timedata.reverse(), function(index, value) {
            if (value.due_date !== null) {
                timesheetData += '- ' + value.due_date + ' ' + value.title + " \n ";
            }
        });
        var config = {
            yearLength: 120, // 120px per year
            hideAge: true, // Hide age from year axis
            customStylesheetURL: null, // Custom stylesheet
            //fetchURL: 'http://localhost/restyaboard/client/js/libs/life.md', // url from where values need to  be fetched
            renderData: timesheetData // fetched data
        };
        life.start(config);
        slider.init();
        $('div.js-baord-view-' + this.model.id).html('');
        $('div.js-baord-view-' + this.model.id).html(life.$el.innerHTML);
        changeTitle('Board - ' + _.escape(this.model.attributes.name));
        return false;
    },
    /**
     * switchCalendarView()
     * swith to the calendar view
     * @param e
     * @type Object(DOM event)
     *
     */
    switchCalendarView: function() {
        $('body').removeClass('modal-open');
        $('#boards-view').addClass('col-xs-12');
        $('#switch-board-view').addClass('calendar-view');
        $('#switch-board-view').removeClass('board-viewlist col-xs-12');
        $('li.js-switch-view').removeClass('active');
        $('a.js-switch-calendar-view').parent().addClass('active');
        $('.js-list-form').removeClass('hide');
        var current_param = Backbone.history.fragment;
        if (current_param.indexOf('/calendar') === -1) {
            app.navigate('#/board/' + this.model.id + '/calendar', {
                trigger: false,
                trigger_function: false,
            });
        }
        $('div.js-baord-view-' + this.model.id).html('');
        $('div.js-baord-view-' + this.model.id).fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            selectable: true,
            selectHelper: true,
            editable: false,
            ignoreTimezone: false,
            aspectRatio: 3.35
        });
        if (!_.isEmpty(this.model.cards)) {
            $('div.js-baord-view-' + this.model.id).fullCalendar('addEventSource', this.model.cards.invoke('pick', ['title', 'start']));
        }
        return false;
    },
    /**
     * showSyncGoogleCalendar()
     * get sync google calender URL and display
     * @param e
     * @type Object(DOM event)
     *
     */
    showSyncGoogleCalendar: function(e) {
        e.preventDefault();
        var el = this.$el;
        el.find('.js-setting-response').html(new App.ShowSyncGoogleCalendarView({
            model: this.model
        }).el);
    },
    /**
     * showCopyBoard()
     * get copy board view
     * @param e
     * @type Object(DOM event)
     *
     */
    showCopyBoard: function(e) {
        e.preventDefault();
        var el = this.$el;
        el.find('.js-setting-response').html(new App.ShowCopyBoardView({
            model: this.model
        }).el);
    },
    /**
     * selectGoogleSyncUrl()
     * select google sync URL
     * @param e
     * @type Object(DOM event)
     *
     */
    selectGoogleSyncUrl: function(e) {
        $(e.target).select();
    },
    addBoardMemberDropdown: function(e) {
        e.preventDefault();
        $('.js-add-board-member-dropdown').addClass('open');
        $('.js-board-user-avatar-click').removeClass('open');
        return false;
    },
    /**
     * closeBoardMemberDropdown()
     * copy the existing card
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closeBoardMemberDropdown: function(e) {
        e.preventDefault();
        $('.js-add-board-member-dropdown').removeClass('open');
        return false;
    },
    renderAdminBoardUsers: function() {
        var admins = this.model.board_users.filter(function(normal_user) {
            return normal_user.attributes.is_admin === true || normal_user.attributes.is_admin === 't';
        });
        this.model.admin_board_users = admins;
        var normal_users = this.model.board_users.filter(function(normal_user) {
            return normal_user.attributes.is_admin === false || normal_user.attributes.is_admin === 'f';
        });
        this.model.normal_board_users = normal_users;
        this.render();
    },
    backToSidebar: function(e) {
        e.preventDefault();
        $('.js-side-bar-' + this.model.id).removeClass('side-bar-large');
        var el = this.$el;
        el.find('.js-back-setting-response').next().remove();
        el.find('.js-back-setting-response').after(new App.BoardSidebarView({
            model: this.model,
            is_admin: this.is_admin
        }).el);
        this.renderBoardUsers();
        return false;
    },
    renderBoardUsers: function() {
        $('.js-get-board-member-lists-response').html('');
        var is_admin = false;
        if (!_.isUndefined(this.authuser)) {
            var admin = this.model.board_users.find(function(normal_user) {
                return normal_user.attributes.user_id === authuser.user.id && normal_user.attributes.is_admin === true || normal_user.attributes.is_admin === 't';
            });
            is_admin = (!_.isEmpty(admin) || authuser.user.role_id === 1) ? true : false;
        }

        var self = this;
        this.model.board_users.sortBy('is_admin');
        this.model.board_users.each(function(board_user) {
            is_admin = (board_user.attributes.is_admin === true || board_user.attributes.is_admin === 't') ? true : false;
            self.$('.js-get-board-member-lists-response').append(new App.BoardUsersView({
                model: board_user,
                is_admin: is_admin
            }).el);
        });
    },
    /**
     * boardUserAvatarDropdown()
     * copy the existing card
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    boardUserAvatarDropdown: function(e) {
        e.preventDefault();
        $(e.currentTarget).addClass('open');
        $(e.currentTarget).siblings('.dropdown').removeClass('open');
        return false;
    },
    /**
     * ClearBackground()
     * Clear the board background image
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    ClearBackground: function(e) {
        var image = $(e.currentTarget).data('background');
        $('body').removeAttr('style');
        $('body').css('background-image', 'none');
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('background_picture_url', '');
        this.model.set('background_pattern_url', '');
        this.model.set('custom_background_url', '');
        this.model.set('background_color', '');

        App.boards.get(this.model.id).set('background_picture_url', '');
        App.boards.get(this.model.id).set('background_pattern_url', '');
        App.boards.get(this.model.id).set('custom_background_url', '');
        App.boards.get(this.model.id).set('background_color', '');

        data = {
            background_color: 'NULL',
            background_picture_url: 'NULL',
            background_pattern_url: 'NULL',
            custom_background_url: 'NULL'
        };
        this.model.save(data, {
            patch: true
        });
        var view_my_board = $('.js-myboard-list');
        view_my_board.html('');
        if (!_.isEmpty(App.boards.models)) {
            _.each(App.boards.models, function(board) {
                view_my_board.append(new App.MyBoardsListingView({
                    model: board,
                    authuser: authuser,
                    attributes: {
                        class: 'js-show-board-star'
                    }
                }).el);
            });
        }
        return false;
    },
    /**
     * ClearMusic()
     * Clear the board Music
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    ClearMusic: function(e) {
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('music_name', '');
        this.model.set('music_content', '');
        data = {
            music_name: '',
            music_content: ''
        };
        this.model.save(data, {
            patch: true
        });
        App.music.music_content = '';
        if (!_.isUndefined(App.music.inst)) {
            App.music.inst.silence();
        }
        this.footerView = new App.FooterView({
            model: authuser,
        }).render();
        $('#footer').html(this.footerView.el);
        return false;
    },

    /**
     * changeBackgroundImage()
     * display the board background image
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    changeBackgroundImage: function(e) {
        var image = $(e.currentTarget).data('background');
        var image_path = 'img/board_background/medium/' + image;
        $('body').removeAttr('style').css({
            'background': 'url(' + image_path + ') 25% 25% no-repeat fixed',
            'background-size': 'cover'
        }).addClass('board-view-pattern board-view');
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('background_picture_url', image_path);
        this.model.set('background_pattern_url', '');
        this.model.set('custom_background_url', '');
        this.model.set('background_color', '');
        data = {
            background_color: 'NULL',
            background_picture_url: image_path,
            background_pattern_url: 'NULL'
        };
        this.model.save(data, {
            patch: true
        });
        return false;
    },
    /**
     * changeBackgroundPattern()
     * display the board background pattern
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    changeBackgroundPattern: function(e) {
        var image = $(e.currentTarget).data('background');
        var image_path = 'img/board_background/patterns/' + image;
        $('body').removeAttr('style').css({
            'background': 'url(' + image_path + ')',
        }).addClass('board-view-pattern board-view');
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('background_pattern_url', image_path);
        this.model.set('custom_background_url', '');
        this.model.set('background_picture_url', '');
        this.model.set('background_color', '');
        data = {
            background_color: 'NULL',
            background_picture_url: 'NULL',
            background_pattern_url: image_path
        };
        this.model.save(data, {
            patch: true
        });
        return false;
    },
    /**
     * showArchivedListLists()
     * display the archived lists list
     * @return false
     *
     */
    showArchivedListLists: function() {
        if (!_.isEmpty(role_links.where({
                slug: 'view_archived_lists'
            }))) {
            var el = this.$el;

            el.find('.js-archived-items-container').html(new App.ArchivedListsView({
                model: this.model
            }).el);
            var filtered_lists = this.model.lists.where({
                is_archived: true
            });
            if (!_.isEmpty(filtered_lists)) {
                _.each(filtered_lists, function(list) {
                    el.find('.js-archived-cards-container').append(new App.ArchivedListView({
                        model: list
                    }).el);
                });
            } else {
                el.find('.js-archived-cards-container').append(new App.ArchivedListView({
                    model: null
                }).el);
            }
        }
        return false;
    },
    /**
     * showFilteredArchivedListLists()
     * display the filtered archived lists list
     * @return false
     *
     */
    showFilteredArchivedListLists: function(e) {
        if (!_.isEmpty(role_links.where({
                slug: 'view_archived_lists'
            }))) {
            var el = this.$el;
            var search_q = $(e.currentTarget).val();
            var filtered_lists = '';
            if (!_.isEmpty(search_q)) {
                filtered_lists = this.model.lists.filter(function(model) {
                    return ~model.get('name').indexOf(search_q);
                });
            } else {
                filtered_lists = this.model.lists.where({
                    is_archived: true
                });
            }
            el.find('.js-archived-cards-container').html("");
            if (!_.isEmpty(filtered_lists)) {
                var _i = 0;
                _.each(filtered_lists, function(list) {
                    if (list.attributes.is_archived === true) {
                        el.find('.js-archived-cards-container').append(new App.ArchivedListView({
                            model: list
                        }).el);
                        _i++;
                    }
                });
                if (_i === 0) {
                    el.find('.js-archived-cards-container').append(new App.ArchivedListView({
                        model: null
                    }).el);
                }
            } else {
                el.find('.js-archived-cards-container').append(new App.ArchivedListView({
                    model: null
                }).el);
            }
        }
        return false;
    },
    /**
     * sendCardTobard()
     * send back to archived card to board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    sendCardTobard: function(e) {
        e.preventDefault();
        var card_id = $(e.currentTarget).data('card_id');
        this.model.cards.findWhere({
            id: parseInt(card_id)
        }).set('is_archived', false);
        var find_card = this.model.cards.findWhere({
            id: parseInt(card_id)
        });
        this.model.cards.get(find_card.id).set('is_archived', false);
        $(e.currentTarget).parents('li').remove();
        var card = new App.Card();
        card.set('id', card_id);
        card.set('is_archived', false);
        card.url = api_url + 'boards/' + this.model.attributes.id + '/lists/' + find_card.attributes.list_id + '/cards/' + card_id + '.json';
        card.save({
            success: function(model, response) {}
        });
        return false;
    },
    /**
     * showSearchBoardMembers()
     * display searched member list
     */
    showSearchBoardMembers: function(e) {
        if (e.which === 13) {
            return false;
        }
        var self = this;
        var q = $('#inputBoardUserSearch').val();
        var users = new App.UserCollection();
        users.url = api_url + 'users/search.json';
        users.fetch({
            data: {
                q: q
            },
            success: function() {
                $('.js-board-member-search-response').html('');
                var is_user_empty = true;
                _.each(users.models, function(user) {
                    var is_already_added = self.model.board_users.where({
                        user_id: parseInt(user.id)
                    });
                    if (_.isEmpty(is_already_added)) {
                        is_user_empty = false;
                        $('.js-board-member-search-response').append(new App.BoardMemberAddSearchResultView({
                            model: user,
                            board: self.model
                        }).el);
                    }


                });
                if (users.models.length === 0 || is_user_empty) {
                    $('.js-board-member-search-response').html(new App.BoardMemberAddSearchResultView({
                        model: null,
                        className: 'small',
                    }).el);
                }

            }
        });

    },
    /**
     * switchGridView()
     * switch to grid view
     * @param e
     * @type Object(DOM event)
     *
     */
    switchGridView: function(e) {
        $('body').addClass('modal-open');
        e.preventDefault();
        app.navigate('#/board/' + this.model.id, {
            trigger: false,
            trigger_function: false,
        });
        $('#content').html(new App.BoardView({
            model: this.model
        }).el);
        this.board_view_height();
    },
    /**
     * boardRename()
     * Edit the board name
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    boardRename: function(e) {
        e.preventDefault();
        var el = this.$el;
        var data = el.find('form#BoardRenameForm').serializeObject();
        var board = new App.Board();
        this.model.set(data);
        App.boards.get(this.model.attributes.id).set(data);
        board.set(data);
        board.set('id', this.model.id);
        board.url = api_url + 'boards/' + this.model.id + '.json';
        board.save(data, {
            patch: true
        });
        $('.js-rename-board').html("<strong>" + _.escape(data.name) + "</strong>");
        this.closeSpanPopover(e);
        return false;
    },
    /**
     * closeSpanPopover()
     * close popup
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closeSpanPopover: function(e) {
        var el = this.$el;
        var target = el.find(e.target);
        target.parents('span.dropdown').removeClass('open');
        return false;
    },
    /**
     * saveBoardVisibility()
     * change the board visibility
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    saveBoardVisibility: function(e) {
        e.preventDefault();
        var target = $(e.target);
        data = target.serializeObject();
        data.board_visibility = 1;

        var organizations = authuser.user.organizations;
        var org = organizations.findWhere({
            id: parseInt(data.organization_id)
        });
        this.model.set('organization_name', _.escape(org.attributes.name));
        this.model.set('organization_logo_url', _.escape(org.attributes.organization_logo_url));
        this.model.set('board_visibility', 1);
        this.model.set('organization_id', parseInt(data.organization_id));


        $('.js-sidebar-board-visibility').html('Change Visibility');
        var board = new App.Board();
        this.model.url = api_url + 'boards/' + this.model.attributes.id + '.json';

        this.closePopup(e);
        this.model.save(data, {
            patch: true
        });
        target.parents('div.dropdown').removeClass('open');
        return false;
    },
    /**
     * showChangeOrganizationForm()
     * show board organiztion change form
     * @param e
     * @type Object(DOM event)
     *
     */
    showChangeOrganizationForm: function(e) {
        var target = $(e.target);
        var parent = target.parents('.js-visibility-list-dropdown');
        var visibility = this.model.attributes.board_visibility;
        var insert = $('.js-visibility-list', parent);
        insert.nextAll().remove();
        $(new App.BoardOrganizationFormView({
            model: authuser.user.organizations,
            board: this.model
        }).el).insertAfter(insert);
    },
    /**
     * changeBackgroundColor()
     * display the board background color
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    changeBackgroundColor: function(e) {
        var color = $(e.currentTarget).data('color');
        $('body').removeAttr('style').css('background', color).addClass('board-view');
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('background_color', color);
        this.model.set('background_picture_url', '');
        this.model.set('background_pattern_url', '');
        this.model.set('custom_background_url', '');
        data = {
            background_color: color,
            background_picture_url: null,
            background_pattern_url: null
        };
        this.model.save(data, {
            patch: true,
        });
        return false;
    },
    /**
     * sendListToboard()
     * send back to archived list to board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    sendListToboard: function(e) {
        e.preventDefault();
        var list_id = $(e.currentTarget).data('list_id');
        var view_list = this.$('#js-board-lists');
        this.model.lists.findWhere({
            id: parseInt(list_id)
        }).set('is_archived', false);
        var find_list = this.model.lists.findWhere({
            id: parseInt(list_id)
        });
        this.model.lists.get(find_list.id).set('is_archived', false);
        App.boards.get(find_list.attributes.board_id).lists.get(find_list.id).set('is_archived', false);
        $(e.currentTarget).parents('li').remove();
        var list = new App.List();
        list.set('id', list_id);
        list.set('is_archived', false);
        list.url = api_url + 'boards/' + this.model.attributes.id + '/lists/' + list_id + '.json';
        list.save({
            success: function(model, response) {}
        });
        return false;
    },
    /**
     * toggleAdditionalSettings()
     * toggle thr label filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    toggleAdditionalSettings: function(e) {
        var target = $(e.currentTarget);
        if (target.hasClass('js-AdditionalSettings-enabled')) {
            data = {
                'is_show_image_front_of_card': false
            };
            $('div.js-card-attachment-image').addClass('hide');
            $('.js-AdditionalSettings-enabled').addClass('hide');
            $('.js-AdditionalSettings-enable').removeClass('hide');
            this.model.set('is_show_image_front_of_card', false);
        } else {
            data = {
                'is_show_image_front_of_card': true
            };
            $('div.js-card-attachment-image').removeClass('hide');
            $('.js-AdditionalSettings-enabled').removeClass('hide');
            $('.js-AdditionalSettings-enable').addClass('hide');
            this.model.set('is_show_image_front_of_card', true);
        }
        var board = new App.Board();
        board.url = api_url + 'boards/' + this.model.attributes.id + '.json';
        board.set('id', this.model.attributes.id);
        board.save(data);
        return false;
    },
    /**
     * toggleCardFilter()
     * toggle thr label filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    toggleCardFilter: function(e) {
        var target = $(e.currentTarget);
        target.toggleClass('selected', !target.hasClass('selected'));
        this.cardFilter();
        return false;
    },
    /**
     * cardFilter()
     * toggle thr label filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    cardFilter: function(e) {
        var contain = '';
        var not_contain = '';
        var selected_label = '';
        $('i.js-filter-icon').remove();
        if ($('li.selected', $('ul.js-board-labels')).length === 0) {
            $('ul.js-card-labels').parents('div.js-board-list-card').show();
            $('ul.js-card-labels').parents('tr.js-show-modal-card-view').show();
        }
        $('li.selected > div.js-label', $('ul.js-board-labels')).each(function() {
            not_contain += ':not(:contains(' + $(this).html() + '))';
            contain += 'ul.js-card-labels:contains(' + $(this).html() + '), ';
            if ($(this).next('i').length === 0) {
                $(this).after('<i class="icon-ok js-filter-icon cur"></i>');
            }
        });
        if ($('li.selected', $('ul.js-board-users')).length === 0) {
            $('ul.js-card-users').parents('div.js-board-list-card').show();
            $('ul.js-card-users').parents('tr.js-show-modal-card-view').show();
        }
        $('li.selected > div.media > span.navbar-btn > span.js-user', $('ul.js-board-users')).each(function() {
            not_contain += ':not(:contains(' + $(this).html() + '))';
            contain += 'ul.js-card-users:contains(' + $(this).html() + '), ';
            if ($(this).next('i').length === 0) {
                $(this).after('<i class="icon-ok js-filter-icon cur"></i>');
            }
        });
        if ($('li.selected', $('ul.js-board-dues')).length === 0) {
            $('ul.js-card-due').parents('div.js-board-list-card').show();
            $('ul.js-card-due').parents('tr.js-show-modal-card-view').show();
        }
        $('li.selected > div.media > span.js-due', $('ul.js-board-dues')).each(function() {
            not_contain += ':not(:contains(' + $(this).html() + '))';
            contain += 'ul.js-card-due:contains(' + $(this).html() + '), ';
            if ($(this).next('i').length === 0) {
                $(this).after('<i class="icon-ok js-filter-icon cur"></i>');
            }
        });
        contain = contain.substring(0, contain.lastIndexOf(', '));
        if (!_.isEmpty(not_contain)) {
            $('ul.js-card-labels' + not_contain).parents('div.js-board-list-card').hide();
            $('ul.js-card-labels' + not_contain).parents('tr.js-show-modal-card-view').hide();
            $('ul.js-card-users' + not_contain).parents('div.js-board-list-card').hide();
            $('ul.js-card-users' + not_contain).parents('tr.js-show-modal-card-view').hide();
            $('ul.js-card-due' + not_contain).parents('div.js-board-list-card').hide();
            $('ul.js-card-due' + not_contain).parents('tr.js-show-modal-card-view').hide();
            $(contain).parents('div.js-board-list-card').show();
            $(contain).parents('tr.js-show-modal-card-view').show();
        }
    },
    /**
     * computerOpenBoardBackground()
     * trigger file upload
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    computerOpenBoardBackground: function(e) {
        var fileLi = $(e.target);
        $('#js-custom-background-attachment').remove();
        var form = $('#js-board-custom-background-form');
        $(form).append('<input class="hide" type="file" name="attachment" id="js-custom-background-attachment">');
        $('#js-custom-background-attachment', form).trigger('click');
        return false;
    },
    /**
     * addBoardBackground()
     * add card attachment
     * @param e
     * @type Object(DOM event)
     */
    addBoardBackground: function(e) {
        e.preventDefault();
        var self = this;
        $('#custom-dropzone-cssloader').addClass('cssloader');
        var form = $('#js-board-custom-background-form');
        var target = $(e.target);
        var fileData = new FormData(form[0]);
        this.model.url = api_url + 'boards/' + this.model.id + '/custom_backgrounds.json';
        this.model.save(fileData, {
            type: 'POST',
            data: fileData,
            processData: false,
            cache: false,
            contentType: false,
            success: function(model, response) {
                $('#custom-dropzone-cssloader').removeClass('cssloader');
                self.model.set({
                    background_picture_url: ''
                }, {
                    silent: true
                });
                self.model.set({
                    background_picture_url: response.background_picture_url + '?' + Date.now()
                });
            }
        });
    },
    noAction: function(e) {
        e.preventDefault();
        return false;
    },
    /**
     * setPrivteBoard()
     * change the board visibility as privte
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    setPrivteBoard: function(e) {
        e.preventDefault();
        this.model.url = api_url + 'boards/' + this.model.attributes.id + '.json';
        this.model.set({
            board_visibility: 0,
            organization_id: 0
        });
        this.closePopup(e);
        this.model.save({
            board_visibility: 0,
            organization_id: 0
        }, {
            patch: true
        });
        var target = $(e.target);
        target.parents('div.dropdown').removeClass('open');
        return false;
    },
    /**
     * setPublicBoard()
     * change the board visibility as public
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    setPublicBoard: function(e) {
        e.preventDefault();
        this.model.url = api_url + 'boards/' + this.model.attributes.id + '.json';
        this.model.set({
            board_visibility: 2,
            organization_id: 0
        });
        this.closePopup(e);
        this.model.save({
            board_visibility: 2,
            organization_id: 0
        }, {
            patch: true
        });
        var target = $(e.target);
        target.parents('div.dropdown').removeClass('open');
        return false;
    },
    /**
     * showBoardOrganization()
     * change the board visibility as organization
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showBoardOrganization: function(e) {
        e.preventDefault();
        this.$('.js-back-to-board-visibility').removeClass('hide');
        this.showChangeOrganizationForm(e);
        return false;
    },
    /**
     * selectBoardVisibility()
     * change the board visibility
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    selectBoardVisibility: function(e) {
        var name = $(e.currentTarget).attr('name');
        var value = 0;
        var content = '<i class="icon-lock"></i>Private';
        $('#js-board-add-organization').html('');
        if (name == 'org') {
            value = 1;
            content = '<i class="icon-group"></i>Organization';
            $('#js-change-visible-content').html(content);
            this.showBoardAddeOrganizationForm(e);
        } else if (name == 'public') {
            content = '<i class="icon-circle"></i>Public';
            value = 2;
        }

        $('#inputBoardCopyVisibility').val(value);
        $('#js-change-visible-content').html(content);
        $('.js-visibility-chooser-copy-board-dropdown').removeClass('open');
        $('.js-visibility-chooser-copy-board').nextAll().remove();
        return false;
    },
    /**
     * showChangeOrganizationForm()
     * show board organiztion change form
     * @param e
     * @type Object(DOM event)
     *
     */
    showBoardAddeOrganizationForm: function(e) {
        e.preventDefault();
        var organizations = new App.OrganizationCollection();
        organizations = authuser.user.organizations;
        if (authuser.user.organizations !== null && _.isUndefined(authuser.user.organizations.models)) {
            organizations.add(JSON.parse(authuser.user.organizations));
        }
        authuser.user.organizations = organizations;
        $('#js-board-add-organization').html(new App.BoardAddOrganizationFormView({
            model: authuser.user.organizations
        }).el);
    }
});
