/**
 * @fileOverview This file has functions related to application view. This view calling from application.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined
 */
if (typeof App == 'undefined') {
    App = {};
}
var loginExceptionUrl = ['register', 'login', 'forgotpassword', 'user_activation', 'aboutus'];
var adminUrl = ['roles', 'activities', 'users', 'settings', 'email_templates'];
/**
 * Application View
 * @class ApplicationView
 * @constructor
 * @extends Backbone.View
 */

App.ApplicationView = Backbone.View.extend({
    /** 
     * Constructor
     * Check api token is present if
     * initialize default values and actions
     */
    initialize: function(options) {
        var page = this;
        page.page_view_type = options.type;
        page.page_view_id = options.id;
        page.page_view_hash = options.hash;
        last_user_activity_id = load_more_last_board_activity_id = last_board_activity_id = 0;
        if (_.isUndefined(App.music)) {
            App.music = {};
        }
        if (!_.isUndefined(App.music)) {
            App.music.music_content = '';
            if (!_.isUndefined(App.music.inst)) {
                App.music.inst.silence();
            }
        }
        if (window.sessionStorage.getItem('auth') !== undefined && window.sessionStorage.getItem('auth') !== null && !api_token) {
            var Auth = JSON.parse(window.sessionStorage.getItem('auth'));
            api_token = Auth.access_token;
            page.authuser = Auth;
            authuser = Auth;
            var organizations = authuser.user.organizations;
            authuser.user.organizations = new App.OrganizationCollection();
            authuser.user.organizations.add(organizations);
        } else {
            if (_.isUndefined(window.sessionStorage.getItem("music_play")) || window.sessionStorage.getItem("music_play") === null) {
                window.sessionStorage.setItem('music_play', "1");
            }
        }
        if (role_links.length === 0 && window.sessionStorage.getItem('links') !== undefined && window.sessionStorage.getItem('links') !== null) {
            role_links.add(JSON.parse(window.sessionStorage.getItem('links')));
        }
        if (page.model !== 'boards_view') {
            viewed_board = new App.Board();
        }
        if (!is_offline_data) {
            if (api_token === '') {
                page.authuser = new App.OAuth();
                page.authuser.url = api_url + 'oauth.json';
                page.authuser.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(model, response) {
                        api_token = response.access_token;
                        window.sessionStorage.setItem('links', response.links);
                        role_links.add(JSON.parse(response.links));
                        settings.url = api_url + 'settings.json';
                        settings.fetch({
                            cache: false,
                            abortPending: true,
                            success: function(collection, settings_response) {
                                SITE_NAME = settings_response.SITE_NAME;
                                page.set_page_title();
                                FLICKR_API_KEY = settings_response.FLICKR_API_KEY;
                                DROPBOX_APPKEY = settings_response.DROPBOX_APPKEY;
                                LABEL_ICON = settings_response.LABEL_ICON;
                                SITE_TIMEZONE = settings_response.SITE_TIMEZONE;
                                LDAP_LOGIN_ENABLED = settings_response.LDAP_LOGIN_ENABLED;
                                STANDARD_LOGIN_ENABLED = settings_response.STANDARD_LOGIN_ENABLED;
                                if (page.model === "admin_user_add" || page.model === "register") {
                                    if ((!_.isEmpty(LDAP_LOGIN_ENABLED) && LDAP_LOGIN_ENABLED === "false") || (!_.isEmpty(STANDARD_LOGIN_ENABLED) && (STANDARD_LOGIN_ENABLED === "true"))) {
                                        page.call_function();
                                    } else {
                                        changeTitle('404 not found');
                                        this.headerView = new App.HeaderView({
                                            model: authuser
                                        });
                                        $('#header').html(this.headerView.el);
                                        var view = new App.Error404View();
                                        $('#content').html(view.el);
                                        return;
                                    }
                                } else {
                                    page.call_function();
                                }
                            }
                        });
                    },
                    error: function() {
                        app.navigate('#/users/login', {
                            trigger: true,
                            replace: true
                        });
                    },
                });
            } else {
                if (settings.length === 0) {
                    settings.fetch({
                        cache: false,
                        abortPending: true,
                        success: function(collection, settings_response) {
                            SITE_NAME = settings_response.SITE_NAME;
                            page.set_page_title();
                            FLICKR_API_KEY = settings_response.FLICKR_API_KEY;
                            DROPBOX_APPKEY = settings_response.DROPBOX_APPKEY;
                            LABEL_ICON = settings_response.LABEL_ICON;
                            SITE_TIMEZONE = settings_response.SITE_TIMEZONE;
                            LDAP_LOGIN_ENABLED = settings_response.LDAP_LOGIN_ENABLED;
                            STANDARD_LOGIN_ENABLED = settings_response.STANDARD_LOGIN_ENABLED;
                            if (page.model === "admin_user_add" || page.model === "register") {
                                if ((!_.isEmpty(LDAP_LOGIN_ENABLED) && LDAP_LOGIN_ENABLED === "false") || (!_.isEmpty(STANDARD_LOGIN_ENABLED) && (STANDARD_LOGIN_ENABLED === "true"))) {
                                    page.call_function();
                                } else {
                                    changeTitle('404 not found');
                                    this.headerView = new App.HeaderView({
                                        model: authuser
                                    });
                                    $('#header').html(this.headerView.el);
                                    var view = new App.Error404View();
                                    $('#content').html(view.el);
                                    return;
                                }
                            } else {
                                page.call_function();
                            }
                        }
                    });
                } else {
                    if (page.model === "admin_user_add" || page.model === "register") {
                        if ((!_.isEmpty(LDAP_LOGIN_ENABLED) && LDAP_LOGIN_ENABLED === "false") || (!_.isEmpty(STANDARD_LOGIN_ENABLED) && (STANDARD_LOGIN_ENABLED === "true"))) {
                            page.call_function();
                        } else {
                            changeTitle('404 not found');
                            this.headerView = new App.HeaderView({
                                model: authuser
                            });
                            $('#header').html(this.headerView.el);
                            var view = new App.Error404View();
                            $('#content').html(view.el);
                            return;
                        }
                    } else {
                        page.call_function();
                    }
                }
            }
        } else {
            return false;
        }
    },
    set_page_title: function() {
        if (this.model == 'login') {
            changeTitle('Login');
        }
        if (this.model == 'aboutus') {
            changeTitle('About');
        }
        if (this.model == 'admin_user_add') {
            changeTitle('Admin Add User');
        }
        if (this.model == 'register') {
            changeTitle('Register');
        }
        if (this.model == 'forgotpassword') {
            changeTitle('Forgot Password');
        }
        if (this.model == 'user_activation') {
            changeTitle('User Activation');
        }
        if (this.model == 'changepassword') {
            changeTitle('Change Password');
        }
        if (this.model == 'settings') {
            changeTitle('Settings');
        }
        if (this.model == 'boards_index') {
            changeTitle('Boards');
        }
        if (this.model == 'starred_boards_index') {
            changeTitle('Starred Boards');
        }
        if (this.model == 'closed_boards_index') {
            changeTitle('Closed Boards');
        }
        if (this.model == 'organizations_view') {
            changeTitle('Organization');
        }
        if (this.model == 'organizations_view_type') {
            changeTitle('Organization');
        }
        if (this.model == 'organizations_user_view') {
            changeTitle('Organization User');
        }
        if (this.model == 'users_index') {
            changeTitle('Users');
        }
        if (this.model == 'role_settings') {
            changeTitle('Role Settings');
        }
        if (this.model == 'organizations_index') {
            changeTitle('Organizations');
        }
        if (this.model == 'email_templates') {
            changeTitle('Email Templates');
        }
        if (this.model == 'email_template_type') {
            changeTitle('Email Templates');
        }
        if (this.model == 'activity_index') {
            changeTitle('Activities');
        }
    },
    /**
     * board_view()
     * render the board view
     * @return Object
     */
    board_view: function() {
        var self = this;
        if (viewed_board.id !== parseInt(self.id)) {
            var Board = new App.Board({
                id: self.id
            });
            Board.url = api_url + 'boards/' + self.id + '.json';
            Board.id = self.id;
            Board.fetch({
                cache: false,
                abortPending: true,
                success: function(model, response) {
                    if (!_.isUndefined(response.error)) {
                        $('#content').html(new App.Board404View({
                            model: authuser
                        }).el);
                        this.headerView = new App.HeaderView({
                            model: authuser
                        });
                        $('#header').html(this.headerView.el);
                    } else {
                        Board.authuser = self.authuser;
                        viewed_board = Board;
                        $('#content').html(new App.BoardView({
                            model: Board
                        }).el);
                        $('[data-spy="affix"]').each(function() {
                            var $spy = $(this);
                            var data = $spy.data();

                            data.offset = data.offset || {};

                            if (data.offsetBottom) data.offset.bottom = data.offsetBottom;
                            if (data.offsetTop) data.offset.top = data.offsetTop;

                            $spy.affix(data);
                        });
                        if (view_type === 'list') {
                            $('.js-switch-list-view').trigger('click');
                            view_type = null;
                        } else if (view_type === 'calendar') {
                            $('.js-switch-calendar-view').trigger('click');
                            view_type = null;
                        } else if (view_type === 'timeline') {
                            $('.js-switch-time-view').trigger('click');
                            view_type = null;
                        } else if (view_type === 'attachments') {
                            $('.js-show-board-modal').trigger('click');
                            view_type = null;
                        } else if (view_type === null || view_type === '') {
                            $('.js-switch-grid-view').trigger('click');
                            view_type = null;
                        }
                        this.footerView = new App.FooterView({
                            model: authuser,
                            board_id: self.id,
                            board: Board
                        }).render();
                        $('#footer').html(this.footerView.el);
                        $('[data-toggle="tooltip"]').tooltip();
                        if (!_.isUndefined(authuser.user)) {
                            var count = authuser.user.notify_count;
                            if (count > 0) {
                                if (count >= 100) {
                                    count = '100+';
                                }
                                $('#js-notification-count').removeClass('hide').html(count);
                                favicon.badge(count);
                            }
                        }
                        var current_param = Backbone.history.fragment;
                        var current_param_split = current_param.split('/');
                        if (current_param.indexOf('list') === -1 && current_param.indexOf('calendar') === -1) {
                            $('a.js-switch-grid-view').parent().addClass('active');
                        }
                    }
                    self.board_view_height();
                }
            });

        } else {
            if (view_type === 'list') {
                $('.js-switch-list-view').trigger('click');
                view_type = null;
            } else if (view_type === 'calendar') {
                $('.js-switch-calendar-view').trigger('click');
                view_type = null;
            } else if (view_type === 'timeline') {
                $('.js-switch-time-view').trigger('click');
                view_type = null;
            } else if (view_type === 'attachments') {
                $('.js-show-board-modal').trigger('click');
                view_type = null;
            } else if (view_type === null || view_type === '') {
                view_type = null;
            }
        }

        return this;
    },
    /**
     * organization_view()
     * render the organization view
     * @return Object
     */
    organization_view: function() {
        var self = this;
        var Organization = new App.Organization();
        Organization.organization_id = self.id;
        Organization.url = api_url + 'organizations/' + self.id + '.json';
        Organization.fetch({
            cache: false,
            abortPending: true,
            success: function(model, response) {
                if (!_.isUndefined(response.error) && response.error.message == 'Unauthorized') {
                    app.navigate('#/users/login', {
                        trigger: true,
                        replace: true
                    });
                } else {
                    Organization.boards.add(Organization.attributes.boards_listing);
                    $('#header').html(new App.OrganizationHeaderView({
                        model: Organization,
                        type: self.page_view_type
                    }).el);
                    $('#content').html(new App.OrganizationsView({
                        model: Organization,
                        type: self.page_view_type
                    }).el);
                }
            }
        });

        return this;
    },
    /**
     * call_function()
     * call the render function based on model
     * @default ''
     * @type String
     */
    call_function: function() {
        var page = this;
        this.headerView = new App.HeaderView({
            model: authuser
        });
        var load_boards = false;
        if (page.model == 'boards_view' && App.boards !== undefined) {
            if (_.isUndefined(App.boards.get(parseInt(page.id)))) {
                load_boards = true;
            }
        }
        if ((App.boards === undefined || load_boards) && !_.isUndefined(authuser.user)) {
            var boards = new App.BoardCollection();
            boards.url = api_url + 'boards.json?type=simple';
            boards.fetch({
                cache: false,
                abortPending: true,
                success: function(model, response) {
                    App.boards = boards;
                    page.populateLists();
                    page.populateBoardStarred();
                    if ((_.indexOf(adminUrl, Backbone.history.fragment) >= 0 && !_.isEmpty(authuser.user) && authuser.user.role_id == 1) || _.indexOf(adminUrl, Backbone.history.fragment) < 0) {
                        page.callback();
                    } else {
                        app.navigate('#/boards', {
                            trigger: true,
                            replace: true
                        });
                    }
                }
            });
        } else {
            if ((_.indexOf(adminUrl, Backbone.history.fragment) >= 0 && !_.isEmpty(authuser.user) && authuser.user.role_id == 1) || _.indexOf(adminUrl, Backbone.history.fragment) < 0) {
                page.callback();
            } else {
                app.navigate('#/boards', {
                    trigger: true,
                    replace: true
                });
            }
        }
        if (page.model !== 'boards_view' && page.model !== 'users_index') {
            $('#header').html(this.headerView.el);
        }
    },
    populateLists: function() {
        App.boards.each(function(board) {
            board.lists.add(board.attributes.lists);
        });
    },
    populateBoardStarred: function() {
        App.boards.each(function(board) {
            board.boards_stars.add(board.attributes.stars);
        });
    },
    callback: function() {
        var page = this;
        if (page.model == 'boards_view') {
            $('body').css('background', 'transparent');
            if (!_.isEmpty(role_links.where({
                    slug: 'view_board'
                }))) {
                page.board_view();
            }
        } else if (page.model == 'organizations_view') {
            page.organization_view();
        } else if (_.isEmpty(authuser.user) && _.indexOf(loginExceptionUrl, page.model) <= -1) {
            app.navigate('#/users/login', {
                trigger: true,
                replace: true
            });
        } else if (!_.isEmpty(authuser.user) && _.indexOf(loginExceptionUrl, page.model) > -1) {
            if (page.model == 'aboutus') {
                this.pageView = new App.AboutusView();
                $('#content').html(this.pageView.el);
            } else {
                app.navigate('#/boards', {
                    trigger: true,
                    replace: true,
                    trigger_function: false,
                });
                Backbone.history.loadUrl('#/boards');
            }
        } else {
            if (page.model == 'admin_user_add') {
                var AdminUser = new App.User();
                this.pageView = new App.AdminUserAddView({
                    model: AdminUser
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'register') {
                var User = new App.User();
                this.pageView = new App.RegisterView({
                    model: User
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'login') {
                var LoginUser = new App.User();
                this.pageView = new App.LoginView({
                    model: LoginUser
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'forgotpassword') {
                var ForgotPasswordUser = new App.User();
                this.pageView = new App.ForgotpasswordView({
                    model: ForgotPasswordUser
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'user_activation') {
                var UserActivation = new App.User();
                UserActivation.user_id = page.id;
                UserActivation.hash = page.page_view_hash;
                this.pageView = new App.UseractivationView({
                    model: UserActivation
                });
            } else if (page.model == 'changepassword') {
                var ChangePasswordUser = new App.User();
                ChangePasswordUser.user_id = page.id;
                this.pageView = new App.ChangepasswordView({
                    model: ChangePasswordUser
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'aboutus') {
                this.pageView = new App.AboutusView();
                $('#content').html(this.pageView.el);
            } else if (page.model == 'boards_index' || page.model == 'starred_boards_index' || page.model == 'closed_boards_index') {
                var page_title = 'My Boards';
                if (page.model == 'starred_boards_index') {
                    page_title = 'Starred Boards';
                } else if (page.model == 'closed_boards_index') {
                    page_title = 'Closed Boards';
                }
                this.headerView = new App.BoardIndexHeaderView({
                    model: page_title,
                });
                $('#header').html(new App.BoardIndexHeaderView({
                    model: page_title,
                }).el);
                var board_index = $('#content');
                board_index.html('');
                var self = this;
                var user_boards = new App.BoardCollection();
                user_boards.url = api_url + 'users/' + authuser.user.id + '/boards.json';
                user_boards.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(model, response) {
                        var boards = new App.BoardCollection();
                        boards.url = api_url + 'boards.json?type=simple';
                        boards.fetch({
                            cache: false,
                            abortPending: true,
                            success: function(board_model, board_response) {
                                App.boards = boards;
                                self.populateLists();
                                self.populateBoardStarred();
                                var board_activities = new App.FooterView({
                                    model: authuser,
                                    boards: boards
                                });
                                clearInterval(set_interval_id);
                                set_interval_id = setInterval(function() {
                                    board_activities.userActivities(true, 1);
                                }, 10000);
                                if (page.model == 'starred_boards_index') {
                                    board_index.append(new App.StarredBoardsIndexView().el);
                                    if (!_.isEmpty(role_links.where({
                                            slug: 'view_stared_boards'
                                        }))) {
                                        if (!_.isEmpty(response.starred_boards)) {
                                            _.each(response.starred_boards, function(starred_board) {
                                                var board = App.boards.findWhere({
                                                    id: parseInt(starred_board),
                                                    is_closed: false
                                                });
                                                if (!_.isUndefined(board)) {
                                                    board.board_subscribers.add(board.attributes.boards_subscribers);
                                                    filter = _.matches({
                                                        is_archived: false
                                                    });
                                                    filtered_lists = _.filter(board.attributes.lists, filter);
                                                    board.lists.add(filtered_lists);
                                                    $('.js-header-starred-boards').append(new App.BoardSimpleView({
                                                        model: board,
                                                        id: 'js-starred-board-' + board.attributes.id,
                                                        className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad js-board-view js-board-view-' + board.attributes.id,
                                                        starred_boards: response.starred_boards
                                                    }).el);
                                                }
                                            });
                                            if ($('.js-header-starred-boards > .js-board-view').length === 0) {
                                                $('.js-header-starred-boards').append(new App.BoardSimpleView({
                                                    model: null,
                                                    message: 'No starred boards available.',
                                                    id: 'js-starred-board-empty',
                                                    className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12'
                                                }).el);
                                            }
                                        } else {
                                            $('.js-header-starred-boards').append(new App.BoardSimpleView({
                                                model: null,
                                                message: 'No starred boards available.',
                                                id: 'js-starred-board-empty',
                                                className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12'
                                            }).el);
                                        }

                                    }
                                } else if (page.model == 'closed_boards_index') {
                                    board_index.append(new App.ClosedBoardsIndexView().el);
                                    if (!_.isEmpty(role_links.where({
                                            slug: 'view_closed_boards'
                                        }))) {
                                        var closed_boards = App.boards.where({
                                            is_closed: true
                                        });
                                        if (!_.isEmpty(closed_boards)) {
                                            _.each(closed_boards, function(closed_board) {
                                                closed_board.board_subscribers.add(closed_board.attributes.boards_subscribers);
                                                filter = _.matches({
                                                    is_archived: false
                                                });
                                                filtered_lists = _.filter(closed_board.attributes.lists, filter);
                                                closed_board.lists.add(filtered_lists);
                                                $('.js-header-closed-boards').append(new App.BoardSimpleView({
                                                    model: closed_board,
                                                    id: 'js-closed-board-' + closed_board.attributes.id,
                                                    className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad js-board-view js-board-view-' + closed_board.attributes.id,
                                                    starred_boards: response.starred_boards
                                                }).el);
                                            });
                                            if ($('.js-header-closed-boards > .js-board-view').length === 0) {
                                                $('.js-header-closed-boards').append(new App.BoardSimpleView({
                                                    model: null,
                                                    message: 'No closed boards available.',
                                                    id: 'js-closed-board-empty',
                                                    className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12'
                                                }).el);
                                            }
                                        } else {
                                            $('.js-header-closed-boards').append(new App.BoardSimpleView({
                                                model: null,
                                                message: 'No closed boards available.',
                                                id: 'js-closed-board-empty',
                                                className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12'
                                            }).el);
                                        }

                                    }
                                } else {
                                    board_index.append(new App.BoardsIndexView().el);
                                    var my_boards = '';
                                    my_boards = App.boards.where({
                                        is_closed: false
                                    });
                                    if (!_.isEmpty(role_links.where({
                                            slug: 'view_my_boards'
                                        }))) {
                                        if (!_.isEmpty(my_boards)) {
                                            _.each(my_boards, function(my_board) {
                                                var my_board_filter = _.matches({
                                                    is_archived: false
                                                });
                                                var my_board_filtered_lists = _.filter(my_board.attributes.lists, my_board_filter);
                                                my_board.lists.add(my_board_filtered_lists);
                                                $('.js-my-boards').append(new App.BoardSimpleView({
                                                    model: my_board,
                                                    id: 'js-my-board-' + my_board.attributes.id,
                                                    className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad js-board-view js-board-view-' + my_board.attributes.id,
                                                    starred_boards: response.starred_boards
                                                }).el);
                                            });
                                            new App.FooterView({
                                                model: authuser,
                                                board_id: self.id,
                                                boards: my_boards
                                            });
                                        } else {
                                            $('.js-my-boards').append(new App.BoardSimpleView({
                                                model: null,
                                                message: 'No boards available.',
                                                id: 'js-my-board-empty',
                                                className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12'
                                            }).el);
                                        }
                                    }
                                }

                            }
                        });
                    }
                });
            } else if (page.model == 'users_index') {
                var users = new App.UserCollection();
                users.url = api_url + 'users.json';
                users.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(collections, response) {
                        this.headerView = new App.HeaderView({
                            model: authuser,
                            users: users
                        });
                        $('#header').html(this.headerView.el);
                        $('#js-navbar-default').remove();
                        var view = $('#content').html(new App.UserIndexContainerView({
                            model: user
                        }).el);
                        users.each(function(user) {
                            $('.js-user-list').append(new App.UserIndex({
                                model: user
                            }).el);
                        });
                        $('.js-user-list').find('.timeago').timeago();
                    }
                });
            } else if (page.model == 'settings') {
                $('#js-navbar-default').remove();
                $('#content').html(new App.SettingView({
                    id: page.page_view_id
                }).el);
            } else if (page.model == 'user_view') {
                if (!_.isUndefined(authuser.user) && (authuser.user.id === page.id || authuser.user.id === '1')) {
                    // User View
                    var user = new App.User();
                    user.url = api_url + 'users/' + page.id + '.json';
                    user.fetch({
                        cache: false,
                        abortPending: true,
                        success: function(user, response) {
                            $('#header').html(new App.UserViewHeaderView({
                                model: user,
                                type: page.page_view_type
                            }).el);
                            $('#content').html(new App.UserView({
                                model: user,
                                type: page.page_view_type
                            }).el);
                        }
                    });
                } else {
                    app.navigate('#/boards', {
                        trigger: true,
                        replace: true,
                        trigger_function: false,
                    });
                    Backbone.history.loadUrl('#/boards');
                    page.flash('danger', 'Permission denied');
                }
            } else if (page.model == 'role_settings') {
                // User View
                var acl_links = new App.ACLCollection();
                acl_links.url = api_url + 'acl_links.json';
                acl_links.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(acl_links, response) {
                        acl_links.reset(response.acl_links);
                        var roles = new App.RoleCollection();
                        roles.reset(response.roles);
                        $('#js-navbar-default').remove();
                        $('#content').html(new App.RoleSettingsView({
                            model: acl_links,
                            roles: roles
                        }).el);
                    }
                });
            } else if (page.model == 'organizations_index') {
                var organizations = new App.OrganizationCollection();
                organizations.url = api_url + 'organizations.json';
                organizations.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(collections, response) {
                        $('#header').html(new App.OrganizationsListsHeaderView({
                            model: organizations,
                        }).el);
                    }
                });
            } else if (page.model == 'email_template_type') {
                $('#js-navbar-default').remove();
                $('#content').html(new App.EmailTemplateView({
                    id: page.page_view_id
                }).el);
            } else if (page.model == 'activity_index') {
                $('#js-navbar-default').remove();
                $('#content').html(new App.ActivityIndexView({
                    id: page.page_view_id
                }).el);
            }
        }
        if (page.model == 'boards_view') {
            authuser.board_id = this.id;
        } else {
            authuser.board_id = 0;
        }
        if ((window.sessionStorage.getItem('auth') !== undefined && window.sessionStorage.getItem('auth') !== null) || page.model == 'organizations_view') {
            this.footerView = new App.FooterView({
                model: authuser
            }).render();
            $('#footer').html(this.footerView.el);
            if (!_.isUndefined(authuser.user)) {
                var count = authuser.user.notify_count;
                if (count > 0) {
                    if (count >= 100) {
                        count = '100+';
                    }
                    $('#js-notification-count').removeClass('hide').html(count);
                    favicon.badge(count);
                }
            }
        } else {
            if (Backbone.history.fragment.indexOf('board/') != -1 || Backbone.history.fragment.indexOf('organization/') != -1 || Backbone.history.fragment.indexOf('boards') != -1) {
                this.footerView = new App.FooterView({
                    model: authuser,
                }).render();
                $('#footer').html(this.footerView.el);
            } else {
                $('#footer').html('');
            }
        }
    }
});
