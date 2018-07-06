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
 * @class AuthenticateView
 * @constructor
 * @extends Backbone.View
 */
App.AuthenticateView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (options.templateName) {
            this.templateName = options.templateName;
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
    template: JST['templates/authenticate'],
    tagName: 'section',
    className: 'clearfix',
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'submit form#UserAuthenticateForm': 'authenticateUser',
        'submit form#UserVerificationForm': 'verifyUser'
    },
    /**
     * authenticateUser()
     * user authentication
     * @return false
     *
     */
    authenticateUser: function(e) {
        var self = this;
        var target = $(e.target);
        var data = target.serializeObject();
        data.is_two_factor_authentication_enabled = true;
        if ($.trim(data.verification_code) === '') {
            $('.error-msg-userauthenticate').remove();
            $('<div class="error-msg-userauthenticate text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#inputCodeNumber');
        } else {
            $('.error-msg-userauthenticate').remove();
            var user = new App.User();
            user.url = api_url + 'users/' + authuser.user.id + '.json';
            user.set('id', parseInt(authuser.user.id));
            user.save(data,{
                success: function(model, response) {
                    if (response.error && response.code === 'verification_code') {
                        self.flash('danger', i18next.t("Entered verification code is wrong. Please try again."));
                    } else {
                        app.navigate('#/user/' + self.model.id + '/settings', {
                            trigger: true,
                            replace: true
                        });
                    }
                }
            });
        }
        return false;
    },
    /**
     * verifyUser()
     * user verification using authentication code,email,password 
     * @return false
     *
     */
    verifyUser: function(e) {
        e.preventDefault();
        var self = this;
        var target = $(e.target);
        var data = target.serializeObject();
        if ($.trim(data.verification_code) === '') {
            $('.error-msg-userverification').remove();
            $('<div class="error-msg-userverification text-primary h6">' + i18next.t('Whitespace is not allowed') + '</div>').insertAfter('#CodeNumber');
        } else {
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
                        auth_response.user.is_intro_video_skipped = response.user.is_intro_video_skipped;
                        auth_response.user.is_google_authenticator_enabled = response.user.is_google_authenticator_enabled;
                        $.cookie('auth', JSON.stringify(auth_response));
                        i18next.changeLanguage(response.user.language);
                        api_token = response.access_token;
                        var links = JSON.parse(response.links);
                        localforage.setItem("links", response.links);
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
                        $('input#CodeNumber', target).val('');
                        if (is_offline_data) {
                            self.flash('danger', i18next.t('Sorry, login failed. Internet connection not available.'));
                        } else {
                           if(response.code === 'verification_code') {
                                self.flash('danger', i18next.t("Entered verification code is wrong. Please try again."));
                            } else {
                                self.flash('danger', i18next.t('Sorry, login failed. Either your username or password or verification code are incorrect or admin deactivated your account.'));
                            }
                        }
                    }
                }
            });
        }
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            user: this.model,
            templateName: this.templateName 
        }));
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
