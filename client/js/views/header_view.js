/**
 * @fileOverview This file has functions related to header view. This view calling from application view and login view.
 * Available Object:
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Header View
 * @class HeaderView
 * @constructor
 * @extends Backbone.View
 */
App.HeaderView = Backbone.View.extend({
    template: JST['templates/header'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-open-popover': 'openPopup',
        'click .js-star-board': 'sidebarSubcribeBoard',
        'click .js-show-change-avatar-form': 'showChangeAvatarForm',
        'click .js-sort-by': 'sortBy'
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (options.users) {
            this.users = options.users;
        }
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        if (!_.isUndefined(this.users)) {
            var admins = this.users.filter(function(normal_user) {
                return normal_user.attributes.role_id === 1;
            });
            var admin_board_users = admins;
            this.admin_board_users = admin_board_users.length;
            var normal_users = this.users.filter(function(normal_user) {
                return normal_user.attributes.role_id !== 1;
            });
            var normal_board_users = normal_users;
            this.normal_board_users = normal_board_users.length;
        }
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.model.is_show_enable_notification = false;
        var current_param = Backbone.history.fragment.split('?');
        if (current_param[0].indexOf('/') === 0) {
            current_param[0] = current_param[0].substr(1);
        }
        var current_param_split = current_param[0].split('/');
        this.model.current_param = (current_param.indexOf('changepassword') === -1 && current_param.indexOf('login') === -1 && current_param.indexOf('forgotpassword') === -1 && current_param.indexOf('register') === -1 && current_param.indexOf('activation') === -1) ? current_param_split[0] : '';
        if (!_.isEmpty(current_param_split[1]) && current_param_split[1] === 'list') {
            this.model.current_param = 'admin_boards_list';
        }
        if (!_.isEmpty(current_param_split[2]) && current_param_split[2] === 'changepassword') {
            this.model.current_param = 'changepassword';
        }
        if (typeof Notification != 'undefined') {
            this.model.is_show_enable_notification = (Notification.permission == 'default') ? true : false;
        }
        if (!_.isUndefined(authuser.user) && !_.isEmpty(BOSH_SERVICE_URL)) {
            setTimeout(function() {
                converse.initialize({
                    bosh_service_url: BOSH_SERVICE_URL,
                    keepalive: true,
                    jid: authuser.user.username + '@' + JABBER_HOST,
                    authentication: 'prebind',
                    prebind_url: api_url + 'xmpp_login.json?token=' + api_token,
                    allow_logout: false,
                    allow_contact_requests: false,
                    hide_muc_server: true,
                    show_controlbox_by_default: true,
                    auto_list_rooms: true,
                    auto_reconnect: true,
                    play_sounds: true,
                    allow_registration: false
                });
            }, 1000);
        }
        this.$el.html(this.template(this.model));
        this.showTooltip();
        if (load_count === 1) {
            load_count++;
            _.each(APPS, function(app, key) {
                var s, l, v = '';
                if (key === 'settings') {
                    s = document.createElement('script');
                    _.each(app, function(client_id, key) {
                        v += "var " + client_id.name + " = '" + client_id.value + "';";
                    });
                    s.text = v;
                    document.body.appendChild(s);
                }
                if (key === 'js') {
                    _.each(app, function(js, key) {
                        s = document.createElement('script');
                        s.type = 'text/javascript';
                        s.src = js;
                        document.body.appendChild(s);
                    });
                }
                if (key === 'css') {
                    _.each(app, function(css, key) {
                        l = document.createElement('link');
                        l.rel = 'stylesheet';
                        l.type = 'text/css';
                        l.href = css;
                        document.head.appendChild(l);
                    });
                }
            });
        }
        return this;
    },
    renderList: function() {
        $('#content').html(new App.UserIndexContainerView({
            model: this.users,
            sortField: this.sortField,
            sortDirection: this.sortDirection
        }).el);
        $('.timeago', $('#content')).timeago();
    },
    sortBy: function(e) {
        e.preventDefault();
        var sortField = $(e.currentTarget).data('field');
        if (_.isUndefined(this.sortDirection)) {
            this.sortDirection = 'desc';
        } else {
            if (this.sortDirection === 'desc') {
                this.sortDirection = 'asc';
            } else {
                this.sortDirection = 'desc';
            }
        }
        this.sortField = sortField;
        this.renderList();
    },
    /**
     * openPopup()
     * show dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    openPopup: function(e) {
        var target = $(e.target).parents('.dropdown:first');
        target.addClass('open').prev('.dropdown').removeClass('open');
        target.next('.dropdown').removeClass('open');
        return false;
    },
    /**
     * closePopup()
     * close opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    }
});
