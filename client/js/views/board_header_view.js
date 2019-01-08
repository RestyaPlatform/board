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
if (typeof App === 'undefined') {
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
        this.model.lists.bind('change:name', this.showArchivedListLists, this);
        this.model.lists.bind('change:is_archived', this.showArchivedListLists, this);
        this.model.lists.bind('remove', this.showArchivedListLists, this);
        this.model.cards.bind('change:name', this.showArchivedCardsList, this);
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
        this.model.labels.bind('change', this.showLabels, this);
        this.model.labels.bind('remove', this.showLabels, this);
        this.authuser = authuser.user;
        this.renderAdminBoardUsers();
        if (!_.isUndefined(authuser.user)) {
            var board_user_role_id = this.model.board_users.findWhere({
                user_id: parseInt(authuser.user.id)
            });
            if (!_.isEmpty(board_user_role_id)) {
                this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
            }
        }
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
        'click .js-show-subscribe-form': 'showSubscribeForm',
        'click .js-show-board-actions': 'showBoardActions',
        'click .js-show-unsubscribe-form': 'showUnsubscribeForm',
        'click .js-switch-grid-view': 'switchGridView',
        'click .js-switch-list-view': 'switchListView',
        'click .js-switch-calendar-view': 'switchCalendarView',
        'click .js-show-filters': 'showFilters',
        'click .js-invite-users': 'showInviteUserView',
        'click .js-show-labels': 'showLabels',
        'click .js-archived-items': 'showArchivedItems',
        'click .js-sync-google-dropdown': 'syncGoogleDropdown',
        'click .js-show-copy-board': 'showCopyBoard',
        'click .js-syn-google-calendar': 'showSyncGoogleCalendar',
        'click .js-close-sub-popover': 'closeSubPopup',
        'click #js-select-google-sync-url': 'selectGoogleSyncUrl',
        'click .js-change-background': 'showChangeBackground',
        'click .js-email-to-board-settings': 'showEmailToBoardSetting',
        'click .js-open-dropdown': 'openDropdown',
        'click .js-change-visibility': 'showAllVisibility',
        'click .js-show-board-modal': 'showListModal',
        'click .js-additional-settings': 'showAdditionalSettings',
        'click .js-close-board': 'closeBoard',
        'click .js-toggle-label-filter': 'toggleCardFilter',
        'click .js-toggle-member-filter': 'toggleCardFilter',
        'click .js-toggle-color-filter': 'toggleCardFilter',
        'click .js-clear-filter-btn': 'clearAll',
        'click .js-due-filter': 'toggleCardFilter',
        'click .js-filter-mode': 'toggleCardFilter',
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
        'submit #BoardRenameForm': 'boardRename',
        'click .js-close-span-popover': 'closeSpanPopover',
        'click .js-set-privte-board': 'setPrivteBoard',
        'click .js-set-public-board': 'setPublicBoard',
        'click .js-show-board-organization': 'showBoardOrganization',
        'submit .js-save-board-visibility': 'saveBoardVisibility',
        'click .js-change-color': 'changeBackgroundColor',
        'click .js-send-list-to-board': 'sendListToboard',
        'click .js-enable-covers': 'toggleAdditionalSettings',
        'click .js-enable-board-notification': 'toggleBoardNotification',
        'click .js-enable-card-notification': 'toggleCardNotification',
        'click .js-computer-open-board-background': 'computerOpenBoardBackground',
        'change #js-custom-background-attachment': 'addBoardBackground',
        'click .js-no-action': 'noAction',
        'click .js-back-to-board-visibility': 'showBoardVisibility',
        'click .js-select': 'selectBoardVisibility',
        'click .js-clear-all': 'clearAll',
        'click .js-rename-board': 'loadBoardName',
        'keyup[f] .js-setting-response': 'keyboardShowFilters',
        'keyup[w] .js-setting-response': 'keyboardOpenDropdown',
        'keyup[x] .js-setting-response': 'keyboardClearAll',
        'keyup[q] .js-setting-response': 'keyboardToggleCardFilter',
        'keyup[up] body': 'keyboardUpNavigateCards',
        'keyup[down] body': 'keyboardDownNavigateCards',
        'keyup[left] body': 'keyboardLeftNavigateCards',
        'keyup[right] body': 'keyboardRightNavigateCards',
        'keyup[return] body': 'keyboardShowCardModal',
        'keyup[k] body': 'keyboardShowPrevCardModal',
        'keyup[j] body': 'keyboardShowNextCardModal',
        'click .js-show-chat-modal': 'showChatListModal',
        'click .js-show-chat-history-modal': 'showChatHistoryModal',
        'click .js-load-more-archived-cards': 'loadMoreArchivedCardsList',
        'click .js-load-more-archived-lists': 'loadMoreArchivedListLists'
    },
    /**
     * loadBoardName()
     * load the board name
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    loadBoardName: function(e) {
        e.preventDefault();
        $('#inputBoardName').val(this.model.attributes.name);
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
    showSubscribeForm: function(e) {
        $('.js-setting-response').html(new App.SubscribeBoardConfirmView({
            model: this.model,
        }).el);
        return false;
    },

    showBoardActions: function(e) {
        var self = this;
        _(function() {
            if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                $('body').trigger('boardActionRendered', [self.model.id, self.model]);
            }
        }).defer();
    },

    showUnsubscribeForm: function(e) {
        $('.js-setting-response').html(new App.UnsubscribeBoardConfirmView({
            model: this.model,
        }).el);
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
        var is_starred = 1;
        var self = this;
        var content = '<i class="icon-star text-primary"></i>';
        if (name == 'unstar') {
            value = 'star';
            is_starred = 0;
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
                if (!_.isUndefined(App.boards.get(self.model.attributes.id))) {
                    App.boards.get(self.model.attributes.id).boards_stars.reset(self.boardStar);
                }
                self.model.boards_stars.add(self.boardStar);
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
        App.boards.get(this.model.id).set({
            is_closed: 1
        }, {
            silent: true
        });
        var board_id = this.model.id;
        this.model.save({
            is_closed: 1
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
     * showEmailToBoardSetting()
     * display Email to board setting form
     * @return false
     *
     */
    showEmailToBoardSetting: function() {
        $('.js-side-bar-' + this.model.id).addClass('side-bar-large');
        var el = this.$el;
        el.find('.js-setting-response').html(new App.EmailToBoardSettingView({
            model: this.model
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
                pasteZone: null,
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
        this.page = 1;
        this.start = 0;
        this.start_filter = 0;
        this.page_filter = 1;
        this.listpage = 1;
        this.liststart = 0;
        this.liststart_filter = 0;
        this.listpage_filter = 1;
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
    showArchivedCardsList: function(e) {
        if (!_.isUndefined(e)) {
            this.start = 0;
            this.liststart = 0;
            this.page = 1;
            this.listpage = 1;
        }
        this.start = (this.start !== 0) ? this.start : 0;
        this.page = (this.page !== 1) ? this.page : 1;
        this.liststart = (this.liststart !== 0) ? this.liststart : 0;
        this.listpage = (this.listpage !== 1) ? this.listpage : 1;
        if (this.$el.find('#js-load-more-archived-cards').hasClass('hide')) {
            this.$el.find('#js-load-more-archived-cards').removeClass('hide').addClass('show');
        }
        if (this.$el.find('#js-load-more-archived-lists').hasClass('show')) {
            this.$el.find('.js-load-more-archived-lists').removeClass('show').addClass('hide');
        } else {
            this.$el.find('.js-load-more-archived-lists').addClass('hide');
        }
        var self = this;
        if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.acl_links.where({
                slug: 'view_archived_cards',
                board_user_role_id: parseInt(this.model.board_user_role_id)
            })))) {
            var el = this.$el;
            var filtered_cards = this.model.cards.where({
                is_archived: 1
            });
            var archived_card = '';
            if (!_.isEmpty(this.q)) {
                if (self.page_filter == 1) {
                    el.find('.js-archived-items-container').html(new App.ArchivedCardsView({
                        model: this.model
                    }).el);
                }
                archived_card = el.find('.js-archived-cards-container');
                filtered_cards = filtered_cards.filter(function(model) {
                    return ~model.get('name').toUpperCase().indexOf(self.q.toUpperCase());
                });
                if (!_.isEmpty(filtered_cards)) {
                    $('.js-delete-all-archived-cards-confirm').removeClass('hide');
                    _.each(filtered_cards, function(card, key) {
                        count = self.page_filter * 9;
                        if (key === self.start_filter) {
                            if (count > (self.start_filter)) {
                                self.start_filter++;
                                card.acl_links = self.model.acl_links;
                                card.board_users = self.model.board_users;
                                var view = new App.ArchivedCardView({
                                    model: card
                                });
                                archived_card.append(view.render().el);
                            }
                            if (filtered_cards.length == self.start_filter) {
                                self.$el.find('.js-load-more-archived-cards').removeClass('show').addClass('hide');
                            }
                        }
                    });
                } else {
                    $('.js-delete-all-archived-cards-confirm').addClass('hide');
                    $('.js-delete-all-archived-cards').addClass('hide');
                    this.$el.find('.js-load-more-archived-cards').removeClass('show').addClass('hide');
                    archived_card.append(new App.ArchivedCardView({
                        model: null
                    }).el);
                }
            } else {
                if (self.page == 1) {
                    el.find('.js-archived-items-container').html(new App.ArchivedCardsView({
                        model: this.model
                    }).el);
                }
                archived_card = el.find('.js-archived-cards-container');
                if (!_.isEmpty(filtered_cards)) {
                    $('.js-delete-all-archived-cards-confirm').removeClass('hide');
                    _.each(filtered_cards, function(card, key) {
                        count = self.page * 10;
                        if (key === self.start) {
                            if (count > (self.start)) {
                                self.start++;
                                card.acl_links = self.model.acl_links;
                                card.board_users = self.model.board_users;
                                var view = new App.ArchivedCardView({
                                    model: card
                                });
                                archived_card.append(view.render().el);
                            }
                            if (filtered_cards.length == self.start) {
                                self.$el.find('.js-load-more-archived-cards').removeClass('show').addClass('hide');
                            }
                        }
                    });
                } else {
                    $('.js-delete-all-archived-cards-confirm').addClass('hide');
                    $('.js-delete-all-archived-cards').addClass('hide');
                    this.$el.find('.js-load-more-archived-cards').removeClass('show').addClass('hide');
                    archived_card.append(new App.ArchivedCardView({
                        model: null
                    }).el);
                }
            }
        }
        return false;
    },
    /**
     * loadMoreArchivedCardsList()
     * display the archived cards list
     * @return false
     *
     */
    loadMoreArchivedCardsList: function(e) {
        e.preventDefault();
        if (!_.isEmpty(this.q)) {
            this.page_filter++;
            this.showArchivedCardsList();
        } else {
            this.page++;
            this.showArchivedCardsList();
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
        e.preventDefault();
        var self = this;
        self.start_filter = 0;
        if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.acl_links.where({
                slug: 'view_archived_cards',
                board_user_role_id: parseInt(this.model.board_user_role_id)
            })))) {
            var el = this.$el;
            this.q = $(e.currentTarget).val();
            var filtered_cards = this.model.cards.where({
                is_archived: 1
            });
            if (!_.isEmpty(this.q)) {
                filtered_cards = filtered_cards.filter(function(model) {
                    return ~model.get('name').toUpperCase().indexOf(self.q.toUpperCase());
                });
            }
            el.find('.js-archived-cards-container').html('');
            if (!_.isEmpty(filtered_cards)) {
                _.each(filtered_cards, function(card, key) {
                    count = self.page_filter * 9;
                    if (key === self.start_filter) {
                        if (count >= (self.start_filter)) {
                            self.start_filter++;
                            el.find('.js-archived-cards-container').append(new App.ArchivedCardView({
                                model: card
                            }).el);
                        }
                        if (filtered_cards.length == self.start_filter) {
                            self.$el.find('.js-load-more-archived-cards').removeClass('show').addClass('hide');
                        }
                    }
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
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var self = this;
        changeTitle('Board - ' + _.escape(this.model.attributes.name));
        if (!_.isUndefined(this.authuser)) {
            this.model.board_subscriber = this.model.board_subscribers.findWhere({
                user_id: parseInt(this.authuser.id)
            });
            this.model.board_star = this.model.board_stars.findWhere({
                user_id: parseInt(this.authuser.id)
            });
        }
        this.$el.html(this.template({
            board: this.model,
            subscriber: this.model.board_subscriber,
            star: this.model.board_star,
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
     * showInviteUserView()
     * show the filter list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showInviteUserView: function(e) {
        e.preventDefault();
        var el = this.$el;
        el.find('.js-setting-response').html(new App.InviteUserView({
            model: this.model
        }).el);
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
        this.model.labels.setSortField('name', 'asc');
        this.model.labels.sort();
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
    showLabels: function() {
        $('.js-side-bar-' + this.model.id).addClass('side-bar-large');
        var el = this.$el;
        this.model.labels.setSortField('name', 'asc');
        this.model.labels.sort();
        el.find('.js-setting-response').html(new App.BoardLabelsView({
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
        $(e.target).parents('.js-setting-response').parent().removeClass('open');
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
        $('#switch-board-view').addClass('col-xs-12');
        $('#switch-board-view').attr("id", "listview_table");
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
        $('div.js-board-view-' + self.model.id).html(new App.SwitchToListView({
            model: self.model
        }).el);
        var is_card_empty = true;
        var board_view = $('.js-card-list-view-' + self.model.attributes.id);
        var lists = self.model.lists;
        var list_length = lists.models.length;
        for (var list_i = 0; list_i < list_length; list_i++) {
            var list = lists.models[list_i];
            if (_.isUndefined(list.get('is_new')) && list.get('is_archived') === 0) {
                if (sort_by !== null && sort_by !== null) {
                    self.model.cards.sortByColumn(sort_by, sort_direction);
                } else {
                    self.model.cards.sortByColumn('position');
                }
                var filtered_cards = self.model.cards.where({
                    list_id: list.attributes.id,
                    is_archived: 0
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
                    card.labels.setSortField('name', 'asc');
                    card.labels.sort();
                    card.cards.add(self.model.cards, {
                        silent: true
                    });
                    card.list = list;
                    card.board_activities.add(self.model.activities, {
                        silent: true
                    });
                    card.users.setSortField('username', 'asc');
                    card.users.sort();
                    var view = new App.CardView({
                        tagName: 'tr',
                        className: 'card-list-view js-show-modal-card-view cur txt-aligns',
                        id: 'js-card-' + card.attributes.id,
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
     * switchCalendarView()
     * swith to the calendar view
     * @param e
     * @type Object(DOM event)
     *
     */
    switchCalendarView: function() {
        var self = this;
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
        $('div.js-board-view-' + this.model.id).html('');
        $('div.js-board-view-' + this.model.id).fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            selectable: true,
            selectHelper: true,
            editable: false,
            ignoreTimezone: false,
            aspectRatio: 3.35,
            eventRender: function(event, element) {
                var content = '';
                element.addClass('js-show-modal-card-view');
                element.attr('id', 'js-card-' + event.id);
                var card = self.model.cards.findWhere({
                    id: event.id
                });
                if (card.get('is_archived') === 1) {
                    element.addClass('card-archived');
                    element.find('.fc-event-skin').addClass('card-archived');
                }
                if (card.get('due_date') !== null) {
                    var today = new Date();
                    card_due_date = card.get('due_date').split('T');
                    var due_date = new Date(card_due_date[0]);
                    var diff = Math.floor(due_date.getTime() - today.getTime());
                    var day = 1000 * 60 * 60 * 24;
                    var days = Math.floor(diff / day);
                    if (days < -1) {
                        element.addClass('label-danger');
                        element.find('.fc-event-skin').addClass('label-danger');
                    } else if (days == -1) {
                        element.addClass('label-present');
                        element.find('.fc-event-skin').addClass('label-present');
                    } else if (days > -1) {
                        element.addClass('label-future');
                        element.find('.fc-event-skin').addClass('label-future');
                    }
                }
                content += '<ul class="unstyled hide js-card-labels">';
                var filtered_labels = card.labels.where({
                    card_id: event.id
                });
                var labels = new App.CardLabelCollection();
                labels.add(filtered_labels);
                labels.each(function(label) {
                    if (_.escape(label.attributes.name) !== "") {
                        content += '<li class="' + _.escape(label.attributes.name) + '">' + _.escape(label.attributes.name) + '</li>';
                    }
                });
                content += '</ul>';
                content += '<ul class="unstyled js-card-users hide">';
                card.users.each(function(user) {
                    content += '<li>user-filter-' + user.get('user_id') + '</li>';
                });
                content += '</ul>';
                content += '<ul class="unstyled js-card-due hide">';
                content += self.getDue(card.get('due_date'));
                content += '</ul>';
                element.append(content);
            },
            eventMouseover: function(calEvent, jsEvent, view) {
                var target = $(jsEvent.currentTarget);
                if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
                    if ($.inArray('r_custom_field', APPS.enabled_apps) !== -1) {
                        $.ajax({
                            url: api_url + 'cards/' + calEvent.id + '/cards_custom_fields.json?token=' + authuser.access_token,
                            cache: false,
                            type: 'GET',
                            success: function(response) {
                                if (!_.isEmpty(response.response) && !_.isUndefined(response.response) && response.response.length !== 0) {
                                    $(target).data('toggle', 'tooltip');
                                    $(target).data('container', 'body');
                                    $(target).data('placement', 'top');
                                    $(target).data('html', 'true');
                                    var card_customfield_value = '';
                                    _.each(response.response, function(customfield, key) {
                                        if (customfield) {
                                            if (customfield.type === 'date') {
                                                card_customfield_value += customfield.label + ' : ' + dateFormat(customfield.value, "mediumDate");
                                            } else if (customfield.type === 'time') {
                                                var field_time = customfield.value.split(':');
                                                var time_noon = '';
                                                if (field_time[0] <= 12) {
                                                    time_noon = 'AM';
                                                } else {
                                                    time_noon = 'PM';
                                                    field_time[0] = field_time[0] - 12;
                                                }
                                                card_customfield_value += customfield.label + ' : ' + field_time[0] + ':' + field_time[1] + ' ' + time_noon;
                                            } else if (customfield.type === 'datetime') {
                                                if (customfield.value.indexOf('T') > -1) {
                                                    var custom_field_val;
                                                    custom_field_val = customfield.value.replace('T', ' ');
                                                    var date = custom_field_val.split(' ');
                                                    custom_field_val = date['0'];
                                                    custom_field_val = dateFormat(custom_field_val, "mediumDate");
                                                    if (!_.isEmpty(date[1])) {
                                                        hours_mins = date[1].split(':');
                                                        var noon = '';
                                                        if (hours_mins[0] <= 12) {
                                                            noon = 'AM';
                                                        } else {
                                                            noon = 'PM';
                                                            hours_mins[0] = hours_mins[0] - 12;
                                                        }
                                                        hours_mins = hours_mins[0] + ':' + hours_mins[1] + ' ' + noon;
                                                    }
                                                    card_customfield_value += customfield.label + ' : ' + custom_field_val + ' at ' + hours_mins;
                                                }
                                            } else {
                                                card_customfield_value += customfield.label + ' : ' + customfield.value;
                                            }
                                            if (key + 1 !== response.response.length) {
                                                card_customfield_value += '<br/> ';
                                            }
                                        }
                                    });
                                    $(target).prop('title', card_customfield_value);
                                    $(target).data('original-title', card_customfield_value);
                                    $(target).tooltip();
                                }
                            }
                        });
                    }
                }
            }
        });
        if (!_.isEmpty(this.model.cards)) {
            $('div.js-board-view-' + this.model.id).fullCalendar('addEventSource', this.model.cards.invoke('pick', ['id', 'title', 'start']));
        }
        return false;
    },
    /**
     * getDue()
     * show card due date
     * @param card_due_date
     * @type String
     * @return message
     * @type String
     *
     */
    getDue: function(card_due_date) {
        if (card_due_date === null) {
            return '';
        }
        var today = new Date();
        var last_day = new Date(today.getFullYear(), today.getMonth() + 1, 0);
        var next_month_last_day = new Date(today.getFullYear(), today.getMonth() + 2, 0);
        var due_date = new Date(card_due_date);
        var diff = Math.floor(due_date.getTime() - today.getTime());

        var day = 1000 * 60 * 60 * 24;
        var days = Math.floor(diff / day);
        var months = Math.floor((days + (today.getDate() + 1)) / next_month_last_day.getDate());

        var years = Math.floor(months / 12);
        var week = days - (6 - (today.getDay()));
        var due_content = '';
        var message = 'feature';
        due_content = '';
        if (years > 0) {
            message = 'year';
            due_content += '<li>year</li>';
        }
        if (days >= 0 && days <= 7) {
            message = 'week';
            due_content += '<li>week</li>';
        }
        if (days >= 0 && days <= 30) {
            message = 'month';
            due_content += '<li>month</li>';
        }
        if (days === 0) {
            message = 'day';
            due_content += '<li>day</li>';
        }
        if (years < 0 || months < 0 || days <= -1) {
            message = 'overdue';
            due_content += '<li>overdue</li>';
        }
        return due_content;
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
            return parseInt(normal_user.attributes.board_user_role_id) === 1;
        });
        this.model.admin_board_users = admins;
        var normal_users = this.model.board_users.filter(function(normal_user) {
            return parseInt(normal_user.attributes.board_user_role_id) != 1;
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
        }).el);
        var self = this;
        _(function() {
            if (self.model !== null && !_.isUndefined(self.model) && !_.isEmpty(self.model)) {
                $('body').trigger('boardActionRendered', [self.model.id, self.model]);
            }
        }).defer();
        this.renderBoardUsers();
        this.clearAll();
        return false;
    },
    renderBoardUsers: function() {
        $('.js-get-board-member-lists-response').html('');
        var self = this;
        this.model.board_users.sortBy('board_user_role_id');
        this.model.board_users.each(function(board_user) {
            board_user.board_user_roles = self.model.board_user_roles;
            board_user.board_users_count = self.model.board_users.length;
            self.$('.js-get-board-member-lists-response').append(new App.BoardUsersView({
                model: board_user,
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
        if (this.start !== 0) {
            this.start = 0;
        }
        if (this.page !== 1) {
            this.page = 1;
        }
        var self = this;
        if (this.$el.find('.js-load-more-archived-cards').hasClass('show')) {
            this.$el.find('.js-load-more-archived-cards').removeClass('show').addClass('hide');
        } else {
            this.$el.find('.js-load-more-archived-cards').addClass('hide');
        }
        if (this.$el.find('.js-load-more-archived-lists').hasClass('hide')) {
            this.$el.find('.js-load-more-archived-lists').removeClass('hide').addClass('show');
        }
        if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.acl_links.where({
                slug: 'view_archived_lists',
                board_user_role_id: parseInt(this.model.board_user_role_id)
            })))) {
            var el = this.$el;
            var filtered_lists = this.model.lists.where({
                is_archived: 1
            });
            if (!_.isEmpty(this.listq)) {
                if (self.listpage_filter == 1) {
                    el.find('.js-archived-items-container').html(new App.ArchivedListsView({
                        model: this.model
                    }).el);
                }
                filtered_lists = this.model.lists.filter(function(model) {
                    return ~model.get('name').toUpperCase().indexOf(self.listq.toUpperCase());
                });
                if (!_.isEmpty(filtered_lists)) {
                    $('.js-delete-all-archived-lists-confirm').removeClass('hide');
                    _.each(filtered_lists, function(list, key) {
                        count = self.listpage_filter * 9;
                        if (key === self.liststart_filter) {
                            if (count > (self.liststart_filter)) {
                                self.liststart_filter++;
                                list.board = self.model;
                                el.find('.js-archived-lists-container').append(new App.ArchivedListView({
                                    model: list
                                }).el);
                            }
                            if (filtered_lists.length == self.liststart_filter) {
                                self.$el.find('.js-load-more-archived-lists').removeClass('show').addClass('hide');
                            }
                        }
                    });
                } else {
                    $('.js-delete-all-archived-lists-confirm').addClass('hide');
                    this.$el.find('.js-load-more-archived-lists').removeClass('show').addClass('hide');
                    el.find('.js-archived-lists-container').append(new App.ArchivedListView({
                        model: null
                    }).el);
                }
            } else {
                if (self.listpage == 1) {
                    el.find('.js-archived-items-container').html(new App.ArchivedListsView({
                        model: this.model
                    }).el);
                }
                if (!_.isEmpty(filtered_lists)) {
                    _.each(filtered_lists, function(list, key) {
                        count = self.listpage * 9;
                        if (key === self.liststart) {
                            if (count > (self.liststart)) {
                                self.liststart++;
                                list.board = self.model;
                                el.find('.js-archived-lists-container').append(new App.ArchivedListView({
                                    model: list
                                }).el);
                            }
                            if (filtered_lists.length == self.liststart) {
                                self.$el.find('.js-load-more-archived-lists').removeClass('show').addClass('hide');
                            }
                        }
                    });
                } else {
                    this.$el.find('.js-load-more-archived-lists').removeClass('show').addClass('hide');
                    $('.js-delete-all-archived-lists-confirm').addClass('hide');
                    el.find('.js-archived-lists-container').append(new App.ArchivedListView({
                        model: null
                    }).el);
                }
            }
        }
        return false;
    },
    /**
     * loadMoreArchivedListLists()
     * display the archived cards list
     * @return false
     *
     */
    loadMoreArchivedListLists: function(e) {
        e.preventDefault();
        if (!_.isEmpty(this.listq)) {
            this.listpage_filter++;
            this.showArchivedListLists();
        } else {
            this.listpage++;
            this.showArchivedListLists();
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
        var self = this;
        self.liststart_filter = 0;
        if (!_.isUndefined(authuser.user) && (authuser.user.role_id == 1 || !_.isEmpty(this.model.acl_links.where({
                slug: 'view_archived_lists',
                board_user_role_id: parseInt(this.model.board_user_role_id)
            })))) {
            var el = this.$el;
            this.listq = $(e.currentTarget).val();
            var filtered_lists = this.model.lists.where({
                is_archived: 1
            });
            if (!_.isEmpty(this.listq)) {
                filtered_lists = filtered_lists.filter(function(model) {
                    return ~model.get('name').toUpperCase().indexOf(self.listq.toUpperCase());
                });
            }
            el.find('.js-archived-lists-container').html('');
            if (!_.isEmpty(filtered_lists)) {
                _.each(filtered_lists, function(list, key) {
                    count = self.listpage_filter * 9;
                    if (key === self.liststart_filter) {
                        if (count >= (self.liststart_filter)) {
                            self.liststart_filter++;
                            el.find('.js-archived-lists-container').append(new App.ArchivedListView({
                                model: list
                            }).el);
                        }
                        if (filtered_lists.length == self.liststart_filter) {
                            self.$el.find('.js-load-more-archived-lists').removeClass('show').addClass('hide');
                        }
                    }
                });
            } else {
                el.find('.js-archived-lists-container').append(new App.ArchivedListView({
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
        }).set('is_archived', 0);
        var find_card = this.model.cards.findWhere({
            id: parseInt(card_id)
        });
        this.model.cards.get(find_card.id).set('is_archived', 0);
        var list = App.boards.get(find_card.attributes.board_id).lists.get(find_card.attributes.list_id);
        if (!_.isUndefined(list)) {
            list.set('card_count', list.attributes.card_count + 1, {
                silent: true
            });
        }
        var currentBoardList = App.current_board.lists.get(find_card.attributes.list_id);
        if (!_.isUndefined(currentBoardList)) {
            currentBoardList.set('card_count', currentBoardList.attributes.card_count + 1, {
                silent: true
            });
            if (parseInt(currentBoardList.attributes.card_count) === 1) {
                $('#js-card-listing-' + find_card.attributes.list_id).html(function(i, h) {
                    return h.replace(/&nbsp;/g, '');
                });
            }
        }
        if (!_.isUndefined(APPS) && APPS !== null && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null && $.inArray('r_wip_limit', APPS.enabled_apps) !== -1) {
            if (list !== null && !_.isUndefined(list) && !_.isEmpty(list)) {
                $('body').trigger('cardAddRendered', [list.id, list]);
            }
        }
        $(e.currentTarget).parents('li').remove();
        var card = new App.Card();
        card.set('id', card_id);
        card.set('is_archived', 0);
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
                    $('.js-board-member-search-response').html('<span class="small">' + i18next.t('No %s available.', {
                        postProcess: 'sprintf',
                        sprintf: [i18next.t('users')]
                    }) + '</span>');
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
        App.boards.get(this.model.attributes.id).set(data, {
            silent: true
        });
        board.set(data);
        board.set('id', this.model.id);
        board.url = api_url + 'boards/' + this.model.id + '.json';
        board.save(data, {
            patch: true
        });
        $('.js-rename-board').html('<strong>' + _.escape(data.name) + '</strong>');
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

        var organizations = auth_user_organizations;
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
            model: auth_user_organizations,
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
        App.boards.get(this.model.id).set('background_picture_url', '', {
            silent: true
        });
        App.boards.get(this.model.id).set('custom_background_url', '', {
            silent: true
        });
        App.boards.get(this.model.id).set('background_pattern_url', '', {
            silent: true
        });
        App.boards.get(this.model.id).set('background_color', color, {
            silent: true
        });
        data = {
            background_color: color,
            background_picture_url: null,
            custom_background_url: null,
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
        }).set('is_archived', 0);
        var find_list = this.model.lists.findWhere({
            id: parseInt(list_id)
        });
        this.model.lists.get(find_list.id).set('is_archived', 0);
        App.boards.get(find_list.attributes.board_id).lists.get(find_list.id).set('is_archived', 0);
        $(e.currentTarget).parents('li').remove();
        var list = new App.List();
        list.set('id', list_id);
        list.set('is_archived', 0);
        list.url = api_url + 'boards/' + this.model.attributes.id + '/lists/' + list_id + '.json';
        self.model.attributes.lists.forEach(function(list) {
            if (list.id === parseInt(list_id)) {
                list.is_archived = 0;
            }
        });
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
                'is_show_image_front_of_card': 0
            };
            $('div.js-card-attachment-image').addClass('hide');
            $('.js-AdditionalSettings-enabled').addClass('hide');
            $('.js-AdditionalSettings-enable').removeClass('hide');
            this.model.set('is_show_image_front_of_card', 0);
        } else {
            data = {
                'is_show_image_front_of_card': 1
            };
            $('div.js-card-attachment-image').removeClass('hide');
            $('.js-AdditionalSettings-enabled').removeClass('hide');
            $('.js-AdditionalSettings-enable').addClass('hide');
            this.model.set('is_show_image_front_of_card', 1);
        }
        var board = new App.Board();
        board.url = api_url + 'boards/' + this.model.attributes.id + '.json';
        board.set('id', this.model.attributes.id);
        board.save(data);
        return false;
    },
    /**
     * toggleBoardNotification()
     * toggle thr label filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    toggleBoardNotification: function(e) {
        var target = $(e.currentTarget);
        if (target.hasClass('js-auto_subscribe_on_board-enabled')) {
            data = {
                'auto_subscribe_on_board': false
            };
            $('.js-auto_subscribe_on_board-enabled').addClass('hide');
            $('.js-auto_subscribe_on_board-enable').removeClass('hide');
            this.model.set('auto_subscribe_on_board', false);
        } else {
            data = {
                'auto_subscribe_on_board': true
            };
            $('.js-auto_subscribe_on_board-enabled').removeClass('hide');
            $('.js-auto_subscribe_on_board-enable').addClass('hide');
            this.model.set('auto_subscribe_on_board', true);
        }
        var board = new App.Board();
        board.url = api_url + 'boards/' + this.model.attributes.id + '.json';
        board.set('id', this.model.attributes.id);
        board.save(data);
        return false;
    },
    /**
     * toggleCardNotification()
     * toggle thr label filter list
     * @param e
     * @type Object(DOM event)
     *
     */
    toggleCardNotification: function(e) {
        var target = $(e.currentTarget);
        if (target.hasClass('js-auto_subscribe_on_card-enabled')) {
            data = {
                'auto_subscribe_on_card': false
            };
            $('div.js-card-attachment-image').addClass('hide');
            $('.js-auto_subscribe_on_card-enabled').addClass('hide');
            $('.js-auto_subscribe_on_card-enable').removeClass('hide');
            this.model.set('auto_subscribe_on_card', false);
        } else {
            data = {
                'auto_subscribe_on_card': true
            };
            $('div.js-card-attachment-image').removeClass('hide');
            $('.js-auto_subscribe_on_card-enabled').removeClass('hide');
            $('.js-auto_subscribe_on_card-enable').addClass('hide');
            this.model.set('auto_subscribe_on_card', true);
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
        if (target.parent().hasClass('js-filter-conjunction')) {
            if (target.attr('id') == 'js-mode-or') {
                if (!$(target).hasClass('selected')) {
                    $(target).addClass('selected');
                }
                if ($('li#js-mode-and').hasClass('selected')) {
                    $('li#js-mode-and').removeClass('selected');
                }
            }
            if (target.attr('id') == 'js-mode-and') {
                if (!$(target).hasClass('selected')) {
                    $(target).addClass('selected');
                }
                if ($('li#js-mode-or').hasClass('selected')) {
                    $('li#js-mode-or').removeClass('selected');
                }
            }
        } else {
            target.toggleClass('selected', !target.hasClass('selected'));
        }
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
        this.$el.find('.js-clear-filter-btn').removeClass('hide').addClass('show');
        var filter_label_arr = [],
            filter_user_arr = [],
            filter_color_arr = [],
            filter_data = [],
            label_filter = [],
            user_filter = [],
            due_filter = [],
            filter_due_arr = [];
        var filter_mode;
        $('i.js-filter-icon').remove();
        $('.js-show-modal-card-view').show();
        var current_param = Backbone.history.fragment.split('?');
        var current_url = current_param[0].split('/');
        var filter = 'grid';
        if (current_url.length === 3 && current_url[2] == 'list') {
            filter = 'list';
        } else if (current_url.length === 3 && current_url[2] == 'gantt') {
            filter = 'gantt';
        } else if (current_url.length === 3 && current_url[1] == 'board') {
            current_param[0] = current_url[1] + '/' + current_url[2];
        }
        var filter_query = '';
        $('li.selected > div.js-label', $('ul.js-board-labels')).each(function() {
            filter_label_arr.push($(this).html());
            filter_query += 'label:' + $(this).html() + ',';
            if ($(this).next('i').length === 0) {
                $(this).after('<i class="icon-ok js-filter-icon cur pull-right"></i>');
            }
        });
        $('li.selected > div.media > span.navbar-btn > span.js-user', $('ul.js-board-users')).each(function() {
            filter_user_arr.push($(this).parent().data('user'));
            filter_query += '@' + $(this).parent().data('user') + ',';
            if ($(this).next('i').length === 0) {
                $(this).parent().parent().append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
            }
        });
        $('li.selected', $('ul.js-board-colors')).each(function() {
            filter_color_arr.push($(this).data('color'));
            filter_query += 'color:' + $(this).data('color') + ',';
            if ($(this).next('i').length === 0) {
                $(this).prepend('<i class="icon-ok js-filter-icon cur pull-right card-color"></i>');
            }
        });
        $('li.selected > div.media > span.js-due', $('ul.js-board-dues')).each(function() {
            filter_due_arr.push($(this).html());
            filter_query += 'due:' + $(this).html() + ',';
            if ($(this).next('i').length === 0) {
                $(this).parent().parent().append('<i class="icon-ok js-filter-icon cur pull-right"></i>');
            }
        });
        $('li.selected > div.media > span.js-filter', $('ul.js-filter-conjunction')).each(function() {
            if ($(this).html() === 'or') {
                if ($('li#js-mode-and > i.js-filter_mode-icon').length === 1) {
                    $('li#js-mode-and > i.js-filter_mode-icon').remove();
                }
                if ($('li#js-mode-or > i.js-filter_mode-icon').length === 0) {
                    $('li#js-mode-or').append('<i class="icon-ok js-filter_mode-icon cur pull-right"></i>');
                }
            }
            if ($(this).html() === 'and') {
                filter_mode = 'and';
                if (filter_query) {
                    filter_query += 'mode:' + $(this).html() + ',';
                }
                if ($('li#js-mode-or > i.js-filter_mode-icon').length === 1) {
                    $('li#js-mode-or > i.js-filter_mode-icon').remove();
                }
                if ($('li#js-mode-and > i.js-filter_mode-icon').length === 0) {
                    $('li#js-mode-and').append('<i class="icon-ok js-filter_mode-icon cur pull-right"></i>');
                }
            }
        });
        var show_label_arr = [],
            result_label_arr = [];
        if (!_.isEmpty(filter_label_arr)) {
            $('ul.js-card-labels li').filter(function(index) {
                index = $.inArray($(this).text(), filter_label_arr);
                if (index !== -1) {
                    if (_.isUndefined(show_label_arr[index])) {
                        show_label_arr[index] = [];
                    }
                    if (filter == 'list') {
                        show_label_arr[index].push($(this).parent().parent().attr('id'));
                        /*show_label_arr[index].push($(this).parent().parent().find('div').attr('id'));*/
                    } else {
                        show_label_arr[index].push($(this).parent().parent().attr('id'));
                    }
                }
            });
            if (filter_label_arr.length != show_label_arr.length) {
                show_label_arr = [];
            }
        }
        if (!_.isEmpty(filter_mode)) {
            if (filter_mode === 'and') {
                if (!_.isEmpty(show_label_arr)) {
                    result_label_arr = show_label_arr.shift().filter(function(v) {
                        return show_label_arr.every(function(a) {
                            return a.indexOf(v) !== -1;
                        });
                    });
                }
            }
        } else if (!_.isEmpty(show_label_arr)) {
            result_label_arr = _.union.apply(_, show_label_arr);
        }
        var show_color_arr = [],
            result_color_arr = [];
        if (!_.isEmpty(filter_color_arr)) {
            $('ul.js-card-colors li').filter(function(index) {
                index = $.inArray($(this).text(), filter_color_arr);
                if (index !== -1) {
                    if (_.isUndefined(show_color_arr[index])) {
                        show_color_arr[index] = [];
                    }
                    if (filter == 'list') {
                        show_color_arr[index].push($(this).parent().parent().attr('id'));
                    } else {
                        show_color_arr[index].push($(this).parent().parent().attr('id'));
                    }
                }
            });
        }
        if (!_.isEmpty(filter_mode)) {
            if (filter_mode === 'and') {
                if (!_.isEmpty(show_color_arr)) {
                    result_color_arr = show_color_arr.shift().filter(function(v) {
                        return show_color_arr.every(function(a) {
                            return a.indexOf(v) !== -1;
                        });
                    });
                }
            }
        } else if (!_.isEmpty(show_color_arr)) {
            result_color_arr = _.union.apply(_, show_color_arr);
        }
        var show_user_arr = [],
            result_user_arr = [];
        if (!_.isEmpty(filter_user_arr)) {
            $('ul.js-card-users li').filter(function(index) {
                index = $.inArray($(this).text(), filter_user_arr);
                if (index !== -1) {
                    if (_.isUndefined(show_user_arr[index])) {
                        show_user_arr[index] = [];
                    }
                    if (filter == 'list') {
                        /*show_user_arr[index].push($(this).parent().parent().find('div').attr('id'));*/
                        show_user_arr[index].push($(this).parent().parent().attr('id'));
                    } else {
                        show_user_arr[index].push($(this).parent().parent().attr('id'));
                    }
                }
            });
            if (filter_user_arr.length != show_user_arr.length) {
                show_user_arr = [];
            }
        }
        if (!_.isEmpty(filter_mode)) {
            if (filter_mode === 'and') {
                if (!_.isEmpty(show_user_arr)) {
                    result_user_arr = show_user_arr.shift().filter(function(v) {
                        return show_user_arr.every(function(a) {
                            return a.indexOf(v) !== -1;
                        });
                    });
                }
            }
        } else if (!_.isEmpty(show_user_arr)) {
            result_user_arr = _.union.apply(_, show_user_arr);
        }
        var show_due_arr = [],
            result_due_arr = [];
        if (!_.isEmpty(filter_due_arr)) {
            $('ul.js-card-due li').filter(function(index) {
                index = $.inArray($(this).text(), filter_due_arr);
                if (index !== -1) {
                    if (_.isUndefined(show_due_arr[index])) {
                        show_due_arr[index] = [];
                    }
                    if (filter == 'list') {
                        /*show_due_arr[index].push($(this).parent().parent().find('div').attr('id'));*/
                        show_due_arr[index].push($(this).parent().parent().attr('id'));
                    } else {
                        show_due_arr[index].push($(this).parent().parent().attr('id'));
                    }
                }
            });
            if (filter_due_arr.length != show_due_arr.length) {
                show_due_arr = [];
            }
        }
        if (!_.isEmpty(show_due_arr)) {
            var due_arr = [];
            $.each(show_due_arr, function(index, value) {
                if (value !== undefined) {
                    due_arr.push(value);
                }
            });
            result_due_arr = due_arr.shift().filter(function(v) {
                return due_arr.every(function(a) {
                    return a.indexOf(v) !== -1;
                });
            });
        }
        var arrays = [];
        if (!_.isEmpty(filter_label_arr)) {
            arrays.push(result_label_arr);
        }
        if (!_.isEmpty(filter_user_arr)) {
            arrays.push(result_user_arr);
        }
        if (!_.isEmpty(filter_due_arr)) {
            arrays.push(result_due_arr);
        }
        if (!_.isEmpty(filter_color_arr)) {
            arrays.push(result_color_arr);
        }
        if (!_.isEmpty(arrays)) {
            var result = arrays.shift().filter(function(v) {
                return arrays.every(function(a) {
                    return a.indexOf(v) !== -1;
                });
            });
            var show_card_list = '',
                hide_card_list = '';
            for (i = 0; i < result.length; i++) {
                show_card_list += '#' + result[i] + ', ';
                hide_card_list += ':not(#' + result[i] + ')';
            }
            show_card_list = show_card_list.substring(0, show_card_list.lastIndexOf(', '));
            if (!_.isUndefined(show_card_list) && _.isEmpty(show_card_list)) {
                $('#js-empty-filter-cards').removeClass('hide');
            } else if (!$('#js-empty-filter-cards').hasClass('hide')) {
                $('#js-empty-filter-cards').addClass('hide');
            }
            if (filter == 'gantt') {
                gantt_card_ids = [];
                _.each(show_card_list.replace(/#js-card-/g, '').split(','), function(card_id) {
                    gantt_card_ids.push(parseInt(card_id));
                });
                /* this.ganttView(gantt_card_ids, true); */
            } else {
                $(show_card_list).show();
                $('.js-show-modal-card-view' + hide_card_list).hide();
            }
        } else if (filter_label_arr.length || filter_user_arr.length || filter_due_arr.length || filter_color_arr.length) {
            $('.js-show-modal-card-view').hide();
        } else if (filter == 'gantt' && _.isEmpty(filter_label_arr) && _.isEmpty(filter_user_arr) && _.isEmpty(filter_due_arr) && _.isEmpty(filter_color_arr)) {
            gantt_card_ids = [];
            /* this.ganttView(gantt_card_ids, false); */
        }
        if (filter_query) {
            if ($('.js-clear-all').hasClass('text-muted')) {
                $('.js-clear-all').removeClass('text-muted');
            }
            filter_query = '?filter=' + filter_query.slice(0, -1);
            app.navigate('#/' + current_param[0] + filter_query, {
                trigger: true,
                trigger_function: false,
                replace: true
            });
        } else {
            this.$el.find('.js-clear-filter-btn').removeClass('show').addClass('hide');
            app.navigate('#/' + current_param[0], {
                trigger: true,
                trigger_function: false,
                replace: true
            });
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
                if (response.error) {
                    self.flash('danger', i18next.t('File extension not supported. It supports only jpg, png, bmp and gif.'));
                } else {
                    image = response.background_picture_url + '?' + Date.now();
                    self.model.set('background_color', '');
                    self.model.set('background_pattern_url', '');
                    self.model.set('custom_background_url', '');
                    self.model.set('background_picture_url', '');
                    self.model.set({
                        background_picture_url: image
                    });
                    App.boards.get(self.model.id).set('custom_background_url', '', {
                        silent: true
                    });
                    App.boards.get(self.model.id).set('background_pattern_url', '', {
                        silent: true
                    });
                    App.boards.get(self.model.id).set('background_color', '', {
                        silent: true
                    });
                    App.boards.get(self.model.id).set('background_picture_url', image, {
                        silent: true
                    });

                }
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
     * clearAll()
     * Clear the filters
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    clearAll: function() {
        $('.js-board-dues, .js-board-users, .js-board-labels').find('.js-filter-icon').remove();
        if ($('li#js-mode-and > i.js-filter_mode-icon').length === 1) {
            $('#js-mode-and').find('.js-filter_mode-icon').remove();
        }
        if ($('li#js-mode-or > i.js-filter_mode-icon').length === 0) {
            $('li#js-mode-or').append('<i class="icon-ok js-filter_mode-icon cur pull-right"></i>');
        }
        $('.js-board-dues, .js-board-users, .js-board-labels').children().removeClass('selected');
        if ($('#js-mode-and').hasClass('selected')) {
            $('#js-mode-and').removeClass('selected');
        }
        $('.js-clear-all').addClass('text-muted');
        if (!$('#js-empty-filter-cards').hasClass('hide')) {
            $('#js-empty-filter-cards').addClass('hide');
        }
        var current_param = Backbone.history.fragment.split('?');
        var current_url = current_param[0].split('/');
        var filter = '';
        if (current_url.length === 3 && current_url[2] == 'list') {
            filter = 'list';
        } else if (current_url.length === 3 && current_url[2] == 'gantt') {
            filter = 'gantt';
        }
        if (!_.isEmpty(filter)) {
            filter = '/' + filter;
        }
        $('.js-show-modal-card-view').show();
        app.navigate('#/board/' + this.model.attributes.id + filter, {
            trigger: false,
            trigger_function: false,
            replace: true
        });
        this.$el.find('.js-clear-filter-btn').removeClass('show').addClass('hide');
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
        var content = '<i class="icon-lock"></i>' + i18next.t('Private');
        $('#js-board-add-organization').html('');
        if (name == 'org') {
            value = 1;
            content = '<i class="icon-group"></i>' + i18next.t('Organization');
            $('#js-change-visible-content').html(content);
            this.showBoardAddeOrganizationForm(e);
        } else if (name == 'public') {
            content = '<i class="icon-circle"></i>' + i18next.t('Public');
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
        organizations = auth_user_organizations;
        if (auth_user_organizations !== null && _.isUndefined(auth_user_organizations.models)) {
            organizations.add(JSON.parse(auth_user_organizations));
        }
        auth_user_organizations = organizations;
        $('#js-board-add-organization').html(new App.BoardAddOrganizationFormView({
            model: auth_user_organizations
        }).el);
    },
    keyboardShowFilters: function(e) {
        $('.js-open-dropdown').trigger('click');
        $('.js-show-filters').trigger('click');
        return true;
    },
    keyboardOpenDropdown: function(e) {
        if ($('.js-setting-response').parents().hasClass("open")) {
            $('.js-setting-response').parents().removeClass("open");
        } else {
            $('.js-open-dropdown').trigger('click');
        }
        return false;
    },
    keyboardClearAll: function(e) {
        $('.js-clear-all').trigger('click');
        return false;
    },
    keyboardToggleCardFilter: function(e) {
        $('.js-open-dropdown').trigger('click');
        $('.js-show-filters').trigger('click');
        $('.js-board-users').find(".js-user").each(function() {
            if ($(this).text() == 'user-filter-' + authuser.user.id) {
                $(this).parents('li.js-toggle-member-filter').trigger('click');
            }
        });
        return false;
    },
    keyboardUpNavigateCards: function(e) {
        if (!$('.js-board-list .js-board-list-cards .js-board-list-card').hasClass('active')) {
            $('.js-board-list .js-board-list-cards .js-board-list-card:eq(0)').addClass('active');
            $('.js-board-list .js-board-list-cards .active').parent().animate({
                scrollTop: $('.js-board-list .js-board-list-cards .active').parent().scrollTop() - 100
            }, 50);
            return;
        }
        var active_card = $('.js-board-list .js-board-list-cards .active');
        if ($(active_card).prev().length) {
            $(active_card).removeClass('active').prev().addClass('active');
            $('.js-board-list .js-board-list-cards .active').parent().animate({
                scrollTop: $('.js-board-list .js-board-list-cards .active').parent().scrollTop() - 100
            }, 50);
        }
    },
    keyboardDownNavigateCards: function(e) {
        if (!$('.js-board-list .js-board-list-cards .js-board-list-card').hasClass('active')) {
            $('.js-board-list .js-board-list-cards .js-board-list-card:eq(0)').addClass('active');
            $('.js-board-list .js-board-list-cards .active').parent().animate({
                scrollTop: $('.js-board-list .js-board-list-cards .active').parent().scrollTop() + 100
            }, 50);
            return;
        }
        var active_card = $('.js-board-list .js-board-list-cards .active');
        if ($(active_card).next().length) {
            $(active_card).removeClass('active').next().addClass('active');
            $('.js-board-list .js-board-list-cards .active').parent().animate({
                scrollTop: $('.js-board-list .js-board-list-cards .active').parent().scrollTop() + 100
            }, 50);
        }
    },
    keyboardLeftNavigateCards: function(e) {
        if (!$('.js-board-list .js-board-list-cards .js-board-list-card').hasClass('active')) {
            $('.js-board-list .js-board-list-cards .js-board-list-card:eq(0)').addClass('active');
            return;
        }
        var active_card = $('.js-board-list .js-board-list-cards .active');
        var active_card_position = $('.js-board-list .js-board-list-cards .active').index();
        var next_list_card = 0;
        var prev_list = $(active_card).parents('.js-board-list').prev();
        do {
            prev_list_card = prev_list.find('.js-board-list-card').length;
            if (prev_list_card === 0) {
                prev_list = prev_list.prev();
                if (!$(prev_list).length) {
                    break;
                }
            } else {
                $('#js-board-lists').animate({
                    scrollLeft: prev_list.find('.js-board-list-card').parent().parent().offset().left + $('#js-board-lists').scrollLeft()
                }, 'slow');
                if (active_card_position > (prev_list_card - 1)) {
                    $(active_card).removeClass('active');
                    $(prev_list).find('.js-board-list-card').eq(0).addClass('active');
                } else {
                    $(active_card).removeClass('active');
                    $(prev_list).find('.js-board-list-card').eq(active_card_position).addClass('active');
                }
                $('.js-board-list .js-board-list-cards .active').parent().animate({
                    scrollTop: 0
                }, 'slow');
                break;
            }
        } while (next_list_card === 0);
    },
    keyboardRightNavigateCards: function(e) {
        if (!$('.js-board-list .js-board-list-cards .js-board-list-card').hasClass('active')) {
            $('.js-board-list .js-board-list-cards .js-board-list-card:eq(0)').addClass('active');
            return;
        }
        var active_card = $('.js-board-list .js-board-list-cards .active');
        var active_card_position = $('.js-board-list .js-board-list-cards .active').index();
        var next_list_card = 0;
        var next_list = $(active_card).parents('.js-board-list').next();
        do {
            next_list_card = next_list.find('.js-board-list-card').length;
            if (next_list_card === 0) {
                next_list = next_list.next();
                if (!$(next_list).length) {
                    break;
                }
            } else {
                $('#js-board-lists').animate({
                    scrollLeft: next_list.find('.js-board-list-card').parent().parent().offset().left + $('#js-board-lists').scrollLeft()
                }, 'slow');
                if (active_card_position > (next_list_card - 1)) {
                    $(active_card).removeClass('active');
                    $(next_list).find('.js-board-list-card').eq(0).addClass('active');
                } else {
                    $(active_card).removeClass('active');
                    $(next_list).find('.js-board-list-card').eq(active_card_position).addClass('active');
                }
                $('.js-board-list .js-board-list-cards .active').parent().animate({
                    scrollTop: 0
                }, 'slow');
            }
        } while (next_list_card === 0);
    },
    keyboardShowCardModal: function(e) {
        if ($('.js-board-list .js-board-list-cards .js-board-list-card').hasClass('active')) {
            var active_card = $('.js-board-list-card.active').attr('id');
            $('#' + active_card).trigger('click');
        }
    },
    keyboardShowPrevCardModal: function(e) {
        var active_card = $('.js-board-list .js-board-list-cards .active');
        if ($(active_card).prev().length) {
            $('.action-close', $('.dockmodal.active')).trigger('click');
            $(active_card).removeClass('active').prev().addClass('active');
            var active_card_id = $('.js-board-list-card.active').attr('id');
            $('#' + active_card_id).trigger('click');
        }
    },
    keyboardShowNextCardModal: function(e) {
        var active_card = $('.js-board-list .js-board-list-cards .active');
        if ($(active_card).next().length) {
            $('.action-close', $('.dockmodal.active')).trigger('click');
            $(active_card).removeClass('active').next().addClass('active');
            var active_card_id = $('.js-board-list-card.active').attr('id');
            $('#' + active_card_id).trigger('click');
        }
    },
    /**
     * showChatListModal()
     * display the chat history in the list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showChatListModal: function(e) {
        var modalView = new App.ModalBoardView({
            model: this.model
        });
        modalView.show();
        return false;
    },
    /**
     * showChatHistoryModal()
     * display the chat history in the list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showChatHistoryModal: function(e) {
        var modalView = new App.ModalChatHistoryView({
            model: this.model
        });
        modalView.show();
        return false;
    },
});
