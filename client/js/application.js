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
var DEFAULT_LANGUAGE = '';
var STANDARD_LOGIN_ENABLED = '';
var IMAP_EMAIL = '';
var ANIMATION_SPEED = 300;
var DEFAULT_CARD_VIEW = '';
var BOSH_SERVICE_URL = '';
var JABBER_HOST = '';
var JABBER_PATH = '';
var XMPP_CLIENT_RESOURCE_NAME = '';
var PAGING_COUNT = '';
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
var from_url = '';
var custom_fields = {};
var todo_lists = {};
var doing_lists = {};
var done_lists = {};
var TODO_COLOR = '';
var DOING_COLOR = '';
var DONE_COLOR = '';
var TODO_ICON = '';
var DOING_ICON = '';
var DONE_ICON = '';
Backbone.View.prototype.flash = function(type, message) {
    $.bootstrapGrowl(message, {
        type: type,
        offset: {
            from: 'top',
            amount: 20
        },
        align: 'right',
        width: 250,
        delay: 4000,
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
    var boardH = windowH - headerH - footerH - 14;
    boardH += 'px';
    $('.board-list-view').css('height', boardH);
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
            if (model !== null && !_.isUndefined(model.responseText) && !_.isEmpty(model.responseText)) {
                if (JSON.parse(model.responseText).error.type === 'board') {
                    changeTitle('404 Page not found');
                    this.headerView = new App.HeaderView({
                        model: authuser
                    });
                    $('#header').html(this.headerView.el);
                    $('#content').html(new App.Error404View().el);
                    return;
                } else if (JSON.parse(model.responseText).error.type === 'visibility') {
                    window.sessionStorage.setItem('redirect_link', window.location.hash);
                    changeTitle('Board not found');
                    this.headerView = new App.HeaderView({
                        model: authuser
                    });
                    $('#header').html(this.headerView.el);
                    $('#content').html(new App.Board404View({
                        model: authuser
                    }).el);
                    return;
                }
            }
            if (model === null) {
                changeTitle('404 Page not found');
                this.headerView = new App.HeaderView({
                    model: authuser
                });
                $('#header').html(this.headerView.el);
                var view = new App.Error404View();
                $('#content').html(view.el);
                return;
            }
            var is_online = false;

            if (((window.sessionStorage.getItem('is_offline_data') !== undefined && window.sessionStorage.getItem('is_offline_data') !== null) && window.sessionStorage.getItem('is_offline_data') === "true")) {
                is_offline_data = true;
            } else {
                is_offline_data = false;
            }

            if (hasOfflineStatusCode(options)) {
                window.sessionStorage.setItem('is_offline_data', true);
                is_offline_data = true;
                model.is_offline = true;
                $('.js-hide-on-offline').addClass('hide');
                $('#js-activity-loader').remove();
                $('#js-footer-brand-img').attr('title', i18next.t('Site is in offline')).attr('src', 'img/logo-icon-offline.png').tooltip("show");
            } else {
                is_online = true;
                $('.js-hide-on-offline').removeClass('hide');
                delete model.is_offline;
            }
            if (is_online && is_offline_data) {
                is_offline_data = false;
                window.sessionStorage.removeItem('is_offline_data');
                $('#js-footer-brand-img').attr('title', i18next.t('Syncing...')).attr('src', 'img/logo-icon-sync.gif').attr('data-original-title', i18next.t('Syncing...')).tooltip("show");
                var offline_data = new App.ListCollection();
                offline_data.syncDirty();
            }
            if (model !== null && !_.isUndefined(model.responseText) && !_.isEmpty(model.responseText) && JSON.parse(model.responseText).error.type === 'OAuth') {
                api_token = '';
                if (window.sessionStorage.getItem('auth') !== undefined && window.sessionStorage.getItem('auth') !== null) {
                    var Auth = JSON.parse(window.sessionStorage.getItem('auth'));
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
                                window.sessionStorage.setItem('auth', JSON.stringify(Auth));
                                if (from_url !== 'board_view') {
                                    Backbone.history.loadUrl(Backbone.history.fragment);
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
            } else {
                return callback.call(null, model, resp, options);
            }
        };
    }
};
Backbone.sync = function(method, model, options) {
    if (!_.isUndefined(model.storeName) && model.storeName === 'activity') {
        $('#js-footer-brand-img').attr('src', 'img/logo-icon-sync.gif');
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

function fireCallbacks(callbacks, xhr) {
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
        fireCallbacks(responseCallbacks, xhr);
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
    fireCallbacks(requestCallbacks, this);
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
        'users': 'users_index',
        'boards/list': 'admin_boards_index',
        'user/:id': 'user_view',
        'user/:id/:type': 'user_view_type',
        'boards': 'boards_index',
        'boards/starred': 'starred_boards_index',
        'boards/closed': 'closed_boards_index',
        'board/:id': 'boards_view',
        'board/:id/card/:card_id': 'card_view',
        'board/:id/:type': 'boards_view_type',
        'board/:id/:type/card/:card_id': 'board_card_view_type',
        'organizations': 'organizations_index',
        'organization/:id': 'organizations_view',
        'organization/:id/:type': 'organizations_view_type',
        'organizations_user/:id': 'organizations_user_view',
        'roles': 'role_settings',
        'roles/add': 'add_role',
        'board_user_roles/add': 'add_board_user_role',
        'organization_user_roles/add': 'add_organization_user_role',
        'oauth_clients': 'oauth_clients',
        'oauth_clients/add': 'add_oauth_client',
        'oauth_clients/edit/:id': 'edit_oauth_client',
        'apps': 'apps',
        'apps/:name': 'app_settings',
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
        var Auth_check = JSON.parse(window.sessionStorage.getItem('auth'));
        if (window.sessionStorage.getItem('auth') !== null) {
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
                        window.sessionStorage.removeItem('auth');
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
            window.sessionStorage.setItem('redirect_link', window.location.hash);
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
                window.sessionStorage.removeItem('auth');
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
                view.flash('success', i18next.t('Logout successfully.'));
            }
        });
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
    users_index: function() {
        new App.ApplicationView({
            model: 'users_index'
        });
    },
    admin_boards_index: function() {
        new App.ApplicationView({
            model: 'admin_boards_index'
        });
    },
    user_view: function(id) {
        new App.ApplicationView({
            model: 'user_view',
            'id': id
        });
    },
    user_view_type: function(id, type) {
        new App.ApplicationView({
            model: 'user_view',
            'id': id,
            type: type
        });
    },
    role_settings: function() {
        new App.ApplicationView({
            model: 'role_settings',
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
    if (route !== 'boards_view' && route !== 'card_view' && route !== 'board_card_view_type' && route !== 'boards_view_type') {
        $('body').removeAttr('style class');
    }
});
Backbone.history.start({
    pushState: false
});

Backbone.form = function(schema) {
    var form = new Backbone.Form(schema).render();
    return form.el;
};
