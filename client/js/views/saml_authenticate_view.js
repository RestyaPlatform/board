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
 * Authenticate View
 * @class SAMLAuthenticationView
 * @constructor
 * @extends Backbone.View
 */
App.SAMLAuthenticationView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (options.id) {
            this.id = options.id;
        }
        if (options.model) {
            this.model = options.model;
        }
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
        this.changeFavicon();
    },
    template: JST['templates/saml_authenticate'],
    tagName: 'section',
    className: 'clearfix',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        var self = this;
        this.$el.html(this.template({
            user: this.model
        }));
        var data = {};
        var user_email = this.id;
        var email = $.cookie('saml_email');
        var password = $.cookie('saml_pl');
        if (!_.isUndefined(email) && !_.isEmpty(email) && email !== null && !_.isUndefined(password) && !_.isEmpty(password) && password !== null && user_email === email) {
            data.email = email;
            data.password = password;
            var push_tokens = $.cookie('push_tokens');
            if (!_.isUndefined(push_tokens) && !_.isEmpty(push_tokens) && push_tokens !== null) {
                data.push_tokens = JSON.stringify(push_tokens);
            }
            var user = new App.User();
            user.url = api_url + 'users/login.json';
            user.save(data, {
                success: function(model, response) {
                    if (response.code === 'enter_verification_code') {
                        var authenticate_view = new App.AuthenticateView({
                            model: data,
                            templateName: 'user_login'
                        });
                        $('#content').html(authenticate_view.render().el);
                    } else if (is_offline_data) {
                        self.flash('danger', i18next.t('Sorry, login failed. Internet connection not available.'));
                    } else if (response.code === 'LDAP' && response.error === 'ERROR_LDAP_USER_LIMIT_EXCEED') {
                        self.flash('danger', i18next.t('Sorry, LDAP users limit exceed.'));
                    } else if (response.error === 'ERROR_LDAP_SERVER_CONNECT_FAILED') {
                        self.flash('danger', i18next.t('Error in LDAP connection. Please contact your system administrator.'));
                    } else if (response.error === 'ERROR_LDAP_AUTH_FAILED') {
                        self.flash('danger', i18next.t('Error in LDAP bind. Please contact your system administrator.'));
                    } else if (response.code === 'email' || (response.code === 'LDAP' && (response.error === 'ERROR_LDAP_EMAIL_NOT_ASSOCIATED' || response.error === 'ERROR_LDAP_PASSWORD_NOT_ASSOCIATED'))) {
                        self.flash('danger', i18next.t('Sorry, login failed. Either your username or password are incorrect or admin deactivated your account.'));
                    } else {
                        if (!_.isUndefined(response) && !_.isEmpty(response) && !_.isUndefined(response.user) && !_.isEmpty(response.user) && !_.isUndefined(response.user.is_two_factor_authentication_enabled)) {
                            authuser = response;
                            if (!_.isUndefined(response.access_token)) {
                                $.removeCookie('saml_email');
                                $.removeCookie('saml_pl');
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
                                auth_response.user.timezone = response.user.timezone;
                                auth_response.board_id = response.board_id;
                                auth_response.user.notify_count = response.user.notify_count;
                                auth_response.user.unread_activity_id = response.user.unread_activity_id;
                                auth_response.user.last_activity_id = response.user.last_activity_id;
                                auth_response.user.language = response.user.language;
                                auth_response.user.default_desktop_notification = response.user.default_desktop_notification;
                                auth_response.user.is_list_notifications_enabled = response.user.is_list_notifications_enabled;
                                auth_response.user.is_card_notifications_enabled = response.user.is_card_notifications_enabled;
                                auth_response.user.is_card_members_notifications_enabled = response.user.is_card_members_notifications_enabled;
                                auth_response.user.is_card_labels_notifications_enabled = response.user.is_card_labels_notifications_enabled;
                                auth_response.user.is_card_checklists_notifications_enabled = response.user.is_card_checklists_notifications_enabled;
                                auth_response.user.is_card_attachments_notifications_enabled = response.user.is_card_attachments_notifications_enabled;
                                auth_response.user.is_ldap = response.user.is_ldap;
                                auth_response.user.is_saml = response.user.is_saml;
                                auth_response.user.is_intro_video_skipped = response.user.is_intro_video_skipped;
                                auth_response.user.next_community_edition_popup_on = response.user.next_community_edition_popup_on;
                                auth_response.user.is_show_community_edition_popup = response.user.is_show_community_edition_popup;
                                auth_response.user.is_google_authenticator_enabled = response.user.is_google_authenticator_enabled;
                                $.cookie('auth', JSON.stringify(auth_response));
                                $.removeCookie('push_tokens');
                                i18next.changeLanguage(response.user.language);
                                api_token = response.access_token;
                                var links = JSON.parse(response.links);
                                localforage.setItem("links", response.links);
                                role_links.reset();
                                if (!_.isEmpty(links)) {
                                    role_links.add(links);
                                }
                                if (!_.isUndefined(APPS) && APPS !== null && !_.isEmpty(APPS.enabled_apps) && !_.isUndefined(APPS.enabled_apps) && APPS.enabled_apps !== null) {
                                    APPS.permission_checked_apps = [];
                                    _.each(APPS.enabled_apps, function(app) {
                                        if (!_.isEmpty(authuser.user) && !_.isUndefined(authuser.user)) {
                                            if ((!_.isEmpty(role_links.where({
                                                    slug: app
                                                })) || parseInt(authuser.user.role_id) === 1) && $.inArray(app, APPS.permission_checked_apps) === -1) {
                                                APPS.permission_checked_apps.push(app);
                                            }
                                        }
                                    });
                                }
                                auth_user_organizations.add(authuser.user.organizations);
                                self.changeFavicon(response.user.notify_count);
                                this.headerView = new App.HeaderView({
                                    model: model
                                });
                                $('.js-saml-loader').remove();
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
                                if (is_offline_data) {
                                    self.flash('danger', i18next.t('Sorry, login failed. Internet connection not available.'));
                                } else {
                                    self.flash('danger', i18next.t('Sorry, login failed. Either your username or password or verification code are incorrect or admin deactivated your account.'));
                                }
                            }
                        }
                    }
                }
            });
        } else {
            self.flash('danger', i18next.t('Sorry, login failed. Either your username or password are incorrect or admin deactivated your account.'));
            $('.js-saml-loader').remove();
        }
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
