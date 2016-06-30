/**
/**
 * @fileOverview This file has functions related to board view. This view calling from application view.
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
 * Board View
 * @class BoardView
 * @constructor
 * @extends Backbone.View
 */
App.BoardView = Backbone.View.extend({
    tagName: 'section',
    className: 'clearfix',
    id: 'boards-view',
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        var self = this;
        this.authuser = authuser.user;
        if (_.isUndefined(window.sessionStorage.getItem('music_play'))) {
            window.sessionStorage.setItem('music_play', "1");
        }
        this.model.attachments.add(this.model.get('attachments'));
        _.bindAll(this, 'render', 'renderListsCollection', 'renderActivitiesCollection', 'setBoardBackground', 'populateChecklistItems');
        this.model.bind('change:name change:is_closed', this.render);
        this.model.bind('change:board_visibility', this.render);
        this.model.bind('change:background_color change:background_picture_url change:background_pattern_url', this.setBoardBackground);
        this.model.bind('change:music_content', this.musical);
        this.model.labels.bind('remove', this.renderListsCollection);
        this.model.lists.bind('add', this.renderListsCollection);
        this.model.lists.bind('change:name', this.renderListsCollection);
        this.model.lists.bind('change:position', this.renderListsCollection);
        this.model.lists.bind('change:is_archived', this.renderListsCollection, this);
        this.model.lists.bind('change:comment_count', this.renderListsCollection, this);
        this.model.activities.bind('add', this.renderActivitiesCollection);
        this.model.checklists.bind('add', this.populateChecklistItems);
        this.model.board_users.bind('add', this.render);
        this.model.board_users.bind('remove', this.render);
        this.model.board_users.bind('change', this.render);
        if (!_.isUndefined(App.music)) {
            App.music.inst = new Instrument();
        }
        if (this.model.attributes.music_content !== undefined && this.model.attributes.music_content !== "") {
            App.music.music_content = this.model.attributes.music_content;
            App.music.music_name = this.model.attributes.music_name;
        }
        this.populateLists();
        this.populateCards();
        this.populateChecklists();
        this.populateChecklistItems();
        this.populateLabels();
        this.populateActivities();
        this.populateUsers();
        this.populateCustomAttachments();
        this.populateAttachments();
        this.populateSubscribers();
        this.populateStars();
        this.populateAclLinks();
        if (!_.isUndefined(authuser.user)) {
            var board_user_role_id = this.model.board_users.findWhere({
                user_id: parseInt(authuser.user.id)
            });
            if (!_.isEmpty(board_user_role_id)) {
                this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
            }
        }
        this.render();
    },
    // Resets this boards acl_links collection
    populateAclLinks: function() {
        var acl_links = this.model.get('acl_links') || [];
        this.model.acl_links.reset(acl_links, {
            silent: true
        });
    },
    // Resets this boards lists collection
    populateLists: function() {
        var lists = this.model.get('lists') || [];
        this.model.lists.reset(lists, {
            silent: true
        });
    },
    // Resets this boards activities collection
    populateActivities: function() {
        var activities = this.model.get('activities') || [];
        this.model.activities.reset(activities, {
            silent: true
        });
    },
    // Resets this boards users collection
    populateUsers: function() {
        var board_users = this.model.get('boards_users') || [];
        this.model.board_users.reset(board_users, {
            silent: true
        });
    },
    // Resets this boards custom attachments collection
    populateCustomAttachments: function() {
        var custom_attachments = this.model.get('custom_backgrounds') || [];
        this.model.custom_attachments.reset(custom_attachments, {
            silent: true
        });
    },
    // Resets this boards attachments collection
    populateAttachments: function() {
        var attachments = this.model.get('attachments') || [];
        this.model.attachments.reset(attachments, {
            silent: true
        });
    },
    // Resets this boards subscribers collection
    populateSubscribers: function() {
        var boards_subscribers = this.model.get('boards_subscribers') || [];
        this.model.board_subscribers.add(boards_subscribers, {
            silent: true
        });
    },
    // Resets this boards stars collection
    populateStars: function() {
        var boards_stars = this.model.get('boards_stars') || [];
        this.model.board_stars.add(boards_stars, {
            silent: true
        });
    },
    // Resets this boards cards collection
    populateCards: function() {
        var self = this;
        self.model.lists.each(function(list) {
            var cards = list.get('cards') || [];
            if (!_.isEmpty(cards)) {
                self.model.cards.add(cards, {
                    silent: true
                });
            }
        });
    },
    // Resets this checklists collection
    populateChecklists: function() {
        var self = this;
        self.model.cards.each(function(card) {
            var checklists = card.get('cards_checklists') || [];
            if (!_.isEmpty(checklists)) {
                self.model.checklists.add(checklists, {
                    silent: true
                });
            }
        });
    },
    // Resets this checklist items collection
    populateChecklistItems: function() {
        var self = this;
        self.model.checklists.each(function(checklist) {
            var checklist_itmes = checklist.get('checklists_items') || [];
            if (!_.isEmpty(checklist_itmes)) {
                self.model.checklist_items.add(checklist_itmes, {
                    silent: true
                });
            }
        });
    },
    // Resets this labels collection
    populateLabels: function() {
        var self = this;
        self.model.cards.each(function(card) {
            var labels = card.get('cards_labels') || [];
            if (!_.isEmpty(labels)) {
                $.each(labels, function(key, value) {
                    if (self.model.labels.where({
                            board_id: value.board_id,
                            card_id: value.card_id,
                            label_id: value.label_id,
                            list_id: value.list_id
                        }).length <= 0) {
                        var new_label = new App.Label();
                        new_label.set(value);
                        self.model.labels.push(new_label);
                    }
                });
            }
        });
    },
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-close-sub-popover': 'closeSubPopup',
        'click .js-board-visibility': 'showBoardVisibility',
        'click .js-subscribe-board': 'subcribeBoard',
        'click .js-star-board': 'starredBoard',
        'click .js-close-board': 'closeBoard',
        'submit #BoardReopenForm': 'reopenBoard',
        'click .js-change-visibility': 'showAllVisibility',
        'click .js-select': 'copyBoardVisibility',
        'click .js-hide-sidebar': 'hideSidebar',
        'click .js-show-sidebar-menu': 'showSidebarMenu',
        'click .js-hide-sidebar-menu': 'hideSidebarMenu',
        'click .js-show-board-member-permission-form': 'showBoardMemberPermissionForm',
        'click .js-edit-board-member-permission-to-admin': 'editBoardMemberPermissionToAdmin',
        'click .js-edit-board-member-permission-to-normal': 'editBoardMemberPermissionToNormal',
        'click #js-add-board-member': 'addBoardMember',
        'click .js-board-user-activity': 'showMemberActivities',
        'change .js-add-custom-background': 'addCustomBackground',
        'click .js-show-board-modal': 'showListModal',
        'click #js-select-google-sync-url': 'selectGoogleSyncUrl',
        'keyup .js-search-archived-cards': 'searchArchivedCards',
        'keyup .js-search-archived-lists': 'searchArchivedLists',
        'click .js-board-commenting-permissions': 'showCBoardCommentingPermissions',
        'click .js-select-commenting-permission': 'selectCommentingPermission',
        'click .js-show-board-member-remove-form': 'showBoardMemberRemoveForm',
        'click .js-show-add-list-form': 'showAddListForm',
        'click .js-hide-add-list-form': 'hideAddListForm',
        'submit form.js-add-list': 'addList',
        'click .js-syn-google-calendar': 'syncGoogleCalendar',
        'click .js-open-dropdown': 'openDropdown',
        'click .js-sync-google-dropdown': 'syncGoogleDropdown',
    },
    template: JST['templates/board'],
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
        $(e.currentTarget).addClass('open');
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
        target.parents('div.dropdown').removeClass('open');
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
        var parent = target.parents('.js-visibility-list-dropdown');
        var visibility = this.model.attributes.board_visibility;
        $('.js-visibility-list', parent).html(new App.ShowBoardVisibilityView({
            model: visibility
        }).el);
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
        var content = '<i class="icon-eye-close"></i>' + i18next.t('Unsubscribe');
        if (name == 'unsubscribe') {
            value = 'subscribe';
            content = '<i class="icon-eye-open"></i>' + i18next.t('Subscribe');
        }
        $(e.currentTarget).attr('name', value);
        $(e.currentTarget).attr('title', value);
        $(e.currentTarget).html(content);
        var boardSubscriber = new App.BoardSubscriber();
        if (!_.isEmpty(this.model.board_subscriber) && this.model.board_subscriber.attributes.id) {
            value = '';
            if ($('#inputBoardSubscribe').val() == 'false') {
                value = 'true';
                $('#inputBoardSubscribe').val(value);
            } else {
                value = 'false';
                $('#inputBoardSubscribe').val(value);
            }
            var data = $('form#BoardSubscribeForm').serializeObject();
            boardSubscriber.url = api_url + 'boards/' + this.model.board.board_id + '/board_subscribers/' + this.model.subscriber.attributes.id + '.json';
            boardSubscriber.set('id', this.model.subscriber.attributes.id);
            boardSubscriber.save(data, {
                success: function(model, response) {}
            });
        } else {
            var subscribe_data = {};
            var self = this;
            boardSubscriber.url = api_url + 'boards/' + this.model.id + '/board_subscribers.json';
            boardSubscriber.save(subscribe_data, {
                success: function(model, response) {
                    self.model.board_subscribers.add(response);
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
        $('.js-star-board').addClass('hide');
        $('.js-star-load').removeClass('hide');
        var name = $(e.currentTarget).attr('name');
        var value = 'unstar';
        var is_starred = 1;
        var content = '<i class="icon-star text-primary"></i>';
        if (name == 'unstar') {
            value = 'star';
            is_starred = 0;
            content = '<i class="icon-star-empty"></i>';
        }
        $(e.currentTarget).attr('name', value);
        $('.js-star-load').addClass('hide');
        $('.js-star-board').removeClass('hide');
        $(e.currentTarget).html(content);
        var boardStar = new App.BoardStar();
        if (!_.isEmpty(this.model.board_star) && this.model.board_star.attributes.id) {
            value = '';
            if ($('#inputBoardStar').val() == 'false') {
                value = 'true';
                is_starred = 1;
                $('#inputBoardStar').val(value);
            } else {
                value = 'false';
                is_starred = 0;
                $('#inputBoardStar').val(value);
            }
            var data = $('form#BoardStarForm').serializeObject();
            boardStar.url = api_url + 'boards/' + this.model.board.board_id + '/boards_stars/' + this.model.star.attributes.id + '.json';
            boardStar.set('id', this.model.star.attributes.id);
            boardStar.save(data, {
                success: function(model, response) {
                    App.boards.get(self.model.attributes.id).boards_stars.get(parseInt(response.id)).set('is_starred', is_starred);
                }
            });
        } else {
            var subscribe_data = {};
            var self = this;
            boardStar.url = api_url + 'boards/' + this.model.id + '/boards_stars.json';
            boardStar.set('board_id', this.model.attributes.id);
            boardStar.set('user_id', parseInt(authuser.user.id));
            boardStar.set('is_starred', is_starred);
            boardStar.save(subscribe_data, {
                success: function(model, response) {
                    boardStar.set('id', parseInt(response.id));
                    App.boards.get(self.model.attributes.id).boards_stars.reset(boardStar);
                    self.model.boards_stars.add(response);
                    self.footerView = new App.FooterView({
                        model: authuser,
                        board_id: self.model.attributes.id
                    }).renderStarredBoards();
                }
            });
        }
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
        App.boards.get(this.model.id).set('is_closed', 1);
        this.model.set('is_closed', 1);
        this.footerView = new App.FooterView({
            model: authuser,
            board_id: this.model.id
        }).renderClosedBoards();
        this.model.save({
            is_closed: 1
        }, {
            patch: true,
            success: function(model, response) {

            }
        });
        return false;
    },
    /**
     * reopenBoard()
     * reopen closed the board
     * @return false
     *
     */
    reopenBoard: function(e) {
        var data = $(e.target).serializeObject();
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('is_closed', 0);
        this.model.save({
            is_closed: 0
        }, {
            patch: true,
            success: function(model, response) {}
        });
        return false;
    },
    showAllVisibility: function() {
        $('.js-visibility-container').html('');
        var visibility = $('#inputBoardVisibility').val();
        $('.js-visibility-chooser').html(new App.ShowAllVisibilityView({
            model: visibility
        }).el);
        return false;
    },
    copyBoardVisibility: function(e) {
        e.preventDefault();
        var name = $(e.currentTarget).attr('name');
        var value = 0;
        if (name == 'org') {
            value = 1;
        } else if (name == 'public') {
            value = 2;
        }
        $('#inputBoardVisibility').val(value);
        $('.js-visibility-container').html(new App.CopyBoardVisibilityView({
            name: name
        }).el);
        $('.js-visibility-chooser').html('');
        return false;
    },
    hideSidebar: function() {
        var el = this.$el;
        el.find('.side-bar').addClass('disabled');
        return false;
    },
    showSidebarMenu: function(e) {
        var el = this.$el;
        el.find('.js-sidebar-menu-container').removeClass('hide');
        el.find('.js-sidebar-menu').addClass('js-hide-sidebar-menu').removeClass('js-show-sidebar-menu');
    },
    hideSidebarMenu: function(e) {
        var el = this.$el;
        el.find('.js-sidebar-menu-container').addClass('hide');
        el.find('.js-sidebar-menu').addClass('js-show-sidebar-menu').removeClass('js-hide-sidebar-menu');
    },
    /**
     * showBoardMemberPermissionForm()
     * show the board member permission list
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    showBoardMemberPermissionForm: function(e) {
        var target = $(e.currentTarget);
        var board_user_id = target.data('board_user_id');
        $('.js-board-member-settings').html(new App.showBoardMemberPermissionFormView({
            board_user_id: board_user_id
        }).el);
        $('.js-board-member-profile').addClass('hide');
        return false;
    },
    /**
     * editBoardMemberPermissionToAdmin()
     * change the board member permission as admin
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    editBoardMemberPermissionToAdmin: function(e) {
        var self = this;
        var target = $(e.currentTarget);
        var board_user_id = target.data('board_user_id');
        $('.js-board-member-settings').html(new App.EditBoardMemberPermissionToAdmin({
            board_user_id: board_user_id
        }).el);
        $('.js-board-member-profile').removeClass('hide');
        var boardUser = new App.BoardUsers();
        boardUser.url = api_url + 'boards_users/' + board_user_id + '.json';
        boardUser.set('id', board_user_id);
        boardUser.save();
        return false;
    },
    /**
     * editBoardMemberPermissionToNormal()
     * change the board member permission as noraml
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    editBoardMemberPermissionToNormal: function(e) {
        var self = this;
        var target = $(e.currentTarget);
        var board_user_id = target.data('board_user_id');
        $('.js-board-member-settings').html(new App.EditBoardMemberPermissionToNormal({
            board_user_id: board_user_id
        }).el);
        $('.js-board-member-profile').removeClass('hide');
        var boardUser = new App.BoardUsers();
        boardUser.url = api_url + 'boards_users/' + board_user_id + '.json';
        boardUser.set('id', board_user_id);
        boardUser.save();
        return false;
    },
    /**
     * showMemberActivities()
     * display the board member activities
     * @return false
     *
     */
    showMemberActivities: function() {
        $('.js-board-member-settings').html(new App.BoardUserActivityView({
            model: this.model
        }).el);
        $('.js-board-member-profile').addClass('hide');
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
                dropZone: $('#dropzone'),
                singleFileUploads: true,
                formData: $('form.js-user-profile-edit').serialize(),
                fileUploadHTML: '<input id="fileupload1" type="file" name="attachment"  >',
            });
            uploadManager.on('fileadd', function(file) {
                $('#dropzone').addClass('cssloader');
            });
            uploadManager.on('filedone', function(file, data) {
                $('#dropzone').removeClass('cssloader');
            });
            uploadManager.renderTo($('#manager-area'));
        }).defer();
        return false;
    },
    musical: function() {
        self = this;
        App.music.inst.silence();
        var temp = new App.MusicRepeatView();
        temp.continueMusic();
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
        $('body').addClass('modal-open');
        $('#header').html(new App.BoardHeaderView({
            model: this.model,
        }).el);
        this.musical();
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
            star: this.model.board_star
        }));
        this.renderListsCollection();
        this.setBoardBackground();
        if (!_.isUndefined(authuser.user)) {
            var setintervalid = '',
                is_moving_right = '',
                previous_offset = 0,
                previous_move = '',
                is_create_setinterval = true;
            $('#js-board-lists', this.$el).sortable({
                containment: 'window',
                axis: 'x',
                items: 'div.js-board-list',
                placeholder: 'col-lg-3 col-md-3 col-sm-4 col-xs-12 board-list-placeholder list ',
                forcePlaceholderSize: true,
                cursor: 'grab',
                scrollSensitivity: 100,
                scrollSpeed: 50,
                handle: '.js-list-head',
                tolerance: 'pointer',
                update: function(ev, ui) {
                    ui.item.trigger('listSort', ev, ui);
                },
                start: function(ev, ui) {
                    ui.placeholder.height(ui.item.outerHeight());
                    $(ev.target).find('.js-list-head').removeClass('cur-grab');
                    $(ev.target).find('.js-list-head').children('div.dropdown').removeClass('open');
                },
                stop: function(ev, ui) {
                    clearInterval(setintervalid);
                    is_create_setinterval = true;
                    previous_offset = 0;
                    $(ev.target).find('.js-list-head').addClass('cur-grab');
                },
                over: function(ev, ui) {
                    var scrollLeft = 0;
                    var list_per_page = Math.floor($(window).width() / 270);
                    if (previous_offset !== 0 && previous_offset != ui.offset.left) {
                        if (previous_offset > ui.offset.left) {
                            is_moving_right = false;
                        } else {
                            is_moving_right = true;
                        }
                    }
                    if (previous_move !== is_moving_right) {
                        clearInterval(setintervalid);
                        is_create_setinterval = true;
                    }
                    if (is_moving_right === true && ui.offset.left > (list_per_page - 1) * 270) {
                        if (is_create_setinterval) {
                            setintervalid = setInterval(function() {
                                scrollLeft = parseInt($('#js-board-lists').scrollLeft()) + 50;
                                $('#js-board-lists').animate({
                                    scrollLeft: scrollLeft
                                }, 10);
                            }, 100);
                            is_create_setinterval = false;
                        }
                    } else if (is_moving_right === false && ui.offset.left < 50) {
                        if (is_create_setinterval) {
                            setintervalid = setInterval(function() {
                                scrollLeft = parseInt($('#js-board-lists').scrollLeft()) - 50;
                                $('#js-board-lists').animate({
                                    scrollLeft: scrollLeft
                                }, 10);
                            }, 100);
                            is_create_setinterval = false;
                        }
                    }
                    previous_offset = ui.offset.left;
                    previous_move = is_moving_right;
                }
            });
        }
        $('a.js-switch-grid-view').parent().addClass('active');
        if (!_.isUndefined(authuser.user)) {
            if (parseInt(self.model.attributes.id) !== 0) {
                var board_activities = new App.FooterView({
                    model: authuser,
                    board_id: self.model.attributes.id,
                    board: self.model
                });
                clearInterval(set_interval_id);
                set_interval_id = setInterval(function() {
                    board_activities.userActivities(true, 1);
                }, 10000);
            }
        }
        self.board_view_height();
        this.showTooltip();
        return this;
    },
    /**
     * renderListsCollection()
     * display the lists in the board
     *
     */
    renderListsCollection: function() {
        App.sortable = {};
        App.sortable.setintervalid_horizontal = '';
        App.sortable.setintervalid_vertical = '';
        App.sortable.is_moving_right = '';
        App.sortable.is_moving_top = '';
        App.sortable.previous_offset_horizontal = 0;
        App.sortable.previous_offset_vertical = 0;
        App.sortable.previous_move_horizontal = '';
        App.sortable.previous_move_vertical = '';
        App.sortable.is_create_setinterval_horizontal = true;
        App.sortable.is_create_setinterval_vertical = true;
        App.sortable.previous_id = '';
        var self = this;
        var view_list = self.$('#js-add-list-block');
        var list_content = '';
        $('.js-board-list').remove();
        var postion = this.model.lists.max(function(list) {
            return list.get('position');
        });
        var new_position = 1;
        if (_.isObject(postion)) {
            new_position += postion.get('position');
        }
        self.model.lists.sortByColumn('position');
        self.model.lists.each(function(list) {
            list.board_users = self.model.board_users;
            list.labels = self.model.labels;
            _.map(list.get('lists_cards'), function(num) {
                _.map(num.card_labels, function(label) {
                    var data = {
                        id: label.label_id,
                        name: label.label_name
                    };
                    var _match = _.matches(data);
                    if (_.isEmpty(_.filter(self.model.labels, _match))) {
                        self.model.labels.push(data, {
                            silent: true
                        });
                    }
                });
            });
            var view;
            if (!_.isUndefined(list.get('is_new')) && list.get('is_new') === true) {
                list.set('board_id', self.model.id);
            } else {
                if (parseInt(list.get('is_archived')) === 0) {
                    var subscribers = new App.ListSubscriberCollection();
                    subscribers.add(list.get('lists_subscribers'), {
                        silent: true
                    });
                    if (!_.isUndefined(self.authuser)) {
                        var subscribe = subscribers.findWhere({
                            user_id: parseInt(self.authuser.id)
                        });
                        if (!_.isUndefined(subscribe)) {
                            list.subscriber.set(subscribe.attributes, {
                                silent: true
                            });
                        }
                    }
                    list.activities.add(self.model.activities, {
                        silent: true
                    });
                    list.attachments = self.model.attachments;
                    list.board_user_role_id = self.model.board_user_role_id;
                    list.board = self.model;
                    view = new App.ListView({
                        model: list,
                        attributes: {
                            'data-list_id': list.attributes.id
                        }
                    });
                    if (view_list.length > 0) {
                        view_list.before(view.render().el);
                    } else {
                        self.$('#js-board-lists').append(view.render().el);
                    }
                }
            }
        });
        _.defer(function(view) {
            if (!_.isUndefined(card_ids) && card_ids !== null && card_ids !== '') {
                trigger_dockmodal = true;
                var trigger_card_ids = card_ids.split(',');
                for (var i = 0; i < trigger_card_ids.length; i++) {
                    var card_view = $('#js-card-' + trigger_card_ids[i]);
                    if (card_view.length === 0) {
                        var card = self.model.cards.findWhere({
                            id: parseInt(trigger_card_ids[i])
                        });
                        if (!_.isUndefined(card)) {
                            card.list = self.model.lists.findWhere({
                                id: card.attributes.list_id
                            });
                            new App.CardView({
                                model: card
                            }).showCardModal();
                        }
                    } else {
                        card_view.trigger('click');
                    }
                }
                card_ids = null;
                trigger_dockmodal = false;
            }
        }, this);
    },
    /**
     * renderActivitiesCollection()
     * display board activities
     *
     */
    renderActivitiesCollection: function() {
        var self = this;
        var view_activity = this.$('#js-board-activities');
        this.model.activities.sortBy();
        this.model.activities.each(function(activity) {
            activity.set('board_name', _.escape(self.model.attributes.name));
            activity.cards.add(self.model.cards);
            activity.lists.add(self.model.lists);
            activity.boards.add(self.model.attributes.lists);
            var view = new App.ActivityView({
                model: activity
            });
        });
    },
    /**
     * setBoardBackground()
     * change board background
     *
     */
    setBoardBackground: function() {
        var background_color = this.model.attributes.background_color;
        var background_picture_url = this.model.attributes.background_picture_url;
        var background_pattern_url = this.model.attributes.background_pattern_url;
        if (!_.isEmpty(background_picture_url) && background_picture_url != 'NULL') {
            background_picture_url = background_picture_url.replace('_XXXX.jpg', '_b.jpg');
            $('body').css({
                'background': 'url(' + background_picture_url + ') 25% 25% no-repeat fixed',
                'background-size': 'cover'
            }).addClass('board-view');
        } else if (!_.isEmpty(background_pattern_url) && background_pattern_url != 'NULL') {
            background_pattern_url = background_pattern_url.replace('_XXXX.jpg', '_s.jpg');
            $('body').css({
                'background': 'url(' + background_pattern_url + ')',
            }).addClass('board-view board-view-pattern');
        } else if (!_.isEmpty(background_color) && background_color != 'NULL') {
            $('body').css({
                'background': background_color,
            }).addClass('board-view');
        } else {
            $('body').css({
                'background': '',
            }).addClass('board-view');
        }
    },
    /**
     * addCustomBackground()
     * add board custom background image
     * @param e
     * @type Object(DOM event)
     *
     */
    addCustomBackground: function(e) {
        var self = this;
        var form = $('form.js-add-custom-background-form');
        var target = $(e.target);
        var board_background = new App.CardAttachment();
        board_background.url = api_url + 'boards/' + self.model.id + '/custom_backgrounds.json';
        board_background.save({}, {
            data: {},
            files: $('input.js-add-custom-background', form),
            iframe: true,
            success: function(model, response) {
                self.model.custom_attachments.push(board_background);
                $('.js-board-background-custom-lists').append(new App.BoardCustomBackgroundView({
                    attributes: {
                        'data-background': model.attributes.custom_attachments.path,
                    },
                    model: board_background
                }).el);
            }
        });
    },
    /**
     * changeCustomBackground()
     * change board custom background image
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    changeCustomBackground: function(e) {
        var image_path = $(e.currentTarget).data('background');
        $('body').removeAttr('style').css({
            'background': 'url(' + image_path + ') left top',
            'background-size': 'cover'
        }).addClass('board-view-pattern board-view');
        this.model.url = api_url + 'boards/' + this.model.id + '.json';
        this.model.set('custom_background_url', image_path);
        this.model.set('background_pattern_url', '');
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
    showAddListForm: function(e) {
        e.preventDefault();
        var toggle = $(e.target);
        toggle.addClass('hide').next('.js-add-list').removeClass('hide').find('#inputListName').focus();
    },
    /**
     * hideAddListForm()
     * hide the list add form
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    hideAddListForm: function(e) {
        e.preventDefault();
        var toggle = $(e.target);
        toggle.parents('form').addClass('hide').prev('.js-show-add-list-form').removeClass('hide');
        return false;
    },
    /**
     * addList()
     * add list into the board
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    addList: function(e) {
        e.preventDefault();
        var self = this;
        var el = this.$el;
        var target = $(e.target);
        var view_list = el.find('#js-board-lists');
        var data = target.serializeObject();
        target[0].reset();
        target.parents('.dropdown').removeClass('open');
        target.prev().prev('.js-show-add-list-form').removeClass('hide').addClass('toggle-show').next('.js-show-list-actions').removeClass('hide');
        var list = new App.List();
        data.uuid = new Date().getTime();
        list.set('uuid', data.uuid);
        var postion = self.model.lists.max(function(list) {
            return (!_.isUndefined(list)) ? list.get('position') : 1;
        });
        if (_.isUndefined(data.position)) {
            data.position = (!_.isUndefined(postion) && !_.isEmpty(postion)) ? postion.get('position') + 1 : 1;
        } else {
            var before = this.model.lists.get(data.clone_list_id);
            var after = this.model.lists.next(before);
            if (typeof after == 'undefined') {
                afterPosition = before.position() + 2;
            } else {
                afterPosition = after.position();
            }
            var difference = (afterPosition - before.position()) / 2;
            var newPosition = difference + before.position();
            data.position = newPosition;
        }
        data.is_archived = 0;
        data.board_id = self.model.id;
        var view = '';
        if (!_.isUndefined(data.clone_list_id)) {
            list.set(data, {
                silent: true
            });
            list.board = self.model;
            view = new App.ListView({
                model: list,
                attributes: {
                    'data-list_id': list.attributes.id,
                },
            });
            $(view.render().el).insertAfter($(e.target).parents('.js-board-list'));
        }
        list.url = api_url + 'boards/' + self.model.id + '/lists.json';
        list.save(data, {
            success: function(model, response, options) {
                if (self.model.attributes.lists !== null) {
                    self.model.attributes.lists.push(list);
                }
                if (!_.isUndefined(data.clone_list_id)) {
                    if (!_.isUndefined(response.list.labels) && response.list.labels.length > 0) {
                        self.model.labels.add(response.list.labels, {
                            silent: true
                        });
                        list.labels.add(response.list.labels, {
                            silent: true
                        });
                    }
                    if (!_.isUndefined(response.list.activities) && response.list.activities.length > 0) {
                        self.model.activities.add(response.list.activities, {
                            silent: true
                        });
                        list.activities.add(response.list.activities, {
                            silent: true
                        });
                    }
                    list.set(response.list);
                    list.set('cards', response.list.cards);
                    self.model.cards.add(response.list.cards, {
                        silent: true
                    });
                    var i = 1;
                    _.each(response.list.attachments, function(attachment) {
                        var options = {
                            silent: true
                        };
                        if (i === response.list.attachments.length) {
                            options.silent = false;
                        }
                        var new_attachment = new App.CardAttachment();
                        new_attachment.set(attachment);
                        new_attachment.set('id', parseInt(attachment.id));
                        new_attachment.set('board_id', parseInt(attachment.board_id));
                        new_attachment.set('list_id', parseInt(attachment.list_id));
                        new_attachment.set('card_id', parseInt(attachment.card_id));
                        self.model.cards.get(parseInt(attachment.card_id)).attachments.add(new_attachment, options);
                        self.model.attachments.add(new_attachment, {
                            silent: true
                        });
                        list.attachments.add(new_attachment, {
                            silent: true
                        });
                        i++;
                    });
                    var j = 1;
                    _.each(response.list.checklists, function(checklist) {
                        var options = {
                            silent: true
                        };
                        if (j === response.list.checklists.length) {
                            options.silent = false;
                        }
                        var new_checklist = new App.CheckList();
                        new_checklist.set(checklist);
                        new_checklist.set('card_id', parseInt(checklist.card_id));
                        new_checklist.set('checklist_item_completed_count', parseInt(checklist.checklist_item_completed_count));
                        new_checklist.set('checklist_item_count', parseInt(checklist.checklist_item_count));
                        var k = 1;
                        _.each(response.list.checklists_items, function(checklist_item) {
                            var options = {
                                silent: true
                            };
                            if (k === response.list.checklists_items.length) {
                                options.silent = false;
                            }
                            var new_checklist_item = new App.CheckListItem();
                            new_checklist_item.set(checklist_item);
                            new_checklist_item.set('card_id', parseInt(checklist_item.card_id));
                            new_checklist_item.set('checklist_id', parseInt(checklist_item.checklist_id));
                            new_checklist_item.set('id', parseInt(checklist_item.id));
                            new_checklist_item.set('position', checklist_item.position);
                            new_checklist_item.set('user_id', parseInt(checklist_item.user_id));
                            new_checklist.checklist_items.set(new_checklist_item);
                            self.model.checklist_items.add(new_checklist_item, options);
                            k++;
                        });
                        self.model.checklists.add(new_checklist, options);
                        j++;
                    });
                } else {
                    list.set('lists_cards', []);
                }
                if (_.isUndefined(options.temp_id)) {
                    list.set('id', parseInt(response.id));
                } else {
                    global_uuid[data.uuid] = options.temp_id;
                    list.set('id', data.uuid);
                }
                list.set('board_id', self.model.id);
                list.set('is_archived', 0);
                self.model.lists.add(list, {
                    silent: true
                });
                list = self.model.lists.findWhere({
                    uuid: data.uuid
                });
                App.boards.get(list.attributes.board_id).lists.add(list);
                list.board_users = self.model.board_users;
                if (!_.isUndefined(data.clone_list_id)) {
                    $(view.render().el).insertAfter($(e.target).parents('.js-board-list'));
                } else {
                    list.board = self.model;
                    view = new App.ListView({
                        model: list,
                        attributes: {
                            'data-list_id': list.attributes.id,
                        },
                    });
                    $(view.render().el).insertBefore($('#js-add-list-block'));
                }
            }
        });
        return false;
    },
    /**
     * syncGoogleCalendar()
     * get sync google calender URL and display
     * @param e
     * @type Object(DOM event)
     *
     */
    syncGoogleCalendar: function(e) {
        e.preventDefault();
        this.$el.find('input.js-syn-calendar-response').val(this.model.attributes.google_syn_url);
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
    /**
     * searchArchivedCards()
     * search show show archived cards
     * @param e
     * @type Object(DOM event)
     *
     */
    searchArchivedCards: function(e) {
        var self = this;
        var el = this.$el;
        var search_q = $(e.currentTarget).val();

        var filtered_cards = self.model.cards.search(search_q);
        var cards = new App.CardCollection();
        if (!_.isEmpty(search_q)) {
            cards.add(filtered_cards._wrapped);
        } else {
            cards = self.model.cards;
        }
        el.find('.js-archived-cards-container').html('');
        cards.each(function(card) {
            if (card.attributes.is_archived === 1) {
                el.find('.js-archived-cards-container').append(new App.ArchivedCardView({
                    model: card
                }).el);
            }
        });
    },
    /**
     * searchArchivedLists()
     * search show show archived lists
     * @param e
     * @type Object(DOM event)
     *
     */
    searchArchivedLists: function(e) {
        var self = this;
        var el = this.$el;
        var search_q = $(e.currentTarget).val();
        var filtered_lists = this.model.lists.search(search_q);
        var lists = new App.ListCollection();
        if (!_.isEmpty(search_q)) {
            lists.add(filtered_lists._wrapped);
        } else {
            lists = self.model.lists;
        }
        el.find('.js-archived-cards-container').html('');
        lists.each(function(list) {
            if (list.attributes.is_archived === 1) {
                el.find('.js-archived-cards-container').append(new App.ArchivedListView({
                    model: list
                }).el);
            }
        });
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
    showBoardMemberRemoveForm: function(e) {
        e.preventDefault();
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
