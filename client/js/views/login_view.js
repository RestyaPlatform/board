/**
 * @fileOverview This file has functions related to login view. This view calling from application view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Login View
 * @class LoginView
 * @constructor
 * @extends Backbone.View
 */
App.LoginView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
        this.changeFavicon();
    },
    template: JST['templates/login'],
    tagName: 'section',
    className: 'clearfix',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit': 'login'
    },
    /**
     * login()
     * user login
     * @return false
     *
     */
    login: function(e) {
        var self = this;
        var target = $(e.target);
        var data = target.serializeObject();
        if ($.trim(data.email) === '' || $.trim(data.password) === '') {
            if ($.trim(data.email) === '' && $.trim(data.password) === '') {
                $('.error-msg-username').remove();
                $('.error-msg-password').remove();
                $('<div class="error-msg-username text-primary h6">' + i18next.t('Whitespace alone not allowed') + '</div>').insertAfter('#inputEmail');
                $('<div class="error-msg-password text-primary h6">' + i18next.t('Whitespace alone not allowed') + '</div>').insertAfter('#inputPassword');
            } else if ($.trim(data.email) === '') {
                $('.error-msg-username').remove();
                $('<div class="error-msg-username text-primary h6">' + i18next.t('whitespace alone not allowed') + '</div>').insertAfter('#inputEmail');
            } else if ($.trim(data.password) === '') {
                $('.error-msg-password').remove();
                $('<div class="error-msg-password text-primary h6">' + i18next.t('Whitespace alone not allowed') + '</div>').insertAfter('#inputPassword');
            }
        } else {
            $('.error-msg-username').remove();
            $('.error-msg-password').remove();
            var user = new App.User();
            user.url = api_url + 'users/login.json';
            user.save(data, {
                success: function(model, response) {
                    authuser = response;
                    if (!_.isUndefined(response.access_token)) {
                        var auth_response = {};
                        auth_response.user = {};
                        auth_response.access_token = response.access_token;
                        auth_response.refresh_token = response.refresh_token;
                        auth_response.user.id = response.user.id;
                        auth_response.user.is_productivity_beats = response.user.is_productivity_beats;
                        auth_response.user.initials = response.user.initials;
                        auth_response.user.profile_picture_path = response.user.profile_picture_path;
                        auth_response.user.role_id = response.user.role_id;
                        auth_response.user.username = response.user.username;
                        auth_response.user.full_name = response.user.full_name;
                        auth_response.board_id = response.board_id;
                        auth_response.user.notify_count = response.user.notify_count;
                        auth_response.user.unread_activity_id = response.user.unread_activity_id;
                        auth_response.user.last_activity_id = response.user.last_activity_id;
                        auth_response.user.language = response.user.language;
                        auth_response.user.is_ldap = response.user.is_ldap;
                        $.cookie('auth', JSON.stringify(auth_response));
                        i18next.changeLanguage(response.user.language);
                        api_token = response.access_token;
                        var links = JSON.parse(response.links);
                        $.cookie('links', response.links);
                        role_links.reset();
                        if (!_.isEmpty(links)) {
                            role_links.add(links);
                        }
                        auth_user_organizations.add(authuser.user.organizations);
                        self.changeFavicon(response.user.notify_count);
                        this.headerView = new App.HeaderView({
                            model: model
                        });
                        $('.company').addClass('hide');
                        $('#header').html(this.headerView.el);
                        if (!_.isEmpty($.cookie('redirect_link'))) {
                            var redirect_link = $.cookie('redirect_link');
                            $.removeCookie('redirect_link');
                            window.location = redirect_link;
                        } else {
                            window.location = '#/boards';
                        }
                    } else {
                        $('input#inputPassword', target).val('');
                        if (is_offline_data) {
                            self.flash('danger', i18next.t('Sorry, login failed. Internet connection not available.'));
                        } else {
                            self.flash('danger', i18next.t('Sorry, login failed. Either your username or password are incorrect or admin deactivated your account.'));
                        }
                    }
                }
            });
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
        this.$el.html(this.template());
        this.showTooltip();
        return this;
    },
    /**
     * changeFavicon()
     * update notification count in favicon
     * @param count
     * @type number
     *
     */
    changeFavicon: function(count) {
        if (!_.isUndefined(count) && count !== '0') {
            favicon.badge(count);
        } else {
            favicon.badge(0);
        }
    }
});
