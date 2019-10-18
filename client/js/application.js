var api_token = '';
var role_links = new App.ACLCollection();
var settings = new App.SettingCategoryCollection();
var authuser = new App.User();
var auth_user_organizations = new App.OrganizationCollection();
var nativeSync = Backbone.sync;
var card_ids, card_ids_ref = '';
var view_type, view_type_ref = '';
var trigger_dockmodal = false;
var viewed_board = new App.Board();
var is_online = true;
var is_offline_data = false;
var set_interval_id = '';
var isRunning = false;
var is_append_activities = true;
var SITE_NAME = '';
var DROPBOX_APPKEY = '';
var FLICKR_API_KEY = '';
var LABEL_ICON = '';
var SITE_TIMEZONE = '';
var LDAP_LOGIN_ENABLED = '';
var IS_TWO_FACTOR_AUTHENTICATION_ENABLED;
var DEFAULT_LANGUAGE = '';
var IMAP_EMAIL = '';
var ANIMATION_SPEED = 1;
var DEFAULT_CARD_VIEW = '';
var CALENDAR_VIEW_CARD_COLOR = '';
var PAGING_COUNT = '';
var ALLOWED_FILE_EXTENSIONS = '';
var R_LDAP_LOGIN_HANDLE = '';
var R_MLDAP_LOGIN_HANDLE = '';
var R_MLDAP_SERVERS = '';
var last_activity = '';
var previous_date = '';
var SecuritySalt = 'e9a556134534545ab47c6c81c14f06c0b8sdfsdf';
var last_user_activity_id = 0,
    load_more_last_board_activity_id = 0,
    last_board_activity_id = 0,
    last_user_board_activity_id = 0;
var xhrPool = [];
var APPS = [];
var load_count = 1;
var load_gantt = 1;
var from_url = '';
var custom_fields = {};
var sort_by = '';
var sort_direction = '';
var view_type_tab = '';
var AppsFunction = [];
var appsurlFunc = {};
var overallApps = [];

Backbone.View.prototype.flash = function(type, message, delay, position) {
    if (!delay) {
        delay = 4000;
    }
    if (position) {
        position = 'bottom';
    } else {
        position = 'top';
    }

    $.bootstrapGrowl(message, {
        type: type,
        offset: {
            from: position,
            amount: 20
        },
        align: 'right',
        width: 250,
        delay: delay,
        allow_dismiss: true,
        stackup_spacing: 10
    });
};
Backbone.View.prototype.showTooltip = function() {
    $('[data-toggle="tooltip"]').tooltip();
};
Backbone.View.prototype.board_view_height = function(type, message) {
    var headerH = $('header').height();
    var footerH = $('footer').height();
    var windowH = $(window).height();
    var boardH = windowH - headerH - footerH - 50;
    $(".board-list-view").css("height", (boardH + 'px'));
};
Backbone.View.prototype.showImage = function(model, id, size, is_random) {
    var hash = calcMD5(SecuritySalt + model + id + 'png' + size);
    var image_url = window.location.pathname + 'img/' + size + '/' + model + '/' + id + '.' + hash + '.png';
    if (is_random)
        image_url = image_url + "?uid=" + Math.floor((Math.random() * 9999) + 1);
    return image_url;
};
Backbone.View.prototype.downloadLink = function(model, id) {
    var hash = calcMD5(SecuritySalt + model + id);
    var download_link = window.location.pathname + 'download/' + id + '/' + hash;
    return download_link;
};
Backbone.View.prototype.documentLink = function(model, data) {
    var extension = data.name.split('.');
    var ext = extension[extension.length - 1];
    var hash = calcMD5(SecuritySalt + 'CardAttachment' + data.id + ext + 'original');
    var document_link = window.location.pathname + 'img/original/CardAttachment/' + data.id + '.' + hash + '.' + ext;
    return document_link;
};
hasOfflineStatusCode = function(xhr) {
    var offlineStatusCodes, _ref, __indexOf = [].indexOf || function(item) {
        for (var i = 0, l = this.length; i < l; i++) {
            if (i in this && this[i] === item) return i;
        }
        return -1;
    };
    offlineStatusCodes = Backbone.DualStorage.offlineStatusCodes;
    if (_.isFunction(offlineStatusCodes)) {
        offlineStatusCodes = offlineStatusCodes(xhr);
    }
    if (xhr.statusText === 'abort') {
        return false;
    }
    return _.isUndefined(xhr) || xhr.status === 0 || (_ref = xhr.status, __indexOf.call(offlineStatusCodes, _ref) >= 0);
};
callbackTranslator = {
    forBackboneCaller: function(callback) {
        isTempId = function(id) {
            return _.isString(id) && id.length === 36 && id.indexOf('t') === 0;
        };
        return function(model, resp, options) {
            $('#progress').width('101%').delay(200).fadeOut(400, function() {
                $(this).remove();
            });
            if ((($.cookie('is_offline_data') !== undefined && $.cookie('is_offline_data') !== null) && $.cookie('is_offline_data') === "true")) {
                is_offline_data = true;
            } else {
                is_offline_data = false;
            }
            if (hasOfflineStatusCode(model)) {
                is_online = false;
                $.cookie('is_offline_data', true);
                is_offline_data = true;
                model.is_offline = true;
                $('.js-hide-on-offline').addClass('hide');
                $('#js-activity-loader').remove();
                $('#js-footer-brand-img').attr('title', i18next.t('Site is in offline')).attr('src', 'img/logo-icon-offline.png').attr('data-original-title', i18next.t('Site is in offline')).tooltip("show");
            } else {
                is_online = true;
                $('.js-hide-on-offline').removeClass('hide');
                $('#js-footer-brand-img').attr('title', i18next.t(SITE_NAME)).attr('src', 'img/logo-icon.png').attr('data-original-title', i18next.t(SITE_NAME)).tooltip("hide");
                delete model.is_offline;
            }
            if (is_online && is_offline_data) {
                is_offline_data = false;
                $.removeCookie('is_offline_data');
                $('#js-footer-brand-img').attr('title', i18next.t('Syncing...')).attr('src', 'img/logo-icon-sync.gif').attr('data-original-title', i18next.t('Syncing...')).tooltip("show");
                var offline_data = new App.ListCollection();
                offline_data.syncDirty();
            }
            var current_url = window.location.hash.split("/");
            if (model === null) {
                changeTitle('404 Page not found');
                this.headerView = new App.HeaderView({
                    model: authuser
                });
                $('#header').html(this.headerView.el);
                var view = new App.Error404View();
                $('#content').html(view.el);
                return;
            } else if (model !== null && !_.isUndefined(model.status) && model.status == '401') {
                if (!_.isUndefined(model.responseText) && !_.isEmpty(model.responseText) && JSON.parse(model.responseText).error.type === 'OAuth') {
                    api_token = '';
                    if ($.cookie('auth') !== undefined && $.cookie('auth') !== null) {
                        var Auth = JSON.parse($.cookie('auth'));
                        var refresh_token = Auth.refresh_token;
                        var get_token = new App.OAuth();
                        get_token.url = api_url + 'oauth.json?refresh_token=' + refresh_token;
                        get_token.fetch({
                            cache: false,
                            success: function(model, response) {
                                if (!_.isUndefined(response.access_token)) {
                                    Auth.access_token = response.access_token;
                                    Auth.refresh_token = response.refresh_token;
                                    api_token = response.access_token;
                                    $.cookie('auth', JSON.stringify(Auth));
                                    if (from_url !== 'board_view') {
                                        Backbone.history.loadUrl(Backbone.history.fragment);
                                    } else {
                                        return callback.call(null, model, resp, options);
                                    }
                                } else {
                                    app.navigate('#/users/logout', {
                                        trigger: true,
                                        replace: true
                                    });
                                }
                            }
                        });
                    } else {
                        app.navigate('#/users/logout', {
                            trigger: true,
                            replace: true
                        });
                    }
                } else if (!_.isUndefined(current_url) && current_url['1'] == 'board') {
                    $.cookie('redirect_link', window.location.hash);
                    changeTitle('Board not found');
                    this.headerView = new App.HeaderView({
                        model: authuser
                    });
                    $('#header').html(this.headerView.el);
                    $('#content').html(new App.Board404View({
                        model: authuser
                    }).el);
                    return;
                } else if (!_.isUndefined(current_url) && current_url['1'] == 'organization') {
                    $.cookie('redirect_link', window.location.hash);
                    changeTitle('Organization not found');
                    this.headerView = new App.HeaderView({
                        model: authuser
                    });
                    $('#header').html(this.headerView.el);
                    $('#content').html(new App.Organization404View({
                        model: authuser
                    }).el);
                    return;
                }
            } else {
                return callback.call(null, model, resp, options);
            }
        };
    }
};
Backbone.sync = function(method, model, options) {
    if (!_.isUndefined(model.storeName) && model.storeName === 'activity') {
        if (is_online && is_offline_data) {
            is_offline_data = false;
            $.removeCookie('is_offline_data');
            $('#js-footer-brand-img').attr('title', i18next.t('Syncing...')).attr('src', 'img/logo-icon-sync.gif').attr('data-original-title', i18next.t('Syncing...')).tooltip("show");
            var offline_data = new App.ListCollection();
            offline_data.syncDirty();
        }
    } else {
        if ($('#progress').length === 0) {
            $('body').append($('<div><dt/><dd/></div>').attr('id', 'progress'));
            $('#progress').width((50 + Math.random() * 30) + '%');
        }
    }
    if (model && method != 'read') {
        model.url += '?token=' + api_token;
    } else {
        if (typeof options.data == 'undefined') {
            options.data = {};
        }
        if (api_token !== '') {
            options.data.token = api_token;
        }
    }
    if (typeof model.url === 'string' && model.url.indexOf('.json') !== -1) {
        options.error = callbackTranslator.forBackboneCaller(options.error);
        options.success = callbackTranslator.forBackboneCaller(options.success);
    }
    if (method === 'read') {
        if (options.abortPending === true) {
            for (var i = 0; i < xhrPool.length; i++) {
                if (xhrPool[i].readyState > 0 && xhrPool[i].readyState < 4) {
                    xhrPool[i].abort();
                    xhrPool.splice(i, 1);
                }
            }
        }
        for (var j = 0; j < xhrPool.length; j++) {
            if (xhrPool[j].readyState === 4) {
                xhrPool.splice(j, 1);
            }
        }

        var xhr = nativeSync(method, model, options);
        xhrPool.push(xhr);
        return xhr;
    } else {
        return nativeSync(method, model, options);
    }
};
var RealXHRSend = XMLHttpRequest.prototype.send;
var requestCallbacks = [];
var responseCallbacks = [];

function fireRequestCallbacks(callbacks, xhr, arg) {
    for (var i = 0; i < callbacks.length; i++) {
        if (!_.isUndefined(arg) && !_.isUndefined(arg[0]) && arg[0] && !(arg[0] instanceof FormData)) {
            callbacks[i](xhr, arg);
        } else {
            callbacks[i](xhr);
        }
    }
}

function fireResponseCallbacks(callbacks, xhr) {
    for (var i = 0; i < callbacks.length; i++) {
        callbacks[i](xhr);
    }
}

function addRequestCallback(callback) {
    requestCallbacks.push(callback);
}

function addResponseCallback(callback) {
    responseCallbacks.push(callback);
}

function fireResponseCallbacksIfCompleted(xhr) {
    if (xhr.readyState === 4) {
        if (xhr.responseURL.indexOf(window.location.origin) !== -1) {
            fireResponseCallbacks(responseCallbacks, xhr);
        }
    }
}

function proxifyOnReadyStateChange(xhr) {
    var realOnReadyStateChange = xhr.onreadystatechange;
    if (realOnReadyStateChange) {
        xhr.onreadystatechange = function() {
            fireResponseCallbacksIfCompleted(xhr);
            realOnReadyStateChange();
        };
    }
}
XMLHttpRequest.prototype.send = function() {
    // Fire request callbacks before sending the request
    fireRequestCallbacks(requestCallbacks, this, arguments);
    // Wire response callbacks
    if (this.addEventListener) {
        var self = this;
        this.addEventListener("readystatechange", function() {
            fireResponseCallbacksIfCompleted(self);
        }, false);
    } else {
        proxifyOnReadyStateChange(this);
    }
    RealXHRSend.apply(this, arguments);
};
var AppRouter = Backbone.Router.extend({
    routes: {
        '': 'login',
        'about': 'about_us',
        'users/admin_user_add': 'admin_user_add',
        'users/register': 'register',
        'users/login': 'login',
        'users/logout': 'logout',
        'users/forgotpassword': 'forgotpassword',
        'users/activation/:id/:hash': 'user_activation',
        'users/:id/changepassword': 'changepassword',
        'users?query_param': 'users_index',
        'users': 'users_index',
        'user_logins?page=:page': 'user_logins_index',
        'user_logins': 'user_logins_index',
        'boards/list?query_param': 'admin_boards_index',
        'boards/list': 'admin_boards_index',
        'user/:id': 'user_view',
        'user/:id/two-step-verification': 'user_verification',
        'user/:id/:type': 'user_view_type',
        'boards': 'boards_index',
        'boards/starred': 'starred_boards_index',
        'boards/closed': 'closed_boards_index',
        'board/:id': 'boards_view',
        'board/:id/card/:card_id': 'card_view',
        'board/:id/:type': 'boards_view_type',
        'board/:id/:type/card/:card_id': 'board_card_view_type',
        'board/:id/:type/:tab': 'boards_view_type_tab',
        'board/:id/:type?query_param': 'boards_view_type',
        'organizations': 'organizations_index',
        'organization/:id': 'organizations_view',
        'organization/:id/:type': 'organizations_view_type',
        'organizations_user/:id': 'organizations_user_view',
        'roles': 'role_settings',
        'roles?tab=:tab': 'role_settings',
        'roles/add': 'add_role',
        'board_user_roles/add': 'add_board_user_role',
        'organization_user_roles/add': 'add_organization_user_role',
        'oauth_clients': 'oauth_clients',
        'oauth_clients/add': 'add_oauth_client',
        'oauth_clients/edit/:id': 'edit_oauth_client',
        'apps': 'apps',
        'apps/:name': 'app_settings',
        'apps/:name/manage': 'app_settings_manage',
        'apps/:name/:page': 'app_page',
        'settings': 'settings',
        'settings/:id': 'settings_type',
        'email_templates': 'email_templates',
        'email_templates/:id': 'email_template_type',
        'activities': 'activity_index',
        'search/:q': '_search'
    },
    initialize: function() {
        $('body').removeAttr('style');
    },
    about_us: function() {
        new App.ApplicationView({
            model: 'aboutus'
        });
    },
    admin_user_add: function() {
        new App.ApplicationView({
            model: 'admin_user_add'
        });
    },
    register: function() {
        $('.dockmodal, .dockmodal-overlay').remove();
        new App.ApplicationView({
            model: 'register'
        });
    },
    login: function() {
        $('.dockmodal, .dockmodal-overlay').remove();
        new App.ApplicationView({
            model: 'login'
        });
    },
    user_verification: function(id) {
        $('.dockmodal, .dockmodal-overlay').remove();
        new App.ApplicationView({
            model: 'user_verification',
            'id': id
        });
    },
    forgotpassword: function() {
        new App.ApplicationView({
            model: 'forgotpassword'
        });
    },
    user_activation: function(id, hash) {
        new App.ApplicationView({
            model: 'user_activation',
            'id': id,
            'hash': hash
        });
    },
    changepassword: function(id) {
        var Auth_check = JSON.parse($.cookie('auth'));
        if ($.cookie('auth') !== null) {
            if (Auth_check.user.id == id || Auth_check.user.role_id == '1') {
                new App.ApplicationView({
                    model: 'changepassword',
                    'id': id
                });
            } else {
                $('.dockmodal, .dockmodal-overlay').remove();
                var User = new App.User();
                User.url = api_url + 'users/logout.json';
                User.fetch({
                    cache: false,
                    success: function() {
                        $.removeCookie('auth');
                        api_token = '';
                        authuser = new App.User();
                        app.navigate('#/users/login', {
                            trigger: true,
                            replace: true
                        });
                        clearInterval(set_interval_id);
                    }
                });
            }
        } else {
            $.cookie('redirect_link', window.location.hash);
            new App.ApplicationView({
                model: 'login'
            });
        }
    },
    logout: function() {
        $('.dockmodal, .dockmodal-overlay').remove();
        var User = new App.User();
        User.url = api_url + 'users/logout.json';
        User.fetch({
            cache: false,
            success: function() {
                $.removeCookie('auth');
                delete(App.boards);
                custom_fields = {};
                $.removeCookie('chat_initialize');
                $.removeCookie('filter');
                $.removeCookie('activities_filter');
                localforage.clear();
                api_token = '';
                authuser = new App.User();
                app.navigate('#/users/login', {
                    trigger: true,
                    replace: true
                });
                clearInterval(set_interval_id);
                if (!_.isUndefined(authuser.user) && !_.isEmpty(BOSH_SERVICE_URL)) {
                    converse.user.logout();
                }
                $('#conversejs').remove();
                var view = new Backbone.View();
                view.flash('success', 'Logout successfully.');
            }
        });
        if ($('#content').hasClass('intro_video')) {
            $('#content').removeClass('intro_video');
        }
    },
    settings: function() {
        new App.ApplicationView({
            model: 'settings'
        });
    },
    settings_type: function(id) {
        new App.ApplicationView({
            model: 'settings',
            id: id
        });
    },
    boards_index: function() {
        new App.ApplicationView({
            model: 'boards_index'
        });
    },
    starred_boards_index: function() {
        new App.ApplicationView({
            model: 'starred_boards_index'
        });
    },
    closed_boards_index: function() {
        new App.ApplicationView({
            model: 'closed_boards_index'
        });
    },
    boards_view: function(id) {
        from_url = 'board_view';
        new App.ApplicationView({
            model: 'boards_view',
            'id': id
        });
    },
    card_view: function(id, card_id) {
        history.pushState(null, document.title, window.location.href);
        card_ids = card_id;
        card_ids_ref = card_id.split(',').map(Number);
        new App.ApplicationView({
            model: 'boards_view',
            'id': id
        });
    },
    board_card_view_type: function(id, type, card_id) {
        view_type = type;
        view_type_ref = type;
        card_ids = card_id;
        card_ids_ref = card_id.split(',').map(Number);
        new App.ApplicationView({
            model: 'boards_view',
            'id': id
        });
    },
    boards_view_type: function(id, type) {
        view_type = type;
        view_type_ref = type;
        new App.ApplicationView({
            model: 'boards_view',
            'id': id
        });
    },
    boards_view_type_tab: function(id, type, tab) {
        view_type = type;
        view_type_tab = tab;
        view_type_ref = type;
        new App.ApplicationView({
            model: 'boards_view',
            'id': id
        });
    },
    organizations_view: function(id) {
        new App.ApplicationView({
            model: 'organizations_view',
            'id': id
        });
    },
    organizations_view_type: function(id, type) {
        new App.ApplicationView({
            model: 'organizations_view',
            'id': id,
            'type': type
        });
    },
    organizations_user_view: function(id) {
        changeTitle(i18next.t('Organization User'));
        new App.ApplicationView({
            model: 'organizations_user_view',
            'id': id
        });
    },
    users_index: function(page) {
        new App.ApplicationView({
            model: 'users_index',
            page: page
        });
    },
    user_logins_index: function(page) {
        new App.ApplicationView({
            model: 'user_logins_index',
            page: page
        });
    },
    admin_boards_index: function(page) {
        new App.ApplicationView({
            model: 'admin_boards_index',
            page: page
        });
    },
    user_view: function(id) {
        new App.ApplicationView({
            model: 'user_view',
            'id': id
        });
    },
    user_view_type: function(id, type) {
        if ($.cookie('auth') !== null && !_.isUndefined($.cookie('auth')) && !_.isEmpty($.cookie('auth'))) {
            var Auth_check = JSON.parse($.cookie('auth'));
            if (Auth_check.user.id == id || Auth_check.user.role_id == '1' || type === 'cards' || type === "profile") {
                new App.ApplicationView({
                    model: 'user_view',
                    'id': id,
                    type: type
                });
            } else {
                $('.dockmodal, .dockmodal-overlay').remove();
                var User = new App.User();
                User.url = api_url + 'users/logout.json';
                User.fetch({
                    cache: false,
                    success: function() {
                        $.removeCookie('auth');
                        api_token = '';
                        authuser = new App.User();
                        app.navigate('#/users/login', {
                            trigger: true,
                            replace: true
                        });
                        clearInterval(set_interval_id);
                    }
                });
            }
        } else {
            $.cookie('redirect_link', window.location.hash);
            new App.ApplicationView({
                model: 'user_view',
                'id': id,
                type: type
            });
        }
    },
    role_settings: function(tab) {
        new App.ApplicationView({
            model: 'role_settings',
            tab: tab
        });
    },
    add_role: function() {
        new App.ApplicationView({
            model: 'add_role',
        });
    },
    add_board_user_role: function() {
        new App.ApplicationView({
            model: 'add_board_user_role',
        });
    },
    add_organization_user_role: function() {
        new App.ApplicationView({
            model: 'add_organization_user_role',
        });
    },
    oauth_clients: function() {
        new App.ApplicationView({
            model: 'oauth_clients',
        });
    },
    add_oauth_client: function() {
        new App.ApplicationView({
            model: 'add_oauth_client',
        });
    },
    edit_oauth_client: function(id) {
        new App.ApplicationView({
            model: 'edit_oauth_client',
            'id': id
        });
    },
    apps: function() {
        new App.ApplicationView({
            model: 'apps',
        });
    },
    app_settings: function(id) {
        new App.ApplicationView({
            model: 'app_settings',
            id: id
        });
    },
    app_settings_manage: function(name) {
        new App.ApplicationView({
            model: 'app_settings_manage',
            name: name
        });
    },
    app_page: function(name, page) {
        new App.ApplicationView({
            model: 'app_page',
            name: name,
            page: page
        });
    },
    organizations_index: function() {
        new App.ApplicationView({
            model: 'organizations_index'
        });
    },
    email_templates: function() {
        new App.ApplicationView({
            model: 'email_template_type'
        });
    },
    email_template_type: function(id) {
        new App.ApplicationView({
            model: 'email_template_type',
            id: id
        });
    },
    activity_index: function() {
        new App.ApplicationView({
            model: 'activity_index'
        });
    },
    _search: function(q) {
        new App.ApplicationView({
            model: 'boards_index',
            q: q
        });
    }
});
var app = new AppRouter();
app.on('route', function(route, params) {
    $('div.doughnutTip').remove();
    if (route !== 'boards_view' && route !== 'card_view' && route !== 'board_card_view_type' && route !== 'boards_view_type' && route !== 'boards_view_type_tab') {
        $('body').removeAttr('style class');
    }
});
$(window).on('hashchange', function() {
    if (location.hash === '#/boards' && $('#boards-index').length === 0) {
        app.navigate('#/boards', {
            trigger: true,
            replace: true
        });
        $('.js-footer-board-link').trigger('click');
    }
    if (!_.isUndefined(appsurlFunc)) {
        _.each(appsurlFunc, function(funct_names, url) {
            if (location.hash.match('/' + url)) {
                _.each(funct_names, function(functionName) {
                    if (typeof AppsFunction[functionName] === 'function') {
                        AppsFunction[functionName]();
                    }
                });
            } else {
                // Board view Page Navigation triggering
                if (location.hash.match('/board/([0-9])*/list')) {
                    if ($('#listview_table').length === 0) {
                        $('.js-switch-list-view').trigger('click');
                    }
                } else if (location.hash.match('/board/([0-9])*/calendar')) {
                    if ($('.calendar-view').length === 0) {
                        $('.js-switch-calendar-view').trigger('click');
                    }
                }
            }
        });
    }
});
Backbone.history.start({
    pushState: false
});

Backbone.form = function(schema) {
    var form = new Backbone.Form(schema).render();
    return form.el;
};
