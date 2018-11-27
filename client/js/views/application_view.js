/**
 * @fileOverview This file has functions related to application view. This view calling from application.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined
 */
if (typeof App === 'undefined') {
    App = {};
}
var loginExceptionUrl = ['register', 'login', 'forgotpassword', 'user_activation', 'aboutus'];
var adminUrl = ['roles', 'activities', 'users', 'boards/list', 'oauth_clients', 'apps', 'user_logins', 'settings', 'email_templates', 'users_logins'];
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
        $('#content').html('');
        $('#footer').removeClass('action-open');
        $('.tooltip').remove();
        var page = this;
        page.options = options;
        page.page_view_type = options.type;
        page.page_view_id = options.id;
        page.page_view_hash = options.hash;
        page.page_view_q = options.q;
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
        if ($.cookie('auth') !== undefined && $.cookie('auth') !== null && !api_token) {
            var Auth = JSON.parse($.cookie('auth'));
            api_token = Auth.access_token;
            page.authuser = Auth;
            authuser = Auth;
        } else {
            if (_.isUndefined($.cookie("music_play")) || $.cookie("music_play") === null) {
                $.cookie('music_play', "1");
            }
        }
        localforage.getItem('links', function(err, value) {
            if (value) {
                if (role_links.length === 0 && value !== undefined && value !== null) {
                    role_links.add(JSON.parse(value));
                }
            }
        });
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
                        if (!_.isUndefined(response.links)) {
                            localforage.setItem("links", response.links);
                        }
                        $.cookie('languages', response.languages);
                        localforage.setItem('apps', response.apps).then(function() {
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
                                    IS_TWO_FACTOR_AUTHENTICATION_ENABLED = settings_response.IS_TWO_FACTOR_AUTHENTICATION_ENABLED;
                                    DEFAULT_LANGUAGE = settings_response.DEFAULT_LANGUAGE;
                                    PAGING_COUNT = settings_response.PAGING_COUNT;
                                    ALLOWED_FILE_EXTENSIONS = settings_response.ALLOWED_FILE_EXTENSIONS;
                                    R_LDAP_LOGIN_HANDLE = settings_response.R_LDAP_LOGIN_HANDLE;
                                    APPS = settings_response.apps;
                                    IMAP_EMAIL = settings_response.IMAP_EMAIL;
                                    DEFAULT_CARD_VIEW = settings_response.DEFAULT_CARD_VIEW;
                                    var current_language = DEFAULT_LANGUAGE;
                                    if ($.cookie('auth') !== undefined && $.cookie('auth') !== null && authuser.user.language !== null && !_.isUndefined(authuser.user.language) && !_.isEmpty(authuser.user.language)) {
                                        current_language = authuser.user.language;
                                    }
                                    i18next.use(window.i18nextXHRBackend).use(window.i18nextSprintfPostProcessor).init({
                                        lng: current_language,
                                        fallbackLng: current_language,
                                        load: "all",
                                        keySeparator: '~',
                                        nsSeparator: '^',
                                        backend: {
                                            loadPath: "locales/{{lng}}/{{ns}}.json"
                                        }
                                    }, function() {
                                        if (page.model === "admin_user_add" || page.model === "register") {
                                            //@Todo
                                            page.call_function();

                                        } else {

                                            page.call_function();
                                        }
                                    });
                                }
                            });
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
                            localforage.setItem('apps', settings_response.apps_data).then(function() {
                                page.set_page_title();
                                FLICKR_API_KEY = settings_response.FLICKR_API_KEY;
                                DROPBOX_APPKEY = settings_response.DROPBOX_APPKEY;
                                LABEL_ICON = settings_response.LABEL_ICON;
                                SITE_TIMEZONE = settings_response.SITE_TIMEZONE;
                                IS_TWO_FACTOR_AUTHENTICATION_ENABLED = settings_response.IS_TWO_FACTOR_AUTHENTICATION_ENABLED;
                                DEFAULT_LANGUAGE = settings_response.DEFAULT_LANGUAGE;
                                PAGING_COUNT = settings_response.PAGING_COUNT;
                                ALLOWED_FILE_EXTENSIONS = settings_response.ALLOWED_FILE_EXTENSIONS;
                                R_LDAP_LOGIN_HANDLE = settings_response.R_LDAP_LOGIN_HANDLE;
                                APPS = settings_response.apps;
                                IMAP_EMAIL = settings_response.IMAP_EMAIL;
                                DEFAULT_CARD_VIEW = settings_response.DEFAULT_CARD_VIEW;
                                var current_language = DEFAULT_LANGUAGE;
                                if ($.cookie('auth') !== undefined && $.cookie('auth') !== null && authuser.user.language !== null && !_.isUndefined(authuser.user.language) && !_.isEmpty(authuser.user.language)) {
                                    current_language = authuser.user.language;
                                }
                                i18next.use(window.i18nextXHRBackend).use(window.i18nextSprintfPostProcessor).init({
                                    lng: current_language,
                                    fallbackLng: current_language,
                                    load: "all",
                                    keySeparator: '~',
                                    nsSeparator: '^',
                                    backend: {
                                        loadPath: "locales/{{lng}}/{{ns}}.json"
                                    }
                                }, function() {
                                    if (page.model === "admin_user_add" || page.model === "register") {
                                        //@Todo
                                        page.call_function();

                                    } else {
                                        page.call_function();
                                    }
                                });
                            });
                        }
                    });
                } else {
                    if (page.model === "admin_user_add" || page.model === "register") {
                        //@Todo
                        page.call_function();

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
            changeTitle(i18next.t('Login'));
        }
        if (this.model == 'user_verification') {
            changeTitle(i18next.t('Two-step Verification'));
        }
        if (this.model == 'aboutus') {
            changeTitle(i18next.t('About'));
        }
        if (this.model == 'admin_user_add') {
            changeTitle(i18next.t('Admin Add User'));
        }
        if (this.model == 'register') {
            changeTitle(i18next.t('Register'));
        }
        if (this.model == 'forgotpassword') {
            changeTitle(i18next.t('Forgot your password'));
        }
        if (this.model == 'user_activation') {
            changeTitle(i18next.t('User Activation'));
        }
        if (this.model == 'changepassword') {
            changeTitle(i18next.t('Change Password'));
        }
        if (this.model == 'settings') {
            changeTitle(i18next.t('Settings'));
        }
        if (this.model == 'boards_index') {
            changeTitle(i18next.t('Boards'));
        }
        if (this.model == 'starred_boards_index') {
            changeTitle(i18next.t('Starred Boards'));
        }
        if (this.model == 'closed_boards_index') {
            changeTitle(i18next.t('Closed Boards'));
        }
        if (this.model == 'organizations_view') {
            changeTitle(i18next.t('Organization'));
        }
        if (this.model == 'organizations_view_type') {
            changeTitle(i18next.t('Organization'));
        }
        if (this.model == 'organizations_user_view') {
            changeTitle(i18next.t('Organization User'));
        }
        if (this.model == 'users_index') {
            changeTitle(i18next.t('Users'));
        }
        if (this.model == 'user_logins_index') {
            changeTitle(i18next.t('User Logins'));
        }
        if (this.model == 'admin_boards_index') {
            changeTitle(i18next.t('Boards'));
        }
        if (this.model == 'role_settings' || this.model == 'add_role' || this.model == 'add_board_user_role' || this.model == 'add_organization_user_role') {
            changeTitle(i18next.t('Role Settings'));
        }
        if (this.model == 'oauth_clients') {
            changeTitle(i18next.t('Developer applications'));
        }
        if (this.model == 'add_oauth_client') {
            changeTitle(i18next.t('Register a new OAuth application'));
        }
        if (this.model == 'edit_oauth_client') {
            changeTitle(i18next.t('Edit OAuth application'));
        }
        if (this.model == 'apps' || this.model == 'app_settings') {
            changeTitle(i18next.t('Apps'));
        }
        if (this.model == 'apps' || this.model == 'app_settings_manage') {
            changeTitle(i18next.t('Apps Manage'));
        }
        if (this.model == 'organizations_index') {
            changeTitle(i18next.t('Organizations'));
        }
        if (this.model == 'email_templates') {
            changeTitle(i18next.t('Email Templates'));
        }
        if (this.model == 'email_template_type') {
            changeTitle(i18next.t('Email Templates'));
        }
        if (this.model == 'activity_index') {
            changeTitle(i18next.t('Activities'));
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
                        $.cookie('redirect_link', window.location.hash);
                        changeTitle('Board not found');
                        $('#content').html(new App.Board404View({
                            model: authuser
                        }).el);
                        this.headerView = new App.HeaderView({
                            model: authuser
                        });
                        $('#header').html(this.headerView.el);
                    } else {
                        var lists = {};
                        var boards = {};
                        if (response.lists) {
                            $.each(response.lists, function(list_key, list) {
                                if (list) {
                                    var cards = {};
                                    if (list.cards) {
                                        $.each(list.cards, function(card_key, card) {
                                            if (card) {
                                                cards[card.id] = card.custom_fields;
                                            }
                                        });
                                    }
                                    lists[list.id] = {
                                        custom_fields: list.custom_fields,
                                        cards: cards
                                    };
                                }
                            });
                        }
                        boards[response.id] = {
                            custom_fields: response.custom_fields,
                            lists: lists
                        };
                        custom_fields.boards = boards;
                        Board.authuser = self.authuser;
                        viewed_board = Board;
                        Board.board_user_roles = response.board_user_roles;
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
                        } else if (view_type === 'gantt') {
                            $('div.js-board-view-' + self.id).html('<div class="well-sm"></div><div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 well-lg"><div class="panel panel-default"><div class="panel-body text-center"><i class="fa fa-cog fa-spin"></i><h4 class="lead">' + i18next.t('Loading ....') + '</h4></div></div></div>');
                            _(function() {
                                $('.js-switch-timeline-view').trigger('click');
                            }).defer();
                            view_type = null;
                        } else if (view_type === 'report') {
                            $('div.js-board-view-' + self.id).html('<div class="well-sm"></div><div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 well-lg"><div class="panel panel-default"><div class="panel-body text-center"><i class="fa fa-cog fa-spin"></i><h4 class="lead">' + i18next.t('Loading ....') + '</h4></div></div></div>');
                            view_type = null;
                        } else if (view_type === 'attachments') {
                            $('.js-show-board-modal').trigger('click');
                            view_type = null;
                        } else if (view_type === null || view_type === '') {
                            $('.js-switch-grid-view').trigger('click');
                            view_type = null;
                        }
                        App.current_board = Board;
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
                                $('.js-notification-count').removeClass('hide').html(count);
                                favicon.badge(count);
                            }
                        }
                        var current_param = Backbone.history.fragment;
                        var current_param_split = current_param.split('/');
                        if (current_param.indexOf('list') === -1 && current_param.indexOf('calendar') === -1 && current_param.indexOf('gantt') === -1 && current_param.indexOf('report') === -1) {
                            $('a.js-switch-grid-view').parent().addClass('active');
                        }
                    }
                    self.board_view_height();
                },
                error: function(model, response) {
                    $.cookie('redirect_link', window.location.hash);
                    changeTitle('Board not found');
                    $('#content').html(new App.Board404View({
                        model: authuser
                    }).el);
                    this.headerView = new App.HeaderView({
                        model: authuser
                    });
                    $('#header').html(this.headerView.el);
                }
            });

        } else {
            if (view_type === 'list') {
                $('.js-switch-list-view').trigger('click');
                view_type = null;
            } else if (view_type === 'calendar') {
                $('.js-switch-calendar-view').trigger('click');
                view_type = null;
            } else if (view_type === 'gantt') {
                $('div.js-board-view-' + self.id).html('<div class="well-sm"></div><div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 well-lg"><div class="panel panel-default"><div class="panel-body text-center"><i class="fa fa-cog fa-spin"></i><h4 class="lead">' + i18next.t('Loading ....') + '</h4></div></div></div>');
                _(function() {
                    $('.js-switch-timeline-view').trigger('click');
                }).defer();
                view_type = null;
            } else if (view_type === 'report') {
                $('div.js-board-view-' + self.id).html('<div class="well-sm"></div><div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 well-lg"><div class="panel panel-default"><div class="panel-body text-center"><i class="fa fa-cog fa-spin"></i><h4 class="lead">' + i18next.t('Loading ....') + '</h4></div></div></div>');
                view_type = null;
            } else if (view_type === 'attachments') {
                $('.js-show-board-modal').trigger('click');
                view_type = null;
            } else if (_.isUndefined(view_type) || view_type === null || view_type === '') {
                $('.js-switch-grid-view').trigger('click');
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
                if (!_.isUndefined(response.error) && response.error.message === 'Unauthorized') {
                    $.cookie('redirect_link', window.location.hash);
                    changeTitle('Organization not found');
                    $('#content').html(new App.Organization404View({
                        model: authuser
                    }).el);
                    this.headerView = new App.HeaderView({
                        model: authuser
                    });
                    $('#header').html(this.headerView.el);
                } else {
                    Organization.boards.add(Organization.attributes.boards_listing);
                    Organization.organization_user_roles = response.organization_user_roles;
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
        var fragment = Backbone.history.fragment.split('?');
        fragment = fragment['0'];
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
                    var organizations = new App.OrganizationCollection();
                    organizations.url = api_url + 'organizations.json?type=simple';
                    organizations.fetch({
                        cache: false,
                        abortPending: true,
                        success: function(collections, response) {
                            auth_user_organizations = organizations;
                            if ((_.indexOf(adminUrl, fragment) >= 0 && !_.isEmpty(authuser.user) && authuser.user.role_id == 1) || _.indexOf(adminUrl, fragment) < 0) {
                                page.callback();
                            } else {
                                app.navigate('#/boards', {
                                    trigger: true,
                                    replace: true
                                });
                            }
                        }
                    });
                }
            });
        } else {
            if ((_.indexOf(adminUrl, fragment) >= 0 && !_.isEmpty(authuser.user) && authuser.user.role_id == 1) || _.indexOf(adminUrl, fragment) < 0) {
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
        $.cookie('previous_url', Backbone.history.getFragment());
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
        $('.company').addClass('hide');
        if (page.model == 'boards_view') {
            if (!$('body').hasClass('board-view')) {
                $('body').css('background', 'transparent');
            }
            page.board_view();
        } else if (page.model == 'organizations_view') {
            changeTitle(i18next.t('Organization'));
            page.organization_view();
        } else if (_.isEmpty(authuser.user) && _.indexOf(loginExceptionUrl, page.model) <= -1) {
            $.cookie('redirect_link', window.location.hash);
            app.navigate('#/users/login', {
                trigger: true,
                replace: true
            });
        } else if (!_.isEmpty(authuser.user) && _.indexOf(loginExceptionUrl, page.model) > -1) {
            if (page.model == 'aboutus') {
                changeTitle(i18next.t('About'));
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
                changeTitle(i18next.t('Admin Add User'));
                var timezone = new App.User();
                timezone.url = api_url + 'timezones.json';
                timezone.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(timezone, response) {
                        var AdminUser = new App.User();
                        AdminUser.timezones = response;
                        this.pageView = new App.AdminUserAddView({
                            model: AdminUser
                        });
                        $('#content').html(this.pageView.el);
                    }
                });
            } else if (page.model == 'register') {
                changeTitle(i18next.t('Register'));
                $('.company').removeClass('hide');
                var User = new App.User();
                if (!_.isEmpty(role_links.where({
                        slug: 'users_register'
                    }))) {
                    this.pageView = new App.RegisterView({
                        model: User
                    });
                    $('#content').html(this.pageView.el);
                } else {
                    app.navigate('#/users/login', {
                        trigger: true,
                        replace: true
                    });
                }
            } else if (page.model == 'login') {
                changeTitle(i18next.t('Login'));
                $('.company').removeClass('hide');
                var LoginUser = new App.User();
                this.pageView = new App.LoginView({
                    model: LoginUser
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'user_verification') {
                changeTitle(i18next.t('Two-step Verification'));
                $('.company').removeClass('hide');
                var user_verification = new App.User();
                user_verification.url = api_url + 'users/' + page.id + '.json';
                user_verification.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(user_verification, response) {
                        this.pageView = new App.AuthenticateView({
                            model: user_verification,
                            templateName: 'two-step-verification'
                        });
                        $('#content').html(this.pageView.el);
                    }
                });
            } else if (page.model == 'forgotpassword') {
                changeTitle(i18next.t('Forgot your password'));
                $('.company').removeClass('hide');
                var ForgotPasswordUser = new App.User();
                this.pageView = new App.ForgotpasswordView({
                    model: ForgotPasswordUser
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'user_activation') {
                changeTitle(i18next.t('User Activation'));
                var UserActivation = new App.User();
                UserActivation.user_id = page.id;
                UserActivation.hash = page.page_view_hash;
                this.pageView = new App.UseractivationView({
                    model: UserActivation
                });
            } else if (page.model == 'changepassword') {
                changeTitle(i18next.t('Change Password'));
                var ChangePasswordUser = new App.User();
                ChangePasswordUser.user_id = page.id;
                this.pageView = new App.ChangepasswordView({
                    model: ChangePasswordUser
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'aboutus') {
                changeTitle(i18next.t('About'));
                this.pageView = new App.AboutusView();
                $('#content').html(this.pageView.el);
            } else if (page.model == 'boards_index' || page.model == 'starred_boards_index' || page.model == 'closed_boards_index') {
                changeTitle(i18next.t('Boards'));
                var page_title = i18next.t('My Boards');
                if (page.model == 'starred_boards_index') {
                    changeTitle(i18next.t('Starred Boards'));
                    page_title = i18next.t('Starred Boards');
                } else if (page.model == 'closed_boards_index') {
                    changeTitle(i18next.t('Closed Boards'));
                    page_title = i18next.t('Closed Boards');
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
                                board_index.append(new App.UserDashboardView({
                                    model: page_title,
                                }).el);
                                if (page.model == 'starred_boards_index') {
                                    board_index.append(new App.StarredBoardsIndexView().el);
                                    if (!_.isEmpty(role_links.where({
                                            slug: 'view_stared_boards'
                                        }))) {
                                        if (!_.isEmpty(response.starred_boards)) {
                                            var starred_board_collections = new App.BoardCollection();
                                            _.each(response.starred_boards, function(starred_board) {
                                                starred_board_collections.add(App.boards.findWhere({
                                                    id: parseInt(starred_board)
                                                }));
                                            });
                                            starred_board_collections.setSortField('name', 'asc');
                                            starred_board_collections.sort();
                                            var starred_boards = starred_board_collections.where({
                                                is_closed: 0,
                                                organization_id: 0
                                            });
                                            if (!_.isUndefined(starred_boards)) {
                                                _.each(starred_boards, function(starred_board) {
                                                    starred_board.board_subscribers.add(starred_board.attributes.boards_subscribers);
                                                    filter = _.matches({
                                                        is_archived: 0
                                                    });
                                                    filtered_lists = _.filter(starred_board.attributes.lists, filter);
                                                    starred_board.lists.add(filtered_lists);
                                                    $('.js-header-starred-boards').prepend(new App.BoardSimpleView({
                                                        model: starred_board,
                                                        id: 'js-starred-board-' + starred_board.attributes.id,
                                                        className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad js-board-view js-board-view-' + starred_board.attributes.id,
                                                        starred_boards: response.starred_boards
                                                    }).el);
                                                });
                                            }
                                            starred_board_collections.setSortField('organization_name', 'asc');
                                            starred_board_collections.sort();
                                            var organization_starred_boards = starred_board_collections.filter(function(board) {
                                                if (parseInt(board.attributes.organization_id) !== 0 && parseInt(board.attributes.is_closed) === 0) {
                                                    return board;
                                                }
                                            });
                                            if (!_.isEmpty(organization_starred_boards) && !_.isUndefined(organization_starred_boards)) {
                                                _.each(organization_starred_boards, function(organization_starred_board) {
                                                    organization_starred_board.board_subscribers.add(organization_starred_board.attributes.boards_subscribers);
                                                    filter = _.matches({
                                                        is_archived: 0
                                                    });
                                                    filtered_lists = _.filter(organization_starred_board.attributes.lists, filter);
                                                    organization_starred_board.lists.add(filtered_lists);
                                                    if ($('.js-organization-starred-boards-' + organization_starred_board.attributes.organization_id).length === 0) {
                                                        var starred_board_organization_name = filterXSS(organization_starred_board.attributes.organization_name);
                                                        $('.js-header-starred-boards').parent().append('<div class="col-xs-12 js-organization-starred-boards-' + organization_starred_board.attributes.organization_id + '"><h4><a href="#/organization/' + organization_starred_board.attributes.organization_id + '" class="cur">' + i18next.t('%s', {
                                                            postProcess: 'sprintf',
                                                            sprintf: [starred_board_organization_name]
                                                        }) + '</a></h4></div>');
                                                    }
                                                    $('.js-organization-starred-boards-' + organization_starred_board.attributes.organization_id).append(new App.BoardSimpleView({
                                                        model: organization_starred_board,
                                                        id: 'js-starred-board-' + organization_starred_board.attributes.id,
                                                        className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad js-board-view js-board-view-' + organization_starred_board.attributes.id,
                                                        starred_boards: response.starred_boards
                                                    }).el);
                                                });
                                            }
                                            if ($('.js-header-starred-boards > .js-board-view').length === 0) {
                                                $('.js-header-starred-boards').append(new App.BoardSimpleView({
                                                    model: null,
                                                    message: i18next.t('No %s available.', {
                                                        postProcess: 'sprintf',
                                                        sprintf: [i18next.t('starred boards')]
                                                    }),
                                                    id: 'js-starred-board-empty',
                                                    className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12'
                                                }).el);
                                            }
                                        } else {
                                            $('.js-header-starred-boards').append(new App.BoardSimpleView({
                                                model: null,
                                                message: i18next.t('No %s available.', {
                                                    postProcess: 'sprintf',
                                                    sprintf: [i18next.t('starred boards')]
                                                }),
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
                                            is_closed: 1,
                                            organization_id: 0
                                        });
                                        App.boards.setSortField('name', 'asc');
                                        App.boards.sort();
                                        if (!_.isEmpty(closed_boards)) {
                                            _.each(closed_boards, function(closed_board) {
                                                closed_board.board_subscribers.add(closed_board.attributes.boards_subscribers);
                                                filter = _.matches({
                                                    is_archived: 0
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
                                                    message: i18next.t('No %s available.', {
                                                        postProcess: 'sprintf',
                                                        sprintf: [i18next.t('closed boards')]
                                                    }),
                                                    id: 'js-closed-board-empty',
                                                    className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12'
                                                }).el);
                                            }
                                        } else {
                                            $('.js-header-closed-boards').append(new App.BoardSimpleView({
                                                model: null,
                                                message: i18next.t('No %s available.', {
                                                    postProcess: 'sprintf',
                                                    sprintf: [i18next.t('closed boards')]
                                                }),
                                                id: 'js-closed-board-empty',
                                                className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12'
                                            }).el);
                                        }
                                        var organization_closed_boards = App.boards.filter(function(board) {
                                            if (parseInt(board.attributes.is_closed) == 1 && parseInt(board.attributes.organization_id) !== 0) {
                                                return board;
                                            }
                                        });
                                        App.boards.setSortField('organization_name', 'asc');
                                        App.boards.sort();
                                        if (!_.isEmpty(organization_closed_boards)) {
                                            _.each(organization_closed_boards, function(closed_organization_board) {
                                                if ($('.js-organization-' + closed_organization_board.attributes.organization_id).length === 0) {
                                                    if ($('.js-organization-closed-boards-' + closed_organization_board.attributes.organization_id).length === 0) {
                                                        var closed_board_organization_name = filterXSS(closed_organization_board.attributes.organization_name);
                                                        $('.js-header-closed-boards').parent().append('<div class="col-xs-12 js-organization-closed-boards-' + closed_organization_board.attributes.organization_id + '"><h4><a href="#/organization/' + closed_organization_board.attributes.organization_id + '" class="cur">' + i18next.t('%s', {
                                                            postProcess: 'sprintf',
                                                            sprintf: [closed_board_organization_name]
                                                        }) + '</a></h4></div>');
                                                    }
                                                }
                                                closed_organization_board.board_subscribers.add(closed_organization_board.attributes.boards_subscribers);
                                                filter = _.matches({
                                                    is_archived: 0
                                                });
                                                filtered_lists = _.filter(closed_organization_board.attributes.lists, filter);
                                                closed_organization_board.lists.add(filtered_lists);
                                                $('.js-organization-closed-boards-' + closed_organization_board.attributes.organization_id).append(new App.BoardSimpleView({
                                                    model: closed_organization_board,
                                                    id: 'js-my-board-' + closed_organization_board.attributes.id,
                                                    className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad js-board-view js-board-view-' + closed_organization_board.attributes.id,
                                                    starred_boards: response.starred_boards
                                                }).el);
                                            });
                                        }
                                    }
                                } else {
                                    board_index.append(new App.BoardsIndexView().el);
                                    App.boards.setSortField('name', 'asc');
                                    App.boards.sort();
                                    var my_boards = App.boards.where({
                                        is_closed: 0,
                                        organization_id: 0
                                    });
                                    if (!_.isEmpty(role_links.where({
                                            slug: 'view_my_boards'
                                        }))) {
                                        if (!_.isEmpty(my_boards)) {
                                            _.each(my_boards, function(my_board) {
                                                var my_board_filter = _.matches({
                                                    is_archived: 0
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
                                            $('.js-my-boards').append(new App.BoardSimpleView({
                                                model: null,
                                                id: 'js-my-board-empty',
                                                className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad',
                                            }).el);
                                            new App.FooterView({
                                                model: authuser,
                                                board_id: self.id,
                                                boards: my_boards
                                            });
                                        } else {
                                            $('.js-my-boards').append(new App.BoardSimpleView({
                                                model: null,
                                                id: 'js-my-board-empty',
                                                className: 'col-lg-3 col-md-3 col-sm-4 col-xs-12'
                                            }).el);
                                        }
                                        App.boards.setSortField('organization_name', 'asc');
                                        App.boards.sort();
                                        var organization_boards = App.boards.filter(function(board) {
                                            if (parseInt(board.attributes.is_closed) === 0 && parseInt(board.attributes.organization_id) !== 0) {
                                                return board;
                                            }
                                        });
                                        if (!_.isEmpty(organization_boards)) {
                                            _.each(organization_boards, function(board) {
                                                if ($('.js-organization-' + board.attributes.organization_id).length === 0) {
                                                    var organization_name = filterXSS(board.attributes.organization_name);
                                                    $('.js-my-boards').parent().append('<div class="col-xs-12 js-organization_boards js-organization-' + board.attributes.organization_id + '" data-organization_id ="' + board.attributes.organization_id + '" ><h4><a href="#/organization/' + board.attributes.organization_id + '" class="cur">' + i18next.t('%s', {
                                                        postProcess: 'sprintf',
                                                        sprintf: [organization_name]
                                                    }) + '</a></h4></div>');
                                                }
                                                var board_filter = _.matches({
                                                    is_archived: 0
                                                });
                                                var board_filtered_lists = _.filter(board.attributes.lists, board_filter);
                                                board.lists.add(board_filtered_lists);
                                                $('.js-organization-' + board.attributes.organization_id).append(new App.BoardSimpleView({
                                                    model: board,
                                                    id: 'js-my-board-' + board.attributes.id,
                                                    className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad js-board-view js-board-view-' + board.attributes.id,
                                                    starred_boards: response.starred_boards
                                                }).el);
                                            });
                                            $('.js-organization_boards').append(new App.BoardSimpleView({
                                                model: null,
                                                id: 'js-my-board-empty',
                                                className: 'col-lg-3 col-md-4 col-sm-4 col-xs-12 mob-no-pad',
                                            }).el);
                                        }
                                    }
                                }

                            }
                        });
                    }
                });
            } else if (page.model == 'users_index') {
                changeTitle(i18next.t('Users'));
                new App.AdminUserIndexView();
            } else if (page.model == 'user_logins_index') {
                changeTitle(i18next.t('Users Logins'));
                new App.AdminUserLoginView();
            } else if (page.model == 'admin_boards_index') {
                changeTitle(i18next.t('Boards'));
                new App.AdminBoardsListView();
            } else if (page.model == 'settings') {
                changeTitle(i18next.t('Settings'));
                $('#js-navbar-default').remove();
                $('#content').html(new App.SettingView({
                    id: page.page_view_id
                }).el);
            } else if (page.model == 'user_view') {
                var user = new App.User();
                user.url = api_url + 'users/' + page.id + '.json';
                user.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(user, response) {
                        $('#header').html(new App.UserViewHeaderView({
                            model: user,
                            type: page.page_view_type,
                            page: page,
                        }).el);
                        $('#content').html(new App.UserView({
                            model: user,
                            type: page.page_view_type,
                            page: page,
                        }).el);
                    }
                });
            } else if (page.model == 'role_settings') {
                changeTitle(i18next.t('Role Settings'));
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
                        var acl_board_links = new App.AclBoardLinksCollection();
                        acl_board_links.reset(response.acl_board_links);
                        var acl_organization_links = new App.AclOrganizationLinksCollection();
                        acl_organization_links.reset(response.acl_organization_links);
                        var organization_user_roles = new App.OrganizationUserRolesCollection();
                        organization_user_roles.reset(response.organization_user_roles);
                        var board_user_roles = new App.BoardUserRolesCollection();
                        board_user_roles.reset(response.board_user_roles);
                        $('#js-navbar-default').remove();
                        $('#content').html(new App.RoleSettingsView({
                            model: acl_links,
                            roles: roles,
                            acl_board_links: acl_board_links,
                            board_user_roles: board_user_roles,
                            acl_organization_links: acl_organization_links,
                            organization_user_roles: organization_user_roles
                        }).el);
                    }
                });
            } else if (page.model == 'add_role') {
                changeTitle(i18next.t('Add role'));
                $('#content').html(new App.RoleAddView().el);
            } else if (page.model == 'add_board_user_role') {
                changeTitle(i18next.t('Add board user role'));
                $('#content').html(new App.BoardUserRoleAddView().el);
            } else if (page.model == 'add_organization_user_role') {
                changeTitle(i18next.t('Add organization user role'));
                $('#content').html(new App.OrganizationUserRoleAddView().el);
            } else if (page.model == 'organizations_index') {
                changeTitle(i18next.t('Organizations'));
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
            } else if (page.model == 'oauth_clients') {
                changeTitle(i18next.t('Developer applications'));
                var oauth_clients = new App.OauthClientCollection();
                oauth_clients.url = api_url + 'oauth/clients.json';
                oauth_clients.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(collections, response) {
                        $('#js-navbar-default').remove();
                        $('#content').html(new App.OauthClientView({
                            model: response,
                        }).el);
                    }
                });
            } else if (page.model == 'add_oauth_client') {
                changeTitle(i18next.t('Register a new OAuth application'));
                var oauth_client = new App.OauthClient();
                this.pageView = new App.OauthClientAddView({
                    model: oauth_client
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'edit_oauth_client') {
                changeTitle(i18next.t('Edit OAuth application'));
                this.pageView = new App.OauthClientEditView({
                    id: page.page_view_id
                });
                $('#content').html(this.pageView.el);
            } else if (page.model == 'apps') {
                changeTitle(i18next.t('Apps'));
                var apps = new App.AppCollection();
                apps.url = api_url + 'apps.json';
                apps.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(collections, response) {
                        $('#js-navbar-default').remove();
                        $('#content').html(new App.AppsView({
                            model: response,
                        }).el);
                    }
                });
            } else if (page.model == 'app_settings') {
                changeTitle(i18next.t('App Settings'));
                var app_settings = new App.AppCollection();
                app_settings.url = api_url + 'apps/settings.json?app=' + page.page_view_id;
                app_settings.fetch({
                    cache: false,
                    abortPending: true,
                    success: function(collections, response) {
                        $('#js-navbar-default').remove();
                        $('#content').html(new App.AppSettingsView({
                            app_settings: response,
                            folder: page.page_view_id
                        }).el);
                    }
                });
            } else if (page.model == 'app_settings_manage') {
                changeTitle(i18next.t('App Settings Manage'));
                $('#js-navbar-default').remove();
                if (!_.isEmpty(authuser.user) && authuser.user.role_id == 1 && !_.isEmpty(page.options.name)) {
                    _(function() {
                        if (!_.isUndefined(App['admin_' + page.options.name + '_view'])) {
                            $('#content').html(new App['admin_' + page.options.name + '_view']().el);
                        }
                    }).defer();
                } else {
                    app.navigate('#/boards', {
                        trigger: true,
                        replace: true
                    });
                }
            } else if (page.model == 'app_page') {
                changeTitle(i18next.t('App Page'));
                $('#js-navbar-default').remove();
                if (!_.isEmpty(authuser.user) && authuser.user) {
                    var app_page = page.options.name + '_' + page.options.page;
                    if (!_.isUndefined(App.app_page)) {
                        _(function() {
                            $('#content').html(new App[app_page]().el);
                        }).defer();
                    }
                } else {
                    app.navigate('#/boards', {
                        trigger: true,
                        replace: true
                    });
                }
            } else if (page.model == 'email_template_type') {
                changeTitle(i18next.t('Email Templates'));
                $('#js-navbar-default').remove();
                $('#content').html(new App.EmailTemplateView({
                    id: page.page_view_id
                }).el);
            } else if (page.model == 'activity_index') {
                changeTitle(i18next.t('Activities'));
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
        if (($.cookie('auth') !== undefined && $.cookie('auth') !== null) || page.model == 'organizations_view') {
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
                    $('.js-notification-count').removeClass('hide').html(count);
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
